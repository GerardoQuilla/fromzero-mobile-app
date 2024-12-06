class UpdateDeveloperProfileResource {
  final String description;
  final String country;
  final String phone;
  final String specialties;
  final String profileImgUrl;

  UpdateDeveloperProfileResource({
    required this.description,
    required this.country,
    required this.phone,
    required this.specialties,
    required this.profileImgUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'country': country,
      'phone': phone,
      'specialties': specialties,
      'profileImgUrl': profileImgUrl,
    };
  }
}