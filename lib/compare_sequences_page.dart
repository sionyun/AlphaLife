import 'package:flutter/material.dart';
import 'package:mcs07/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import '../themes/app_default_theme.dart';
import '../widgets/app_bar.dart';
import '../utils/constants.dart';

class CompareSequencesPage extends StatelessWidget {
  const CompareSequencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).size.width * kPaddingFraction;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: CustomAppBar(
          horizontalPadding: pad,
          headerTitle: 'Compare Sequences',
        ),
        backgroundColor: themeProvider.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: 0.5, // fade the image
                child: Image.asset(
                  'assets/images/blue-empty-box-bgremoved.png',
                  width: 130, // or whatever size fits
                  height: 130,
                ),
              ),
              const SizedBox(height: 5),
              Text("Page coming soon!",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: themeProvider.textColor,
                  )),
            ],
          ),
        ));
  }
}
