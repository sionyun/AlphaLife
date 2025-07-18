import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_provider.dart';
import '../themes/app_default_theme.dart';

class LearningResourceItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const LearningResourceItem(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    final tp = Provider.of<ThemeProvider>(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: tp.iconBgColor,
                  borderRadius: BorderRadius.circular(20)),
              child: Icon(icon,
                  size: 20,
                  color: tp.isDarkMode ? Colors.white70 : Colors.black),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: tp.textColor)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: tp.subtitleColor)),
                  ]),
            ),
            Icon(Icons.chevron_right, size: 18, color: tp.subtitleColor),
          ],
        ),
      ),
    );
  }
}
