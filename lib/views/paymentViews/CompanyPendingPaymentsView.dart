import 'package:flutter/material.dart';
import 'package:fromzero_app/api/paymentService.dart';
import 'package:fromzero_app/api/projectsService.dart';
import 'package:fromzero_app/models/payment_model.dart';
import 'package:fromzero_app/models/project_model.dart';
import 'package:fromzero_app/models/complete_payment_model.dart';

class CompanyPendingPaymentsView extends StatefulWidget {
  final String companyId;

  const CompanyPendingPaymentsView({Key? key, required this.companyId}) : super(key: key);

  @override
  _CompanyPendingPaymentsViewState createState() => _CompanyPendingPaymentsViewState();
}

class _CompanyPendingPaymentsViewState extends State<CompanyPendingPaymentsView> {
  late Future<List<Payment>> _pendingPayments;
  Map<int, String> _projectNames = {};

  @override
  void initState() {
    super.initState();
    _pendingPayments = _getPendingPayments();
  }

  Future<List<Payment>> _getPendingPayments() async {
    final projectsService = ProjectsService();
    final paymentService = PaymentService();

    final projects = await projectsService.getProjectsByCompanyId();
    for (Project project in projects) {
      _projectNames[project.id] = project.name;
    }

    List<Payment> payments = [];
    for (Project project in projects) {
      try {
        final payment = await paymentService.getProjectPayment(project.id);
        payments.add(payment);
      } catch (e) {
        print("Error getting payment for project ${project.id}: $e");
      }
    }
    return payments;
  }

  Future<void> _completePayment(Payment payment) async {
    final cardNumberController = TextEditingController();
    final expirationDateController = TextEditingController();
    final cvvController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Complete Payment"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cardNumberController,
                decoration: InputDecoration(labelText: "Card Number"),
              ),
              TextField(
                controller: expirationDateController,
                decoration: InputDecoration(labelText: "Expiration Date"),
              ),
              TextField(
                controller: cvvController,
                decoration: InputDecoration(labelText: "CVV"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final resource = CompletePaymentResource(
                  cardNumber: cardNumberController.text,
                  expirationDate: expirationDateController.text,
                  cvv: cvvController.text,
                );
                await PaymentService().completePayment(payment.projectId, resource);
                Navigator.of(context).pop(true);
              },
              child: Text("Pay"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      setState(() {
        _pendingPayments = _getPendingPayments();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Pagos pendientes"),
        backgroundColor: Colors.lightBlue,
      ),
      body: FutureBuilder<List<Payment>>(
        future: _pendingPayments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No pending payments found"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final payment = snapshot.data![index];
                final projectName = _projectNames[payment.projectId] ?? "Unknown Project";
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text("Project: $projectName"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Amount: ${payment.amount}"),
                        Text("Status: ${payment.status}"),
                      ],
                    ),
                    trailing: payment.status == "PENDIENTE"
                        ? ElevatedButton(
                      onPressed: () => _completePayment(payment),
                      child: Text("Pay"),
                    )
                        : null,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}