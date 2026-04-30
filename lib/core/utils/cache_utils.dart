import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class CacheUtils {
  static const String _cacheKeyPrefix = 'cache_';
  
  /// Get cache directory
  static Future<Directory> getCacheDirectory() async {
    return await getTemporaryDirectory();
  }

  /// Cache data to file
  static Future<void> cacheData(String key, List<int> data) async {
    try {
      final dir = await getCacheDirectory();
      final file = File('${dir.path}/$_cacheKeyPrefix$key');
      await file.writeAsBytes(data);
    } catch (e) {
      print('Error caching data: $e');
    }
  }

  /// Retrieve cached data
  static Future<List<int>?> getCachedData(String key) async {
    try {
      final dir = await getCacheDirectory();
      final file = File('${dir.path}/$_cacheKeyPrefix$key');
      if (await file.exists()) {
        return await file.readAsBytes();
      }
    } catch (e) {
      print('Error retrieving cached data: $e');
    }
    return null;
  }

  /// Check if data exists in cache
  static Future<bool> hasCachedData(String key) async {
    try {
      final dir = await getCacheDirectory();
      final file = File('${dir.path}/$_cacheKeyPrefix$key');
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Clear all cache
  static Future<void> clearCache() async {
    try {
      final dir = await getCacheDirectory();
      final files = dir.listSync();
      for (final file in files) {
        if (file.path.contains(_cacheKeyPrefix)) {
          await file.delete();
        }
      }
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  /// Get cache size
  static Future<int> getCacheSize() async {
    try {
      final dir = await getCacheDirectory();
      int totalSize = 0;
      final files = dir.listSync();
      for (final file in files) {
        if (file.path.contains(_cacheKeyPrefix)) {
          totalSize += await file.stat().then((stat) => stat.size);
        }
      }
      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  /// Save track artwork to cache
  static Future<String?> cacheTrackArtwork(String trackId, List<int> artworkData) async {
    try {
      final key = 'artwork_$trackId';
      await cacheData(key, artworkData);
      return key;
    } catch (e) {
      print('Error caching artwork: $e');
      return null;
    }
  }

  /// Load cached track artwork
  static Future<List<int>?> loadCachedArtwork(String trackId) async {
    return await getCachedData('artwork_$trackId');
  }
}
