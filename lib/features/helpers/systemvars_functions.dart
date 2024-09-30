// File to get system variables
import 'dart:io';

/// Function to get all javas paths of user's PC by scanning Path system variable
Map getJavas() {
  // Getting all variables from "Path" system variable
  String? pathVars = Platform.environment['Path'];
  // Getting it to lower case just to be sure
  pathVars = pathVars!.toLowerCase();
  // Splitting it to a list
  List pathVarsList = pathVars.split(';');
  // Creating a map to write all installed jres and jdks
  Map javasMap = <int, Map>{};
  // Going through all of the "Path" variables
  for (int i = 0; i  < pathVarsList.length; i++) {
    // If it contains the "jre" or "jdk" strings...
    if (pathVarsList[i].contains('jre') || pathVarsList[i].contains('jdk')) {
      // Then we get their major version
      var majorVersion = pathVarsList[i].split('\\');
      majorVersion = majorVersion[majorVersion.length - 2].split('-');
      int majorVerInt = int.parse(majorVersion[1].split('.').first);
      // And write it down as id: {majVer: path}
      javasMap[i] = {majorVerInt: pathVarsList[i]};
    }
  }
  return javasMap;
}
