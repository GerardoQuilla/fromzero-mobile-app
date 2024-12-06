class CompletePaymentResource {
  final String cardNumber;
  final String expirationDate;
  final String cvv;

  CompletePaymentResource({
    required this.cardNumber,
    required this.expirationDate,
    required this.cvv,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'expirationDate': expirationDate,
      'cvv': cvv,
    };
  }
}