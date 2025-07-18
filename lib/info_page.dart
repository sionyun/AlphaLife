// Updated InfoPage using Provider
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mcs07/molecule_viewer.dart';
import 'home_page.dart';
import 'model/protein_data.dart';
import 'themes/theme_provider.dart';
import 'themes/app_default_theme.dart';
import 'providers/saved_proteins_provider.dart';

// Parsing Protein Info Data from Json
Future<List<Protein>> loadExplanations() async {
  final String response = await rootBundle.loadString('data/proteinInfo.json');
  final List<dynamic> data = jsonDecode(response);
  return data.map((item) => Protein.fromJson(item)).toList();
}

Future<List<Protein>> loadProteins() async {
  final String response = await rootBundle.loadString('data/proteinInfo.json');
  final List<dynamic> data = jsonDecode(response);
  return data.map((item) => Protein.fromJson(item)).toList();
}

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;
  String? _selectedProtein;
  String? _expandedProteinName;

  List<Protein> _proteins = [];
  List<Protein> _filteredProteins = [];

  Protein? _getProteinById(String id) {
    for (var protein in _proteins) {
      if (protein.pdbCodes.contains(id)) {
        return protein;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _filteredProteins = _proteins;
    _loadData();
  }

  void _loadData() async {
    try {
      final results = await Future.wait([loadExplanations(), loadProteins()]);
      if (mounted) {
        setState(() {
          _proteins = results[1] as List<Protein>;
          _filteredProteins = _proteins;
        });
      }
    } catch (e) {
      // Handle error if needed
    }
  }

  void _filterProteins(String query) {
    setState(() {
      _filteredProteins = _proteins
          .where((protein) =>
              protein.name.toLowerCase().contains(query.toLowerCase()) ||
              protein.pdbCodes.any(
                  (code) => code.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  void _handleQuickActionTap(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected: $action',
          style: AppTextStyles.bodySmall,
        ),
      ),
    );
  }

  void _launchPage(BuildContext context, StatefulWidget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _selectPDBCode(String pdbCode) {
    setState(() {
      _selectedProtein = pdbCode;
      _isSearchFocused = false;
      _expandedProteinName = null;
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return FutureBuilder<List<dynamic>>(
          future: Future.wait([loadExplanations(), loadProteins()]),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Scaffold(
                backgroundColor: themeProvider.backgroundColor,
                body: Center(
                  child: CircularProgressIndicator(
                    color: themeProvider.isDarkMode ? Colors.white : null,
                  ),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Scaffold(
                backgroundColor: themeProvider.backgroundColor,
                body: Center(
                  child: Text(
                    'No data found.',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: themeProvider.textColor),
                  ),
                ),
              );
            }

            var explanations = snapshot.data![0] as List<Protein>;
            if (_proteins.isEmpty) {
              _proteins = snapshot.data![1] as List<Protein>;
              if (_filteredProteins.isEmpty) {
                _filteredProteins = _proteins;
              }
            }

            var defaultData = explanations[0];
            var defaultProtein = defaultData.pdbCodes[0];

            var screenWidth = MediaQuery.of(context).size.width;
            var screenHeight = MediaQuery.of(context).size.height;

            return Scaffold(
              backgroundColor: themeProvider.backgroundColor,
              appBar: AppBar(
                backgroundColor: themeProvider.barColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  'Protein Info',
                  style: AppTextStyles.title,
                ),
                actions: <Widget>[
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
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      _handleQuickActionTap(context, 'Menu');
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 24,
                  ),
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
                      onPressed: () =>
                          _handleQuickActionTap(context, 'History'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark, color: Colors.white),
                      onPressed: () =>
                          _handleQuickActionTap(context, 'Bookmarks'),
                    ),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  SizedBox(
                    height: screenHeight,
                    width: double.infinity,
                    child: MoleculeViewer(
                      moleculeId: _selectedProtein ?? defaultProtein,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Focus(
                          onFocusChange: (focused) {
                            if (mounted) {
                              setState(() {
                                _isSearchFocused = focused;
                              });
                            }
                          },
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterProteins,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: themeProvider.searchBarColor,
                              hintText: 'Search proteins...',
                              hintStyle: AppTextStyles.bodyMedium.copyWith(
                                color: themeProvider.hintTextColor,
                              ),
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
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      if (_isSearchFocused && _filteredProteins.isNotEmpty)
                        Expanded(
                          child: Container(
                            color: themeProvider.listItemColor,
                            child: ListView.builder(
                              itemCount: _filteredProteins.length,
                              itemBuilder: (context, index) {
                                final protein = _filteredProteins[index];
                                final isExpanded =
                                    _expandedProteinName == protein.name;

                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        protein.name,
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          color: themeProvider.textColor,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${protein.pdbCodes.length} variants available',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: themeProvider.subtitleColor,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            protein.pdbCodes.isNotEmpty
                                                ? protein.pdbCodes[0]
                                                : '',
                                            style: AppTextStyles.bodySmall
                                                .copyWith(
                                              color: themeProvider.textColor,
                                            ),
                                          ),
                                          Icon(
                                            isExpanded
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                            color: themeProvider.isDarkMode
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          if (isExpanded) {
                                            _expandedProteinName = null;
                                          } else {
                                            _expandedProteinName = protein.name;
                                          }
                                        });
                                      },
                                    ),

                                    // Submenu for PDB codes
                                    if (isExpanded)
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 16, right: 16, bottom: 8),
                                        decoration: BoxDecoration(
                                          color:
                                              themeProvider.expandedCardColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: themeProvider.isDarkMode
                                                ? Colors.grey[700]!
                                                : Colors.grey[300]!,
                                          ),
                                        ),
                                        child: Column(
                                          children: protein.pdbCodes
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int idx = entry.key;
                                            String pdbCode = entry.value;
                                            bool isSelected =
                                                _selectedProtein == pdbCode;

                                            return Container(
                                              color: isSelected
                                                  ? themeProvider
                                                      .selectedItemBgColor
                                                  : Colors.transparent,
                                              child: ListTile(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 4),
                                                dense: true,
                                                leading: Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? (themeProvider
                                                                .isDarkMode
                                                            ? Colors.blue[400]
                                                            : Colors.blue[600])
                                                        : themeProvider
                                                            .iconBgColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '${idx + 1}',
                                                      style: AppTextStyles
                                                          .bodySmall
                                                          .copyWith(
                                                        color: isSelected
                                                            ? Colors.white
                                                            : (themeProvider
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors
                                                                    .grey[600]),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  pdbCode,
                                                  style: AppTextStyles
                                                      .bodyMedium
                                                      .copyWith(
                                                    fontWeight: isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    color: isSelected
                                                        ? (themeProvider
                                                                .isDarkMode
                                                            ? Colors.blue[300]
                                                            : Colors.blue[700])
                                                        : themeProvider
                                                            .textColor,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  'Variant ${idx + 1}',
                                                  style: AppTextStyles.bodySmall
                                                      .copyWith(
                                                    color: themeProvider
                                                        .subtitleColor,
                                                  ),
                                                ),
                                                onTap: () =>
                                                    _selectPDBCode(pdbCode),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),

                                    if (index < _filteredProteins.length - 1)
                                      Divider(
                                          height: 1,
                                          color: themeProvider.dividerColor),
                                    if (index == _filteredProteins.length - 1)
                                      SizedBox(height: screenHeight * 0.1),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.3,
                    minChildSize: 0.08,
                    maxChildSize: 0.8,
                    builder: (context, scrollController) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: themeProvider.draggableSheetColor,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24)),
                          boxShadow: [
                            BoxShadow(
                              color: themeProvider.isDarkMode
                                  ? Colors.black54
                                  : Colors.black26,
                              blurRadius: 10,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.drag_handle,
                                  color: themeProvider.isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _getProteinById(_selectedProtein ??
                                                  defaultProtein)
                                              ?.name ??
                                          'Unknown',
                                      style: AppTextStyles.header.copyWith(
                                        color: themeProvider
                                            .draggableSheetTextColor,
                                      ),
                                    ),
                                  ),
                                  Consumer<SavedProteinsProvider>(
                                    builder: (context, savedProvider, child) {
                                      final currentProtein = _getProteinById(
                                          _selectedProtein ?? defaultProtein);
                                      final isSaved = currentProtein != null &&
                                          savedProvider
                                              .isProteinSaved(currentProtein);

                                      return IconButton(
                                        icon: Icon(
                                          isSaved
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                          color: themeProvider
                                              .draggableSheetTextColor,
                                        ),
                                        onPressed: () {
                                          if (currentProtein != null) {
                                            savedProvider.toggleSaveProtein(
                                                currentProtein);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  isSaved
                                                      ? 'Protein removed from saved list'
                                                      : 'Protein saved successfully',
                                                  style:
                                                      AppTextStyles.bodySmall,
                                                ),
                                                duration:
                                                    const Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Now Showing: ${_selectedProtein ?? defaultProtein}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: themeProvider.isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              IntrinsicHeight(
                                child: SingleChildScrollView(
                                  child: Text(
                                    '${_getProteinById(_selectedProtein ?? defaultProtein)?.description ?? 'No description available'}\n'
                                    '${_getProteinById(_selectedProtein ?? defaultProtein)?.details ?? 'No details available'}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color:
                                          themeProvider.draggableSheetTextColor,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              IntrinsicHeight(
                                child: SingleChildScrollView(
                                  child: SelectableText(
                                    'https://doi.org/10.2210/pdb${_selectedProtein ?? defaultProtein}/pdb',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: themeProvider.isDarkMode
                                          ? Colors.blue[300]
                                          : Colors.blue[700],
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
