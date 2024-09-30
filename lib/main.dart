import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/minecraft_classes.dart';
import 'features/minecraft_functions.dart';

Future main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<DropdownMenuEntry>>? versions;
  final TextEditingController versionController = TextEditingController();
  Version? selectedVersion;
  String pathValue = 'C:/Games/Minecraft/Fumbles';

  @override
  void initState() {
    super.initState();
    versions = getManifest(pathValue);
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
                        setState(() {
                          selectedVersion = value;
                        });
                        versionController.text = selectedVersion!.url;
                      },
                      helperText: selectedVersion?.url.toString(),
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
                onPressed: selectedVersion == null ? null : () async{
                  var pathValueOrig = pathValue;
                  
                  showDialog(context: context, builder: (BuildContext context) => const AlertDialog(
                    title: Text('AlertDialog Title'),
                    content: Text('AlertDialog description'),
                  ) );
                  
                  Package verPackage = await downloadVersionJson(selectedVersion!.url, pathValue, selectedVersion!.sha1);
                  // String libCP = await downloadLibraries(verPackage, pathValue);
                  // await downloadClient(verPackage, pathValue);
                  // await downloadAssets(verPackage, pathValue);
                  // launchMinecraft(verPackage, pathValue, libCP);
                  
                  pathValue = pathValueOrig;
                },
                child: const Text('Get and launch Minecraft')
              ),
              // const DownloadButton(),
            ],
          ),
        ),
      ),
    );
  }
}
