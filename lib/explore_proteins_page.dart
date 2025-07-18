import 'package:flutter/material.dart';
import 'package:mcs07/settings_page.dart';
import 'package:mcs07/utils/utils.dart';
import 'package:mcs07/widgets/list_item.dart';
import 'package:provider/provider.dart';
import 'molecule_viewer.dart';
import 'home_page.dart';
import 'themes/theme_provider.dart';
import 'themes/app_default_theme.dart';

class ExploreProteinsPage extends StatefulWidget {
  const ExploreProteinsPage({super.key});

  @override
  State<ExploreProteinsPage> createState() => _ExploreProteinsPageState();
}

class _ExploreProteinsPageState extends State<ExploreProteinsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;
  String? _selectedProtein;

  final List<Map<String, String>> _proteins = [
    {'name': 'Crambin', 'id': '1crn', 'description': 'Small plant protein'},
    {
      'name': 'Hemoglobin',
      'id': '1hho',
      'description': 'Oxygen transport protein'
    },
    {'name': 'Insulin', 'id': '4ins', 'description': 'Hormone protein'},
    {'name': 'Lysozyme', 'id': '1aki', 'description': 'Enzyme protein'},
  ];

  Map<String, String>? _getProteinById(String id) {
    return _proteins.firstWhere(
      (protein) => protein['id'] == id,
      orElse: () =>
          {'name': 'Unknown', 'id': id, 'description': 'Unknown protein'},
    );
  }

  List<Map<String, String>> _filteredProteins = [];

  @override
  void initState() {
    super.initState();
    _filteredProteins = _proteins;
  }

  void _filterProteins(String query) {
    setState(() {
      _filteredProteins = _proteins
          .where((protein) =>
              protein['name']!.toLowerCase().contains(query.toLowerCase()) ||
              protein['id']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _handleQuickActionTap(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: $action')),
    );
  }

  void _launchPage(BuildContext context, StatefulWidget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth * 0.04;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.barColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Explore Proteins',
          style: AppTextStyles.title,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () => themeProvider.toggleTheme(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            iconSize: 24,
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => openPage(
              context,
              const SettingsPage(), // Navigate to info page
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            iconSize: 24,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Focus(
              onFocusChange: (focused) {
                setState(() {
                  _isSearchFocused = focused;
                });
              },
              child: TextField(
                controller: _searchController,
                onChanged: _filterProteins,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: themeProvider.searchBarColor,
                  hintText: 'Search proteins...',
                  hintStyle: AppTextStyles.bodyMedium
                      .copyWith(color: themeProvider.hintTextColor),
                  prefixIcon: Icon(
                    Icons.search,
                    color: themeProvider.hintTextColor,
                    size: 17,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: _selectedProtein == null || _isSearchFocused
                ? ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    itemCount: _filteredProteins.length,
                    itemBuilder: (context, index) {
                      final protein = _filteredProteins[index];
                      return SimpleListItem(
                        leadingChar: protein['name']![0],
                        title: protein['name']!,
                        subtitle: protein['description']!,
                        onTap: () {
                          setState(() {
                            _selectedProtein = protein['id'];
                            _isSearchFocused = false;
                            FocusScope.of(context).unfocus();
                          });
                        },
                      );
                    },
                  )
                : ListView(
                    padding:
                        EdgeInsets.symmetric(horizontal: padding, vertical: 0),
                    children: [
                      const Text(
                        'Visualise Proteins',
                        style: AppTextStyles.header,
                      ),
                      const SizedBox(height: 2),
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 5,
                        color: themeProvider.cardColor,
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.5,
                              width: double.infinity,
                              child: MoleculeViewer(
                                moleculeId: _selectedProtein!,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      _getProteinById(
                                          _selectedProtein!)!['name']!,
                                      style:
                                          AppTextStyles.sectionTitle.copyWith(
                                        color: themeProvider.textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "ID: ${_selectedProtein!}",
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: themeProvider.subtitleColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                        _getProteinById(
                                            _selectedProtein!)!['description']!,
                                        style:
                                            AppTextStyles.bodyMedium.copyWith(
                                          color: themeProvider.textColor,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: kToolbarHeight,
        color: themeProvider.barColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () => _launchPage(context, const HomePage()),
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
    );
  }
}
