import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/core/widget/loading.dart';

import '../../data/service/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
   final Function toggleView;
  const ResetPasswordPage({super.key, required this.toggleView});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
final _formKey = GlobalKey<FormState>();
  String email = '';
  String message = '';
  bool isError = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final theme = Theme.of(context);
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
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => widget.toggleView(),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.zero,
                        ),
                        SizedBox(height: size.height * 0.02),
                         Image.asset(
                          'assets/images/logo.png',
                          height: 100,
                          width: 100,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Reset Password',
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Enter your email to receive a password reset link',
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
                              SizedBox(height: 32),
                              ElevatedButton(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Text('Send Reset Link'),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => loading = true);
                                    try {
                                      await authService.resetPassword(email);
                                      setState(() {
                                        message =
                                            'Password reset link sent to your email';
                                        isError = false;
                                        loading = false;
                                      });
                                    } catch (e) {
                                      setState(() {
                                        message =
                                            'Failed to send reset link. Please check your email';
                                        isError = true;
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                              ),
                              if (message.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Text(
                                    message,
                                    style: TextStyle(
                                      color:
                                          isError
                                              ? theme.colorScheme.error
                                              : theme.colorScheme.primary,
                                      fontSize: 14.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
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
