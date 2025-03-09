import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_providers.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'), elevation: 0),
      body: ListView(
        children: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return ListTile(
                leading: Icon(Icons.palette),
                title: Text('Dark Mode'),
                subtitle: Text('Switch between light and dark theme'),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text('Configure notification settings'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to notification settings
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('English'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to language settings
            },
          ),
          Divider(),

          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version =
                  snapshot.hasData ? snapshot.data!.version : '0.1.0';
              return ListTile(
                leading: Icon(Icons.info),
                title: Text('App Version'),
                subtitle: Text(version),
              );
            },
          ),
        ],
      ),
    );
  }
}
