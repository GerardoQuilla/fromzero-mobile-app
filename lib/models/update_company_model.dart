class UpdateCompanyProfileResource {
  final String description;
  final String country;
  final String ruc;
  final String phone;
  final String website;
  final String profileImgUrl;
  final String sector;

  UpdateCompanyProfileResource({
    required this.description,
    required this.country,
    required this.ruc,
    required this.phone,
    required this.website,
    required this.profileImgUrl,
    required this.sector,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'country': country,
      'ruc': ruc,
      'phone': phone,
      'website': website,
      'profileImgUrl': profileImgUrl,
      'sector': sector,
    };
  }
}