class Developer{
  int id;
  String profileId;
  String firstName;
  String lastName;
  String email;
  String description;
  String country;
  String phone;
  int completedProjects;
  String specialties;
  String profileImgUrl;
  int userId;

  Developer(this.id, this.profileId, this.firstName, this.lastName, this.email,
      this.description, this.country, this.phone, this.completedProjects,
      this.specialties, this.profileImgUrl, this.userId);

  factory Developer.fromJson(Map<String, dynamic>json){
    return Developer(
      json['id'],
      json['ProfileId'],
      json['firstName'],
      json['lastName'],
      json['email'],
      json['description'],
      json['country'],
      json['phone'],
      json['completedProjects'],
      json['specialties'],
      json['profileImgUrl'],
      json['userId']
    );
  }
}