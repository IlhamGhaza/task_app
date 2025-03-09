import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widget/loading.dart';
import '../../data/auth_local_datasource.dart';
import '../../data/service/auth_service.dart';
import '../home/home_page.dart';

class SigninPage extends StatefulWidget {
  final Function toggleView;
  final Function toggleResetPassword;
  const SigninPage({
    super.key,
    required this.toggleView,
    required this.toggleResetPassword,
  });

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final theme = Theme.of(context);
    final _authLocalDatasource = AuthLocalDatasource();
    final size = MediaQuery.of(context).size;

    return loading
        ? Loading()
        : Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: size.height * 0.02),
                        // Icon(
                        //   Icons.task_alt,
                        //   size: 64,
                        //   color: theme.primaryColor,
                        // ),
                        //logo
                        Image.asset(
                          'assets/images/logo.png',
                          height: 100,
                          width: 100,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Welcome Back',
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sign in to continue to Task Manager',
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator:
                                    (val) =>
                                        val!.isEmpty || !val.contains('@')
                                            ? 'Enter a valid email'
                                            : null,
                                onChanged: (val) {
                                  setState(() => email = val.trim());
                                },
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: _obscurePassword,
                                validator:
                                    (val) =>
                                        val!.length < 6
                                            ? 'Password must be at least 6 characters'
                                            : null,
                                onChanged: (val) {
                                  setState(() => password = val);
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  child: Text('Forgot Password?'),
                                  onPressed: () => widget.toggleResetPassword(),
                                ),
                              ),
                              SizedBox(height: 24),
                              ElevatedButton(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Text('Sign In'),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => loading = true);
                                    dynamic result = await authService
                                        .signInWithEmailAndPassword(
                                          email,
                                          password,
                                        );
                                    if (result == null) {
                                      setState(() {
                                        error = 'Invalid email or password';
                                        loading = false;
                                      });
                                    } else {
                                      await _authLocalDatasource.saveToken(
                                        result.uid,
                                      );

                                      setState(() {
                                        loading = false;
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(),
                                          ),
                                        );
                                      });
                                    }
                                  }
                                },
                              ),
                              if (error.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Text(
                                    error,
                                    style: TextStyle(
                                      color: theme.colorScheme.error,
                                      fontSize: 14.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              child: Text('Register'),
                              onPressed: () => widget.toggleView(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
