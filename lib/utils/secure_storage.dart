import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtils {
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static Future<void> writeString(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      debugPrint('Data written to secure storage: $key');
    } catch (e) {
      debugPrint('Error writing to secure storage: $e');
    }
  }

  static Future<String?> readString(String key) async {
    try {
      String? value = await _secureStorage.read(key: key);
      debugPrint('Data read from secure storage: $key');
      return value;
    } catch (e) {
      debugPrint('Error reading from secure storage: $e');
      return null;
    }
  }

  static Future<void> writeInt(String key, int value) async {
    try {
      await _secureStorage.write(key: key, value: value.toString());
      debugPrint('Data written to secure storage: $key');
    } catch (e) {
      debugPrint('Error writing to secure storage: $e');
    }
  }

  static Future<int?> readInt(String key) async {
    try {
      String? value = await _secureStorage.read(key: key);
      int? intValue = value != null ? int.parse(value) : null;
      debugPrint('Data read from secure storage: $key');
      return intValue!;
    } catch (e) {
      debugPrint('Error reading from secure storage: $e');
      return null;
    }
  }

  static Future<void> writeBool(String key, bool value) async {
    try {
      await _secureStorage.write(key: key, value: value.toString());
      debugPrint('Data written to secure storage: $key');
    } catch (e) {
      debugPrint('Error writing to secure storage: $e');
    }
  }

  static Future<bool?> readBool(String key) async {
    try {
      String? value = await _secureStorage.read(key: key);
      bool? boolValue = value != null ? value.toLowerCase() == 'true' : null;
      debugPrint('Data read from secure storage: $key');
      return boolValue;
    } catch (e) {
      debugPrint('Error reading from secure storage: $e');
      return null;
    }
  }

  static Future<void> delete(String key) async {
    try {
      await _secureStorage.delete(key: key);
      debugPrint('Data deleted from secure storage: $key');
    } catch (e) {
      debugPrint('Error deleting from secure storage: $e');
    }
  }

  static Future<Set<String>> getAllKeys() async {
    try {
      final allKeys = await _secureStorage.readAll();
      print('All keys from secure storage: ${allKeys.keys}');
      return allKeys.keys.toSet();
    } catch (e) {
      print('Error getting all keys from secure storage: $e');
      return {};
    }
  }
}
