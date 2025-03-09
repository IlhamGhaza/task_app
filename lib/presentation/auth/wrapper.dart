import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '/presentation/home/home_page.dart';
import '../../data/auth_local_datasource.dart';
import 'authenticate.dart';

class Wrapper extends StatefulWidget {
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final _authLocalDatasource = AuthLocalDatasource();
  bool _isLoading = true;
  String? _token;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await _authLocalDatasource.getToken();
    setState(() {
      _token = token;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator();
    }

    return _token == null ? Authenticate() : HomePage();
  }
}
