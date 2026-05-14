class Ingredient {
  const Ingredient({
    required this.id,
    required this.name,
    required this.thaiName,
    required this.inciName,
    required this.aliases,
    required this.category,
    required this.tag,
    required this.riskLevel,
    required this.shortDescription,
    required this.whatIsIt,
    required this.benefits,
    required this.cautions,
    required this.suitableFor,
    required this.avoidIf,
    required this.commonIn,
    required this.mythVsFact,
    required this.references,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] as String,
      name: json['name'] as String,
      thaiName: json['thaiName'] as String,
      inciName: json['inciName'] as String,
      aliases: _stringList(json['aliases']),
      category: json['category'] as String,
      tag: json['tag'] as String,
      riskLevel: json['riskLevel'] as String,
      shortDescription: json['shortDescription'] as String,
      whatIsIt: json['whatIsIt'] as String,
      benefits: _stringList(json['benefits']),
      cautions: _stringList(json['cautions']),
      suitableFor: _stringList(json['suitableFor']),
      avoidIf: _stringList(json['avoidIf']),
      commonIn: _stringList(json['commonIn']),
      mythVsFact: _stringList(json['mythVsFact']),
      references: _stringList(json['references']),
    );
  }

  final String id;
  final String name;
  final String thaiName;
  final String inciName;
  final List<String> aliases;
  final String category;
  final String tag;
  final String riskLevel;
  final String shortDescription;
  final String whatIsIt;
  final List<String> benefits;
  final List<String> cautions;
  final List<String> suitableFor;
  final List<String> avoidIf;
  final List<String> commonIn;
  final List<String> mythVsFact;
  final List<String> references;

  List<String> get searchableTerms => [
    id,
    name,
    thaiName,
    inciName,
    category,
    tag,
    shortDescription,
    ...aliases,
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thaiName': thaiName,
      'inciName': inciName,
      'aliases': aliases,
      'category': category,
      'tag': tag,
      'riskLevel': riskLevel,
      'shortDescription': shortDescription,
      'whatIsIt': whatIsIt,
      'benefits': benefits,
      'cautions': cautions,
      'suitableFor': suitableFor,
      'avoidIf': avoidIf,
      'commonIn': commonIn,
      'mythVsFact': mythVsFact,
      'references': references,
    };
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value is String && value.trim().isNotEmpty) {
      return [value];
    }
    return const [];
  }
}
