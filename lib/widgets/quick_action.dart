import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_provider.dart';
import '../themes/app_default_theme.dart';

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const QuickAction(
      {required this.icon,
      required this.label,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    final tp = Provider.of<ThemeProvider>(context);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: tp.cyanBgColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: tp.isDarkMode
                        ? Colors.black26
                        : const Color(0x0D000000),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(icon,
                  size: 24,
                  color: tp.isDarkMode ? Colors.white70 : Colors.black),
            ),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: AppTextStyles.label.copyWith(color: tp.subtitleColor)),
          ],
        ),
      ),
    );
  }
}
