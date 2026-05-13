class UserAllergyProfile {
  const UserAllergyProfile({
    required this.allergens,
    required this.skinType,
    required this.updatedAt,
  });

  final List<String> allergens;
  final String skinType;
  final DateTime updatedAt;
}
