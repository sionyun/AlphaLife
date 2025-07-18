import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_provider.dart';
import '../themes/app_default_theme.dart';

class SimpleListItem extends StatelessWidget {
  final String leadingChar;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const SimpleListItem(
      {required this.leadingChar,
      required this.title,
      required this.subtitle,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    final tp = Provider.of<ThemeProvider>(context);

    return InkWell(
      onTap: onTap,
      child: Card(
        color: tp.cardColor,
        margin: const EdgeInsets.symmetric(vertical: 7),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _IconBox(char: leadingChar),
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
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 18, color: tp.subtitleColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final String char;
  const _IconBox({required this.char, super.key});

  @override
  Widget build(BuildContext context) {
    final tp = Provider.of<ThemeProvider>(context);
    return Container(
      width: 26,
      height: 24,
      decoration: BoxDecoration(
          color: tp.iconBgColor, borderRadius: BorderRadius.circular(3)),
      child: Center(
        child: SizedBox(
          width: 17,
          height: 17,
          child: Center(
              child: Text(char,
                  style:
                      AppTextStyles.bodySmall.copyWith(color: tp.textColor))),
        ),
      ),
    );
  }
}
