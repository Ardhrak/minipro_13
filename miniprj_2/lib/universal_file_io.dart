// Platform-specific file operations for IO platforms
import 'dart:io';
import 'dart:typed_data';

abstract class UniversalFile {
  static Future<String> readAsString(String? path, Uint8List? bytes) async {
    if (bytes != null) {
      return String.fromCharCodes(bytes);
    }
    if (path != null) {
      final file = File(path);
      return await file.readAsString();
    }
    throw UnsupportedError('No file data available');
  }
}

