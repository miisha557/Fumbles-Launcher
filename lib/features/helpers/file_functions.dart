// File to handle fucntions that interact with files
import 'dart:io';

import 'package:crypto/crypto.dart';

/// Function to get SHA1 of a file
/// Arguments: path as a string, fileName as a string
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
