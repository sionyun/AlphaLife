class Protein {
  final int? id;
  final String name;
  final String link;

  Protein({this.id, required this.name, required this.link});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'link': link,
    };
  }

  factory Protein.fromMap(Map<String, dynamic> map) {
    return Protein(
      id: map['id'],
      name: map['name'],
      link: map['link'],
    );
  }
}