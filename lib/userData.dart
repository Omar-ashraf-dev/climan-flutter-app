import 'dart:io';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:path_provider/path_provider.dart';
// ignore_for_file: file_names
// ignore_for_file: avoid_print


Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data/tokenData.txt');
}

Future<List> readData() async {
  try {
    final file = await _localFile;

    // Read the file
    final data = await file.readAsLines();

    return data;
  } catch (e) {
    // If encountering an error, return 0
    return ['Couldn\'t find local data. Sign in again.'];
  }
}