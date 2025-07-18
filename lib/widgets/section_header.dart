import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_provider.dart';
import '../themes/app_default_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String viewAllLabel;
  final VoidCallback onViewAll;
  const SectionHeader(
      {required this.title,
      this.viewAllLabel = 'View all',
      required this.onViewAll,
      super.key});

  @override
  Widget build(BuildContext context) {
    final tp = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: AppTextStyles.sectionTitle.copyWith(color: tp.textColor)),
          TextButton(
              onPressed: onViewAll,
              child: Text(viewAllLabel,
                  style:
                      AppTextStyles.bodyMedium.copyWith(color: tp.textColor))),
        ],
      ),
    );
  }
}
