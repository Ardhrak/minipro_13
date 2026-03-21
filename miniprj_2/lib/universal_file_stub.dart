// Platform-agnostic file operations
import 'dart:typed_data';

abstract class UniversalFile {
  static Future<String> readAsString(String? path, Uint8List? bytes) async {
    if (bytes != null) {
      return String.fromCharCodes(bytes);
    }
    throw UnsupportedError('File reading not supported on this platform');
  }
}

