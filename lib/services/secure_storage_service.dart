import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  Future<void> writeSecureData(String key, String value) async {
    var writeData = await storage.write(key: key, value: value);
    return writeData;
  }

  Future<String?> readSecureData(String key) async {
    var readData = await storage.read(key: key);
    return readData;
  }
}
