import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

export 'network_functions.dart';

/// Function to create a path to the file, check if file exists and is the same, and download, if not
/// Arguments: path as a string, fileName as a string, uri as a string to download the file, uriHash as a string and is optional to check if the file is the same
Future<void> getFile(String path, String fileName, String uri, [String? uriHash]) async{
  final dio = Dio();
  try {
    // Create path to the file
    await Directory(path).create(recursive: true);
    // If there is uriHash then check. If there isn't - download
    if (uriHash != null) {
      // Get SHA1 of a file if it exists
      String fileHash = await getSHA1(path, fileName);
      // If hash of existing file isn't the same as it should be - redownload
      if (fileHash != uriHash) {
        await dio.download(uri, '$path/$fileName', onReceiveProgress: (count, total) => print('$count $total $fileName'));
      }
    }
    else {
      await dio.download(uri, '$path/$fileName', onReceiveProgress: (count, total) => print('$count $total $fileName'));
    }
  } catch (e) {
    throw Exception(e);
  }
}

// Function to get SHA1 of a file
// Arguments: path as a string, fileName as a string
Future<String> getSHA1(String path, String fileName) async{
  // Hash type
  Hash hasher = sha1;
  // Get to the file
  var input = File('$path/$fileName');
  // If file doesn't exist then return with nothing
  if (!input.existsSync()) {
    exitCode = 66; // An input file did not exist or was not readable.
    // Let's just say, sha1 will never equal to 66 so...
    return exitCode.toString();
  }
  // Get hash
  var value = await hasher.bind(input.openRead()).first;
  
  // Return it as a string (Digest type by default)
  return value.toString();
}
