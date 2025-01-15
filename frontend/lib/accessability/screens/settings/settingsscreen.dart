import 'package:flutter/material.dart';
import 'package:frontend/accessability/widgets/settingswidgets/about.dart';
import 'package:frontend/accessability/widgets/settingswidgets/accountscreen.dart';
import 'package:frontend/accessability/widgets/settingswidgets/biometricscreen.dart';
import 'package:frontend/accessability/widgets/settingswidgets/chatwithsupportscreen.dart';
import 'package:frontend/accessability/widgets/settingswidgets/preferencescreen.dart';
import 'package:frontend/accessability/widgets/settingswidgets/privacysecurityscreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back),
              color: const Color(0xFF6750A4)),
          title: const Text(
            'SETTINGS',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 2,
          shadowColor: Colors.black,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person, color: Color(0xFF6750A4)),
            title: const Text('Account',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.tune, color: Color(0xFF6750A4)),
            title: const Text('Preference',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Preferencescreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications, color: Color(0xFF6750A4)),
            title: const Text('Notification',
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Switch(
              value: isNotificationEnabled,
              onChanged: (bool value) {
                setState(
                  () {
                    isNotificationEnabled = value;
                  },
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security, color: Color(0xFF6750A4)),
            title: const Text('Privacy & Security',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Privacysecurity(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.chat, color: Color(0xFF6750A4)),
            title: const Text('Chat and Support',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Chatandsupport(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.fingerprint, color: Color(0xFF6750A4)),
            title: const Text('Biometric Login',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Biometriclogin(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info, color: Color(0xFF6750A4)),
            title: const Text('About',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const About(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFF6750A4)),
            title: const Text(
              'Log out',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
