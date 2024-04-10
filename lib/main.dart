import 'dart:async';

import 'package:flutter/material.dart';

import 'functions.dart';
import 'classes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
	const MyApp({super.key});

	@override
	State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
	late Future<List<DropdownMenuEntry>> versions;
	Version? selectedVersion;

	@override
	void initState() {
		super.initState();
		versions = fetchManifest();
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
					child: Column(
						children: [
							FutureBuilder(
								future: versions,
								builder: (context, snapshot) {
									if (snapshot.hasData) {
										return DropdownMenu(dropdownMenuEntries: snapshot.data!);
									} else if (snapshot.hasError) {
										return Text('${snapshot.error}');
									}
									// By default, show a loading spinner.
									return const CircularProgressIndicator();
								}
							),
						],
					),
				),
			),
		);
	}
}
