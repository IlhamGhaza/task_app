import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDatasource {
  final _storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    //uid and email
    return await _storage.read(key: 'uid''email');
  }

  Future<void> saveToken(String uid) async {
    await _storage.write(key: 'uid'
          'email', value: uid);
  }

  Future<void> updateToken(String uid) async {
    await saveToken(uid);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key:
          'uid'
          'email',
    );
  }
}
