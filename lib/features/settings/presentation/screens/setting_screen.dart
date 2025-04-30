import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Switch states for notifications
  bool _emailAlerts = true;
  bool _pushAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings",),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ----- Account Section -----
          _buildSectionHeader("⚙️  Account"),
          _buildSettingItem("Edit Profile", onTap: () {
            // TODO: Navigate to Edit Profile screen.
          }),
          _buildSettingItem("Change Password", onTap: () {
            // TODO: Navigate to Change Password screen.
          }),
          _buildSettingItem("Language Preferences", onTap: () {
            // TODO: Navigate to Language Preferences screen.
          }),
          const SizedBox(height: 16),

          // ----- Notifications Section -----
          _buildSectionHeader("🔔 Notifications"),
          _buildSettingItem("Notification Settings", onTap: () {
            // TODO: Navigate to Notification Settings screen.
          }),
          _buildSwitchSettingItem(
              title: "Email Alerts",
              value: _emailAlerts,
              onChanged: (newValue) {
                setState(() {
                  _emailAlerts = newValue;
                });
              }),
          _buildSwitchSettingItem(
              title: "Push Alerts",
              value: _pushAlerts,
              onChanged: (newValue) {
                setState(() {
                  _pushAlerts = newValue;
                });
              }),
          const SizedBox(height: 16),

          // ----- App Section -----
          _buildSectionHeader("📄 App"),
          _buildSettingItem("Privacy Policy", onTap: () {
            // TODO: Navigate to Privacy Policy screen.
          }),
          _buildSettingItem("Terms of Service", onTap: () {
            // TODO: Navigate to Terms of Service screen.
          }),
          const SizedBox(height: 16),

          // ----- Help & Support Section -----
          _buildSectionHeader("❓ Help & Support"),
          _buildSettingItem("Contact Support", onTap: () {
            // TODO: Navigate to Contact Support screen.
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Builds a header widget for each section.
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.grey[200],
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Builds a ListTile for a settings item.
  Widget _buildSettingItem(String title,
      {required VoidCallback onTap, TextStyle? textStyle}) {
    return ListTile(
      title: Text(title, style: textStyle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  /// Builds a ListTile with a switch for settings items.
  Widget _buildSwitchSettingItem({required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
