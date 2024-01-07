
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Hash{
  // Encrypt pin to a hash using SHA-256
  String generateHash(String text) {
    var bytesOfData = utf8.encode(text);
    String hashValue = sha256.convert(bytesOfData).toString();
    return hashValue;
  }
}