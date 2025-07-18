import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_provider.dart';
import '../themes/app_default_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: AppTextStyles.title),
        backgroundColor: themeProvider.barColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: themeProvider.backgroundColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        children: [
          // Appearance
          SwitchListTile(
            title: Text('Dark Mode',
                style: AppTextStyles.bodyLarge
                    .copyWith(color: themeProvider.textColor)),
            subtitle: Text('Toggle between light and dark themes',
                style: AppTextStyles.bodySmall
                    .copyWith(color: themeProvider.subtitleColor)),
            value: isDark,
            onChanged: (_) => themeProvider.toggleTheme(),
            secondary: Icon(Icons.dark_mode, color: themeProvider.textColor),
          ),

          // Data & Privacy
          const SizedBox(height: 16),
          Text('Privacy & Security',
              style: AppTextStyles.sectionTitle
                  .copyWith(color: themeProvider.textColor)),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.privacy_tip,
            label: 'Privacy Policy',
            onTap: () {
              // Open privacy policy
            },
            themeProvider: themeProvider,
          ),
          _buildSettingsTile(
            icon: Icons.delete_forever,
            label: 'Delete All Data',
            onTap: () {
              // Add confirmation and clear app data
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Confirm Deletion',
                      style: AppTextStyles.sectionTitle),
                  content: const Text(
                    'This will permanently remove all app data.',
                    style: AppTextStyles.bodyMedium,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel', style: AppTextStyles.button1),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        // Clear local storage or perform reset
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('All data deleted.',
                                  style: AppTextStyles.bodySmall)),
                        );
                      },
                      child: const Text('Delete', style: AppTextStyles.button1),
                    ),
                  ],
                ),
              );
            },
            themeProvider: themeProvider,
          ),

          // App Info
          const SizedBox(height: 24),
          Text('App',
              style: AppTextStyles.sectionTitle
                  .copyWith(color: themeProvider.textColor)),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.info_outline,
            label: 'About This App',
            onTap: () {
              // Show about info
            },
            themeProvider: themeProvider,
          ),
          _buildSettingsTile(
            icon: Icons.article,
            label: 'Terms & Conditions',
            onTap: () {
              // Navigate to terms
            },
            themeProvider: themeProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeProvider themeProvider,
  }) {
    return ListTile(
      leading: Icon(icon, color: themeProvider.textColor),
      title: Text(
        label,
        style:
            AppTextStyles.bodyMedium.copyWith(color: themeProvider.textColor),
      ),
      trailing: Icon(Icons.arrow_forward_ios,
          color: themeProvider.textColor, size: 16),
      onTap: onTap,
    );
  }
}
