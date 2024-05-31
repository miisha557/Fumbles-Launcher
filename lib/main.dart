import 'dart:async';

import 'package:flutter/material.dart';

import 'functions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
	const MyApp({super.key});

	@override
	State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
	late Future<List<DropdownMenuEntry>> versions;
	final TextEditingController versionController = TextEditingController();
	String? selectedVersion;
	var pathValue = 'C:/Games/Minecraft/Fumbles';

	@override
	void initState() {
		super.initState();
		versions = basicFetchVersions();
	}

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Fetch Data Example',
			theme: ThemeData(
				colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
			),
			home: Scaffold(
				appBar: AppBar(
					title: const Text('Fumbles Launcher Dev'),
				),
				body: Center(
					child: Column(
						mainAxisSize: MainAxisSize.min,
						children: [
							SizedBox(
								width: 450,
								child: TextFormField(
									initialValue: pathValue,
									validator: (value) {
										if (value == null || value.isEmpty) {
											return 'Please enter some text';
										}
										return null;
									},
									onChanged: (value) {
										setState(() {
											pathValue = value;
										});
									},
								),
							),
              
							const SizedBox(height: 20),
              
							FutureBuilder(
								future: versions,
								builder: (context, snapshot) {
									if (snapshot.hasData) {
										return DropdownMenu(
											width: 700,
											hintText: 'Version',
											dropdownMenuEntries: snapshot.data!,
											onSelected: (value) {
												versionController.text = value;
												setState(() {
													selectedVersion = value;
												});
											},
											helperText: selectedVersion?.toString(),
										);
									} else if (snapshot.hasError) {
										return Text('${snapshot.error}');
									}
									// By default, show a loading spinner.
									return const CircularProgressIndicator();
								},
							),
              
							const SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: selectedVersion == null ? null : () {
                  var pathValueOrig = pathValue;
                  
                  var versionName = selectedVersion.toString().split('/').last;
                  downloadManifest(pathValue);
                  downloadVersionJson(selectedVersion.toString(), versionName, pathValue);
                  downloadLibraries(selectedVersion!);
                  
                  pathValue = pathValueOrig;
                },
                child: const Text('Download JSON of selected version')
              ),
						],
					),
				),
			),
		);
	}
}
