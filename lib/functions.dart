import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'classes.dart';

export 'functions.dart';

Future<List<DropdownMenuEntry>> basicFetchVersions() async {
	final response = await http.get(Uri.parse('https://piston-meta.mojang.com/mc/game/version_manifest_v2.json'));

	if (response.statusCode == 200) {
		// If the server did return a 200 OK response,
		// then parse the JSON.
		var manifest = Manifest.fromJson(jsonDecode(response.body));
		List<DropdownMenuEntry> versions = List.empty(growable: true);
		for (int i = 0; i < manifest.versions.length; i++) {
			var version = manifest.versions[i];
			versions.add(DropdownMenuEntry(value: version['url'], label: version['id']));
		}
		return versions;
	} else {
		// If the server did not return a 200 OK response,
		// then throw an exception.
		throw Exception('Failed to load manifest');
	}
}

Future<void> fetchManifest() async{
  
}

Future<void> downloadManifest(String path) async{
  final dio = Dio();
  try {
    await Directory('$path/version').create(recursive: true);
    await dio.download('https://piston-meta.mojang.com/mc/game/version_manifest_v2.json', '$path/version/version_manifest_v2.json');
    }
  catch (e) {
    print(e.toString());
  }
}

Future<void> downloadVersionJson(String uri, String version, String path) async{
	final dio = Dio();
  var versionPath = version.split('.json').first;
  try {
    await Directory('$path/version/$versionPath').create(recursive: true);
    await dio.download(uri, '$path/version/$versionPath/version');
  }
  catch (e) {
    print(e.toString());
  }
}

Future<void> downloadLibraries(String version) async{
  final dio = Dio();
  final response = await http.get(Uri.parse(version));
  if (response.statusCode == 200) {
		Package package = Package.fromJson(jsonDecode(response.body));
    // print('meme');
    for (Artifact artifact in package) {
      
    }
  } else {
		throw Exception('Failed to load manifest');
	}
}

// void startMinecraft() {
// 	setArguments();
// 	getLibraries();
// 	downloadClient();
// }
