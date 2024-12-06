import 'package:flutter/material.dart';
import 'package:fromzero_app/api/paymentService.dart';
import 'package:fromzero_app/api/projectsService.dart';
import 'package:fromzero_app/models/payment_model.dart';
import 'package:fromzero_app/models/project_model.dart';

class DeveloperPaymentStatusView extends StatelessWidget {
  final String developerId;

  const DeveloperPaymentStatusView({Key? key, required this.developerId}) : super(key: key);

  Future<Map<int, String>> _getProjectNames() async {
    final projectsService = ProjectsService();
    final projects = await projectsService.getProjectsByDeveloperId();
    return {for (var project in projects) project.id: project.name};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Pagos recibidos"),
          backgroundColor: Colors.lightBlue,
      ),
      body: FutureBuilder<Map<int, String>>(
        future: _getProjectNames(),
        builder: (context, projectSnapshot) {
          if (projectSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (projectSnapshot.hasError) {
            return Center(child: Text("Error: ${projectSnapshot.error}"));
          } else {
            return FutureBuilder<List<Payment>>(
              future: PaymentService().getAllPaymentsByDeveloper(developerId),
              builder: (context, paymentSnapshot) {
                if (paymentSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (paymentSnapshot.hasError) {
                  return Center(child: Text("Error: ${paymentSnapshot.error}"));
                } else if (!paymentSnapshot.hasData || paymentSnapshot.data!.isEmpty) {
                  return Center(child: Text("No payments found"));
                } else {
                  return ListView.builder(
                    itemCount: paymentSnapshot.data!.length,
                    itemBuilder: (context, index) {
                      final payment = paymentSnapshot.data![index];
                      final projectName = projectSnapshot.data![payment.projectId] ?? "Unknown Project";
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
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}