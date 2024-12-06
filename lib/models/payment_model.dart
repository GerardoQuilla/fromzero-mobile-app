class Payment {
  final int id;
  final String developerId;
  final int projectId;
  final String amount;
  final String status;

  Payment({
    required this.id,
    required this.developerId,
    required this.projectId,
    required this.amount,
    required this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      developerId: json['developerId'],
      projectId: json['projectId'],
      amount: json['amount'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'developerId': developerId,
      'projectId': projectId,
      'amount': amount,
      'status': status,
    };
  }
}