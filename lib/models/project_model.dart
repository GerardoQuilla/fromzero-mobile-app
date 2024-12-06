class Project {
  int id;
  String name;
  String description;
  String state;
  double progress;
  String companyId;
  String? developerId;
  List<dynamic> candidates;
  List<dynamic> languages;
  List<dynamic> frameworks;
  String type;
  String budget;

  Project(this.id, this.name, this.description, this.state, this.progress,
      this.companyId, this.developerId, this.candidates, this.languages,
      this.frameworks, this.type, this.budget);

  factory Project.fromJson(Map<String, dynamic>json){
    return Project(
      json['id'],
      json['name'],
      json['description'],
      json['state'],
      json['progress'],
      json['companyId'],
      json['developerId'] ?? "",
      json['candidates'],
      json['languages'],
      json['frameworks'],
      json['type'],
      json['budget']
    );
  }
}
