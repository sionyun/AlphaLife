import 'package:flutter/material.dart' hide SearchBar;
import 'package:mcs07/compare_sequences_page.dart';
import 'package:mcs07/webview_page.dart';
import '../themes/app_default_theme.dart';
import '../utils/constants.dart';
import '../widgets/app_bar.dart';
import '../widgets/quick_action.dart';
import '../widgets/list_item.dart';
import '../widgets/section_header.dart';
import '../widgets/learning_resource_item.dart';
import '../widgets/bottom_nav_bar.dart';
import 'saved_sequences_page.dart';
import 'package:provider/provider.dart';
import 'info_page.dart';
import 'molecule_viewer.dart';
import 'explore_proteins_page.dart';
import 'themes/theme_provider.dart'; // Add this import

// Homepage widget is the main screen of this application
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // Creates the state of homepage
  State<HomePage> createState() => _HomePageState();
}

// State class of homepage
class _HomePageState extends State<HomePage> {
  // Track the selected tab
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState(); // Calls the init state of the parent
  }

  // Show a snack bar with a message
  void _showSnack(BuildContext c, String msg) =>
      ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(msg)));

  // Open a new page when a quick action is tapped
  void _openPage(BuildContext c, Widget page) =>
      Navigator.push(c, MaterialPageRoute(builder: (_) => page));

  // Handle quick action taps
  void _handleQuickActionTap(BuildContext context, String action) {
    _showSnack(context, 'Selected: $action');
  }

  // Update index when a nav item is tapped
  void _onNavTap(int idx) {
    setState(() {
      _currentIndex = idx;
    });

    switch (idx) {
      // Handle navigation based on the selected index
      // 0: Home, 1: History, 2: Search, 3: Saved Sequences
      case 2:
        _openPage(context, const SavedSequencesPage());
        break;
      default:
        _showSnack(context, 'Selected tab: $idx');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = MediaQuery.of(context).size.width * kPaddingFraction;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: CustomAppBar(horizontalPadding: padding, headerTitle: 'Home'),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: padding),
        children: [
          const SizedBox(height: 14),
          Text('Welcome to AlphaLife',
              style: AppTextStyles.header
                  .copyWith(color: themeProvider.headerColor)),
          Card(
            color: themeProvider.cardColor,
            margin: const EdgeInsets.symmetric(vertical: 20),
            elevation: 5,
            child: Column(
              children: [
                SizedBox(
                  height: screenWidth * 0.5,
                  width: double.infinity,
                  child: const MoleculeViewer(moleculeId: '7AEG'),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16, right: 16, bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Main Protease',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                        color: themeProvider.textColor)),
                                Text('COVID-19',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                        color: themeProvider.subtitleColor)),
                              ],
                            ),
                            const SizedBox(
                              width: 80,
                            ),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _openPage(context, const InfoPage()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonBg,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(kCornerRadius),
                                  ),
                                ),
                                icon: const Icon(Icons.search),
                                label: const Text('Discover'),
                              ),
                            ),
                          ]),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ——— Quick Actions ———
          const SizedBox(height: 4),
          Text('Quick Actions',
              style: AppTextStyles.sectionTitle
                  .copyWith(color: themeProvider.textColor)),
          const SizedBox(height: 20),
          Row(children: [
            QuickAction(
              icon: Icons.search,
              label: 'Explore\nProteins',
              onTap: () => _openPage(context, const ExploreProteinsPage()),
            ),
            QuickAction(
                icon: Icons.compare_outlined,
                label: 'Compare\nSequences',
                onTap: () => _openPage(context, const CompareSequencesPage())),
            QuickAction(
                icon: Icons.info_outline,
                label: 'Learn\nMore',
                onTap: () => _openPage(
                    context,
                    const WebViewPage(
                        url: 'https://alphafoldserver.com/about'))),
            QuickAction(
              icon: Icons.bookmark_outline_rounded,
              label: 'Saved\nSequences',
              onTap: () => _openPage(context, const SavedSequencesPage()),
            )
          ]),

          // ——— Recently Viewed ———
          SectionHeader(
            title: 'Recently Viewed',
            onViewAll: () => _showSnack(context, 'View all'),
          ),
          SimpleListItem(
            leadingChar: 'P',
            title: 'Protein 1',
            subtitle: 'ID: 6vxxx • Today',
            onTap: () => _showSnack(context, 'Recent Protein 1'),
          ),
          SimpleListItem(
            leadingChar: 'P',
            title: 'Protein 2',
            subtitle: 'ID: 1a3n • Yesterday',
            onTap: () => _showSnack(context, 'Recent Protein 2'),
          ),
          SimpleListItem(
            leadingChar: 'P',
            title: 'Protein 3',
            subtitle: 'ID: 3ely • 3 days ago',
            onTap: () => _showSnack(context, 'Recent Protein 3'),
          ),
          // …repeat for others

          // ——— Featured ———
          SectionHeader(
            title: 'Featured Proteins',
            onViewAll: () => _showSnack(context, 'Explore more'),
          ),
          SimpleListItem(
            leadingChar: 'H',
            title: 'Haemoglobin',
            subtitle: 'Oxygen transport protein',
            onTap: () => _showSnack(context, 'Featured Haemoglobin'),
          ),
          SimpleListItem(
            leadingChar: 'M',
            title: 'Myoglobin',
            subtitle: 'Oxygen storage protein',
            onTap: () => _showSnack(context, 'Featured Haemoglobin'),
          ),
          SimpleListItem(
            leadingChar: 'U',
            title: 'Ubiquitin',
            subtitle: 'Protein degradation marker',
            onTap: () => _showSnack(context, 'Featured Haemoglobin'),
          ),

          // ——— Learning Resources ———
          SectionHeader(
            title: 'Learning Resources',
            onViewAll: () => _showSnack(context, 'View all resources'),
          ),
          Card(
            color: themeProvider.cyanBgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kCornerRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  LearningResourceItem(
                    icon: Icons.biotech_outlined,
                    title: 'Protein Basics',
                    subtitle: 'Learn the fundamentals',
                    onTap: () => _showSnack(context, 'Protein Basics'),
                  ),
                  const SizedBox(height: kSmallPadding),
                  LearningResourceItem(
                    icon: Icons.psychology_outlined,
                    title: 'Understanding 3D Structures',
                    subtitle: 'Interactive tutorial',
                    onTap: () => _showSnack(context, 'Video Tutorials'),
                  ),
                  const SizedBox(height: kSmallPadding),
                  LearningResourceItem(
                    icon: Icons.menu_book_rounded,
                    title: 'AlphaFold Explained',
                    subtitle: 'Learn how AI predicts structures',
                    onTap: () => _showSnack(context, 'Research Articles'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),

      // Bottom navigation bar with quick actions
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex, // supply the tracked index
        onTap: _onNavTap, // handle taps here
      ),
    );
  }
}
