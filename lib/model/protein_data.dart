class Protein {
  final String name;
  final String description;
  final String details;
  final List<String> links;
  final List<String> pdbCodes;

  Protein({
    required this.name,
    required this.description,
    required this.details,
    required this.links,
    required this.pdbCodes,
  });

  factory Protein.fromJson(Map<String, dynamic> json) {
    return Protein(
      name: json['name'],
      description: json['description'],
      details: json['details'],
      links: List<String>.from(json['links']),
      pdbCodes: List<String>.from(json['PDBCodes']),
    );
  }
}