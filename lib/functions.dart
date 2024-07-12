import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './helpers/network_functions.dart';
import 'classes.dart';

export 'functions.dart';

// MARK: Getting Manifest
Future<List<DropdownMenuEntry>> getManifest(String path) async{
  String uri = 'https://piston-meta.mojang.com/mc/game/version_manifest_v2.json';
  final response = await http.get(Uri.parse(uri));
  if (response.statusCode == 200) {
    String manifestPath = '$path/versions';
    String fileName = uri.split('/').last;
    // Downloading Manifest
    getFile(manifestPath, fileName, uri);
    // Getting versions
		Manifest manifest = Manifest.fromJson(jsonDecode(response.body));
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
Future<Package> downloadVersionJson(String uri, String version, String path, String sha1) async{
	String versionName = version.split('.json').first;
  String versionPath = '$path/versions/$versionName';
  // Downloading JSON file
  await getFile(versionPath, version, uri, sha1);
  
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
    await getFile(libDir, libName, uri, sha1);
  }
	return classpath;
}

// MARK: Download Client
Future<void> downloadClient(Package package, String version, String path) async{
	var versionName = version.split('.json').first;
  String uri = package.downloads!.client!.url as String;
  String sha1 = package.downloads!.client!.sha1 as String;
  String clientName = '$versionName.jar';
  String clientPath = '$path/versions/$versionName';
  await getFile(clientPath, clientName, uri, sha1);
}

//MARK: Download Assets
Future<void> downloadAssets(Package package, String path) async{
  String uri = package.assetIndex!.url as String;
  String sha1JSON = package.assetIndex!.sha1 as String;
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
      // We have to take first two symbols of its hash. Let's name them initials (why not?)
      String initials = hash[0] + hash[1];
      // Then we have to create a folder for that asset and save it
      String assetPath = '$path/assets/objects/$initials';
      String assetUri = 'https://resources.download.minecraft.net/$initials/$hash';
      await getFile(assetPath, hash, assetUri, hash);
    }
  }
  else {
    throw Exception('Failed to get the assets json');
  }
}

// MARK: Launch Minecraft
void launchMinecraft(String path, String version, var libCP) async{
	var versionName = version.split('.json').first;
	var log = await Process.run(
		'C:/Program Files/Eclipse Adoptium/jre-21.0.2.13-hotspot/bin/java.exe', 
		[
			// JVM arguments
			'-Djava.library.path=$path/libraries', 
			'-Djna.tmpdir=$path/libraries', 
			'-Dorg.lwjgl.system.SharedLibraryExtractPath=$path/libraries', 
			'-Dio.netty.native.workdir=$path/libraries', 
			'-cp', 
			'$libCP;$path/versions/$versionName/$versionName.jar', 
			// Main class path
			'net.minecraft.client.main.Main', 
			// Game arguments
			'--version', 
			versionName, 
			'--gameDir',
			path,
			'--assetsDir',
			'$path/assets',
			'--assetIndex',
			'17',
			'--accessToken', 
			'1', 
		]
	);
	print(log.stdout);
	print(log.stderr);
}
