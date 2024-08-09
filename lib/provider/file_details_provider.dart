import 'dart:io';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo/models/file_details.dart';

part 'file_details_provider.g.dart';

@riverpod
class fileDetailsProvider extends _$fileDetailsProvider with ChangeNotifier{
  @override
  fileDetails build() {
    return fileDetails(file_names: [], file_paths: [], files: []);
  }

  void addData(List<String?> fileNames,List<String?> filePaths , List<File> files) {
    state = fileDetails(file_names: fileNames, file_paths: filePaths, files: files);
    notifyListeners();
  }
  
}