import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models.dart';

Future<Manifest> fetchManifest() async {
	final response = await http
			.get(Uri.parse('https://piston-meta.mojang.com/mc/game/version_manifest_v2.json'));

	if (response.statusCode == 200) {
		// If the server did return a 200 OK response,
		// then parse the JSON.
		return Manifest.fromJson(jsonDecode(response.body));
	} else {
		// If the server did not return a 200 OK response,
		// then throw an exception.
		throw Exception('Failed to load manifest');
	}
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
	const MyApp({super.key});

	@override
	State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
	late Future<Manifest> futureManifest;

	@override
	void initState() {
		super.initState();
		futureManifest = fetchManifest();
	}

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Fetch Data Example',
			theme: ThemeData(
				colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
			),
			home: Scaffold(
				appBar: AppBar(
					title: const Text('Fetch Data Example'),
				),
				body: Center(
					child: FutureBuilder<Manifest>(
						future: futureManifest,
						builder: (context, snapshot) {
							if (snapshot.hasData) {
								return Text(snapshot.data!.latest.release);
							} else if (snapshot.hasError) {
								return Text('${snapshot.error}');
							}

							// By default, show a loading spinner.
							return const CircularProgressIndicator();
						},
					),
				),
			),
		);
	}
}
