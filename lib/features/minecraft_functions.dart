import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'helpers/network_functions.dart';
import 'helpers/systemvars_functions.dart';
import 'minecraft_classes.dart';

// MARK: Getting Manifest
Future<List<DropdownMenuEntry>> getManifest(String path) async{
  String url = dotenv.env['SERVER_URL']!;
  String port = dotenv.env['SERVER_PORT']!;
  String uri = 'http://$url:$port';
  final response = await http.get(Uri.parse(uri));
  if (response.statusCode == 200) {
    // We don't need to download manifest if it's our versions
    // String manifestPath = '$path/versions';
    // String fileName = uri.split('/').last;
    // Downloading Manifest
    // getFile(manifestPath, fileName, uri);
    // Getting versions
    OurManifest manifest = OurManifest.fromJson(jsonDecode(response.body));
    List<DropdownMenuEntry> versionsList = List.empty(growable: true);
    for (Version version in manifest.versions!) {
      versionsList.add(DropdownMenuEntry(value: version, label: version.id));
    }
    return versionsList;
  } else {
    throw Exception('Failed to load manifest');
  }
}

// MARK: Dwnld JSON of ver.
Future<Package> downloadVersionJson(String uri, String path, String sha1) async{
  String fileName = uri.split('/').last;
  String versionName = fileName.split('.json').first;
  String versionPath = '$path/versions/$versionName';
  // Downloading JSON file
  await getFile(versionPath, fileName, uri, sha1);
  
  // And getting that JSON for other functions
  final response = await http.get(Uri.parse(uri));
  Package package = Package.fromJson(jsonDecode(response.body));
  return package;
}

// MARK: Download Libraries
Future<String> downloadLibraries(Package package, String path) async{
  String classpath = '';
  for (final library in package.libraries!) {
    String uri = library.downloads!.artifact!.url as String;
    String sha1 = library.downloads!.artifact!.sha1 as String;
    String artifactPath = library.downloads!.artifact!.path as String;
    String libDir = '$path/libraries/';
    libDir += artifactPath;
    String libName = artifactPath.split('/').last;
    libDir = libDir.replaceAll('/$libName', '').trim();
    // Adding path to the library for the classpath
    classpath += '$libDir/$libName;';
    await getFileMD(libDir, libName, uri, sha1);
  }
  return classpath;
}

// MARK: Download Client
Future<void> downloadClient(Package package, String path) async{
  String uri = package.downloads!.client!.url as String;
  String sha1 = package.downloads!.client!.sha1 as String;
  String versionName = package.id!;
  String clientName = '$versionName.jar';
  String clientPath = '$path/versions/$versionName';
  await getFileMD(clientPath, clientName, uri, sha1);
}

//MARK: Download Assets
Future<void> downloadAssets(Package package, String path) async{
  String uri = package.assetIndex!.url as String;
  String sha1JSON = package.assetIndex!.sha1 as String;
  List<String> paths = List.empty(growable: true);
  // List<String> fileNames; // Assets use hash as their name, so we don't need to use it
  List<String> uris = List.empty(growable: true);
  List<String> hashes = List.empty(growable: true);
  final assetsResponse = await http.get(Uri.parse(uri));
  if (assetsResponse.statusCode == 200) {
    // We have to download resource index file for MC to read
    String indFileName = uri.split('/').last;
    String indexesPath = '$path/assets/indexes';
    await getFile(indexesPath, indFileName, uri, sha1JSON);
    // Now download the assets
    Assets assets = Assets.fromJson(jsonDecode(assetsResponse.body));
    for (final asset in assets.objects.values) {
      String hash = asset['hash'];
      hashes.add(hash);
      // We have to take first two symbols of its hash. Let's name them initials (why not?)
      String initials = hash[0] + hash[1];
      // Then we have to create a folder for that asset and save it
      String assetPath = '$path/assets/objects/$initials';
      paths.add(assetPath);
      String assetUri = 'https://resources.download.minecraft.net/$initials/$hash';
      uris.add(assetUri);
    }
    // getTwoFiles(paths, hashes, uris, hashes);
    await parallelDownload(paths, hashes, uris, hashes);
  }
  else {
    throw Exception('Failed to get the assets json');
  }
}

// MARK: Launch Minecraft
void launchMinecraft(Package package, String path, var libCP) async{
  String versionName = package.id!;
  Map userJavas = getJavas();
  int neededJava = package.javaVersion!.majorVersion!;
  String? javaPath;
  // Getting first path to java
  for (final java in userJavas.entries) {
    var id = java.key;
    var majorVersion = userJavas[id]?.keys.first;
    if (majorVersion == neededJava) {
      javaPath = userJavas[id]?[majorVersion];
      break;
    }   
  }
  
  if (javaPath == null) {
    return;
  }
  
  // List gameArgs = package.arguments!.game!;
  // List jvmArgs = package.arguments!.jvm!;
  String nativesDirectory = '$path/libraries';
  String mainClass = package.mainClass!;
  String assetsIndexName = package.assets!;
  
  // await Process.run(
  // 	'$javaPath/javaw.exe', 
  // 	[
  // 		// JVM arguments
  //     '-Dlog4j.configurationFile=$path/launcherlogs'
  // 		'-Djava.library.path=$nativesDirectory', 
  // 		'-Djna.tmpdir=$nativesDirectory', 
  // 		'-Dorg.lwjgl.system.SharedLibraryExtractPath=$nativesDirectory', 
  // 		'-Dio.netty.native.workdir=$nativesDirectory', 
  // 		'-cp', 
  // 		'$libCP;$path/versions/$versionName/$versionName.jar', 
  // 		// Main class path
  // 		mainClass, 
  // 		// Game arguments
  // 		'--version', 
  // 		versionName, 
  // 		'--gameDir',
  // 		path,
  // 		'--assetsDir',
  // 		'$path/assets',
  // 		'--assetIndex',
  // 		assetsIndexName,
  // 		'--accessToken', 
  // 		'1', 
  // 	]
  // );
  // print(log.stdout);
  // print(log.stderr);
}
