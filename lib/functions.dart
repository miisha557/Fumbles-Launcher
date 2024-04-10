import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'classes.dart';

export 'functions.dart';

Future<List<DropdownMenuEntry>> fetchManifest() async {
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
