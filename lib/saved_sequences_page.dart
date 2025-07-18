import 'package:flutter/material.dart';
import 'package:mcs07/settings_page.dart';
import 'package:mcs07/themes/theme_provider.dart';
import 'package:mcs07/utils/utils.dart';
import 'package:mcs07/widgets/app_bar.dart';
import 'package:provider/provider.dart';
import '../themes/app_default_theme.dart';
import '../utils/constants.dart';
import '../providers/saved_proteins_provider.dart';
import '../widgets/list_item.dart';
import 'info_page.dart';

class SavedSequencesPage extends StatelessWidget {
  const SavedSequencesPage({super.key});

  void _handleQuickActionTap(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: $action')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).size.width * kPaddingFraction;
    final savedProvider = Provider.of<SavedProteinsProvider>(context);
    final savedProteins = savedProvider.savedProteins;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar:
          CustomAppBar(headerTitle: 'Saved Sequences', horizontalPadding: pad),
      bottomNavigationBar: Container(
        height: kToolbarHeight,
        color: themeProvider.barColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            IconButton(
              icon: const Icon(Icons.history, color: Colors.white),
              onPressed: () => _handleQuickActionTap(context, 'History'),
            ),
            IconButton(
              icon: const Icon(Icons.bookmark, color: Colors.white),
              onPressed: () => _handleQuickActionTap(context, 'Bookmarks'),
            ),
          ],
        ),
      ),
      backgroundColor: themeProvider.backgroundColor,
      body: savedProteins.isEmpty
          ? Center(
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
                  Text(
                    "You haven't saved any sequences yet.",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: themeProvider.textColor,
                    ),
                  ),
                ],
              ),
            )

          // List state of saved proteins
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: pad, vertical: 16),
              child: ListView.builder(
                itemCount: savedProteins.length,
                itemBuilder: (context, index) {
                  final protein = savedProteins[index];
                  return SimpleListItem(
                    leadingChar: protein.name[0].toUpperCase(),
                    title: protein.name,
                    subtitle: protein.pdbCodes.isNotEmpty
                        ? 'PDB: ${protein.pdbCodes.join(", ")}'
                        : 'No PDB codes available',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InfoPage(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
