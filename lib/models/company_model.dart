class Company {
  int id;
  String profileId;
  String companyName;
  String email;
  String description;
  String country;
  String ruc;
  String phone;
  String website;
  String profileImgUrl;
  String sector;
  int userId;

  Company(
      this.id,
      this.profileId,
      this.companyName,
      this.email,
      this.description,
      this.country,
      this.ruc,
      this.phone,
      this.website,
      this.profileImgUrl,
      this.sector,
      this.userId);

  factory Company.fromJson(Map<String, dynamic>json){
    return Company(
      json['id'],
      json['ProfileId'],
      json['companyName'],
      json['email'],
      json['description'],
      json['country'],
      json['ruc'],
      json['phone'],
      json['website'],
      json['profileImgUrl'],
      json['sector'],
      json['userId'],
    );
  }

}
