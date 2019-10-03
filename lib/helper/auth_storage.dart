import 'dart:async';
import 'package:aad_oauth/model/token.dart';
import "dart:convert" as Convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/config.dart';

class AuthStorage {
  FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final Config _config;

  AuthStorage(Config config) : _config = config;

  Future<void> saveTokenToCache(Token token) async {
    var data = Token.toJsonMap(token);
    var json = Convert.jsonEncode(data);
    await _secureStorage.write(key: _config.identifier, value: json);
  }

  Future<T> loadTokenToCache<T extends Token>() async {
    var json = await _secureStorage.read(key: _config.identifier);
    if (json == null) return null;
    try {
      var data = Convert.jsonDecode(json);
      return _getTokenFromMap<T>(data);
    } catch (exception) {
      print(exception);
      return null;
    }
  }

  Token _getTokenFromMap<T extends Token>(Map<String, dynamic> data) =>
      Token.fromJson(data);

  Future clear() async {
    _secureStorage.delete(key: _config.identifier);
  }
}
