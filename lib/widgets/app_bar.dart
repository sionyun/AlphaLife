import 'package:flutter/material.dart';
import 'package:mcs07/info_page.dart';
import 'package:mcs07/settings_page.dart';
import 'package:mcs07/utils/utils.dart';
import 'package:provider/provider.dart';
import '../themes/app_default_theme.dart';
import '../themes/theme_provider.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double horizontalPadding;
  final String headerTitle;
  const CustomAppBar({
    required this.horizontalPadding,
    required this.headerTitle,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final GlobalKey _searchFieldKey = GlobalKey();
  bool _isSearchFocused = false;
  List<Map<String, String>> _filteredProteins = [];
  OverlayEntry? _overlayEntry;

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

  @override
  void initState() {
    super.initState();
    _filteredProteins = _proteins;
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
        if (_isSearchFocused) {
          // Show overlay immediately when focused, regardless of text content
          _showOverlay();
        } else {
          _hideOverlay();
        }
      });
    });
  }

  @override
  void dispose() {
    _hideOverlay();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterProteins(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProteins = _proteins;
      } else {
        _filteredProteins = _proteins
            .where((protein) =>
                protein['name']!.toLowerCase().contains(query.toLowerCase()) ||
                protein['id']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      // Update overlay if search is focused
      if (_isSearchFocused) {
        _showOverlay();
      }
    });
  }

  void _showOverlay() {
    _hideOverlay(); // Remove existing overlay first

    final RenderBox? renderBox =
        _searchFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _SearchOverlay(
        position: position,
        width: size.width,
        filteredProteins: _filteredProteins,
        onProteinTap: _onProteinTap,
        horizontalPadding: widget.horizontalPadding,
        searchQuery: _searchController.text, // Pass current search query
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onProteinTap(Map<String, String> protein) {
    // Clear search and unfocus
    _searchController.clear();
    _searchFocusNode.unfocus();
    _hideOverlay();

    // Navigate to InfoPage - you'll need to import your InfoPage
    // Replace this with your actual InfoPage navigation
    openPage(context, const InfoPage());

    // Uncomment this line when you have InfoPage properly imported:
    // openPage(context, InfoPage(proteinData: protein));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      color: themeProvider.barColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.headerTitle, style: AppTextStyles.title),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
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
                          const SettingsPage(),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 24,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _SearchField(
                key: _searchFieldKey,
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _filterProteins,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: themeProvider.searchBarColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
              color: Color(0x40000000), blurRadius: 7, offset: Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search proteins…',
          hintStyle: TextStyle(
            color: themeProvider.hintTextColor,
            fontSize: 16,
            fontFamily: 'Afacad',
          ),
          prefixIcon: Icon(
            Icons.search,
            color: themeProvider.hintTextColor,
            size: 17,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Afacad',
        ),
      ),
    );
  }
}

class _SearchOverlay extends StatelessWidget {
  final Offset position;
  final double width;
  final List<Map<String, String>> filteredProteins;
  final Function(Map<String, String>) onProteinTap;
  final double horizontalPadding;
  final String searchQuery;

  const _SearchOverlay({
    required this.position,
    required this.width,
    required this.filteredProteins,
    required this.onProteinTap,
    required this.horizontalPadding,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.4; // Max 40% of screen height

    return Positioned(
      left: position.dx,
      top: position.dy + 36 + 8, // Position below search field with small gap
      width: width,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.cardColor,
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            color: themeProvider.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Results section
              Flexible(
                child: filteredProteins.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          searchQuery.isEmpty
                              ? 'No proteins available'
                              : 'No proteins found matching "$searchQuery"',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: themeProvider.subtitleColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: filteredProteins.length,
                        itemBuilder: (context, index) {
                          final protein = filteredProteins[index];
                          return ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor: themeProvider.iconBgColor,
                              child: Icon(
                                Icons.biotech,
                                size: 16,
                                color: themeProvider.textColor,
                              ),
                            ),
                            title: Text(
                              protein['name']!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: themeProvider.textColor,
                              ),
                            ),
                            subtitle: Text(
                              '${protein['id']} • ${protein['description']}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: themeProvider.subtitleColor,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: themeProvider.subtitleColor,
                            ),
                            onTap: () => onProteinTap(protein),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
