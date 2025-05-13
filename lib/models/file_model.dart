// File: lib/models/file_model.dart

import 'dart:convert';
import 'dart:typed_data';

class FileModel {
  final String fileId;
  final String? fileName;
  final String mimeType;
  final Uint8List fileData;

  FileModel({
    required this.fileId,
    this.fileName,
    required this.mimeType,
    required this.fileData,
  });

  // Derived property: file size, no need to store it separately.
  int get fileSize => fileData.length;

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      fileId: json['fileId'] as String,
      fileName: json['fileName'] as String?, // FileName is required in backend but can be nullable
      mimeType: json['mimeType'] as String,
      // Assuming the backend sends the binary file data as a Base64-string.
      fileData: base64Decode(json['fileData'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileId': fileId,
      'fileName': fileName,
      'mimeType': mimeType,
      // Encode the binary data to a Base64-string.
      'fileData': base64Encode(fileData),
    };
  }
}
