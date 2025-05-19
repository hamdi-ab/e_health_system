// File: lib/models/file_model.dart

import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileModel {
  final String fileId;
  final String? filePath;
  final String fileType;
  final String fileName;
  final Uint8List? fileData;

  FileModel({
    required this.fileId,
    this.filePath,
    required this.fileType,
    required this.fileName,
    this.fileData,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      fileId: json['fileId'] as String,
      filePath: json['filePath'] as String?,
      fileType: json['fileType'] as String,
      fileName: json['fileName'] as String,
      fileData: json['fileData'] != null ? base64Decode(json['fileData'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileId': fileId,
      'filePath': filePath,
      'fileType': fileType,
      'fileName': fileName,
      if (fileData != null) 'fileData': base64Encode(fileData!),
    };
  }

  // Helper method to get the file path or create a temporary file from data
  Future<String> getFilePath() async {
    if (filePath != null) {
      return filePath!;
    }
    if (fileData != null) {
      // Create a temporary file from the data
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(fileData!);
      return tempFile.path;
    }
    throw Exception('No file path or data available');
  }
}
