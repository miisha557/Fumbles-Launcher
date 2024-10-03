import 'dart:convert';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> hashString(String input) async{
  String salt = dotenv.env['SALT']!;

  final String saltedInput = input + salt;

  final bytes = utf8.encode(saltedInput);

  final hashedStr = sha256.convert(bytes);

  return hashedStr.toString();
}
