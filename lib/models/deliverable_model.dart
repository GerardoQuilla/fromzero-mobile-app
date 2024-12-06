class Deliverable{
  int id;
  String name;
  String description;
  String date;
  String state;
  String? developerMessage;
  int projectId;

  Deliverable(this.id, this.name, this.description, this.date, this.state,
      this.developerMessage, this.projectId);

  factory Deliverable.fromJson(Map<String,dynamic> json){
    return Deliverable(
      json['id'],
      json['name'],
      json['description'],
      json['date'],
      json['state'],
      json['developerMessage'] ?? "",
      json['projectId']
    );
  }

}