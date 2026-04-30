import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class FileUtils {
  /// Get human readable file size
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = (log(bytes) / log(1024)).floor();
    if (i >= suffixes.length) i = suffixes.length - 1;
    final size = bytes / pow(1024, i);
    return '${size.toStringAsFixed(1)} ${suffixes[i]}'; 
  }

  static double log(num value) => value > 0 ? value.log : 0;
  static double pow(num base, num exponent) {
    if (exponent == 0) return 1;
    var result = base;
    for (var i = 1; i < exponent; i++) {
      result *= base;
    }
    return result;
  }

  /// Format duration to MM:SS
  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Pick multiple files
  static Future<List<String>?> pickFiles({
    String type = FileType.custom,
    List<String> allowedExtensions = const ['mp3', 'flac', 'wav', 'ogg', 'm4a'],
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );
      if (result != null) {
        return result.files.map((file) => file.path!).whereType<String>().toList();
      }
    } catch (e) {
      print('Error picking files: $e');
    }
    return null;
  }

  /// Check and request storage permission
  static Future<bool> checkAndRequestPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
    return true;
  }

  /// Get parent directory
  static String getParentDirectory(String path) {
    return path.substring(0, path.lastIndexOf('/'));
  }

  /// Get file extension
  static String getExtension(String path) {
    return path.substring(path.lastIndexOf('.') + 1).toLowerCase();
  }

  /// Clean filename
  static String cleanFilename(String filename) {
    return filename.replaceAll(RegExp(r'[<>:"/\|?*]'), '');
  }
}
