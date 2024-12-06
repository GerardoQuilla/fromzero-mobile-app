import 'package:flutter/material.dart';
import 'package:fromzero_app/models/company_model.dart';
import 'package:fromzero_app/views/projectsViews/projectsList.dart';

class ProfileWidget extends StatelessWidget {
  final Company profile;
  const ProfileWidget({super.key,required this.profile});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 115,
                    width: 115,
                    child: CircleAvatar(
                      backgroundImage:
                      NetworkImage(profile.profileImgUrl),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.companyName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context)=>
                                      ProjectsList()

                              )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        ),
                        child: Text("Ver Proyectos",style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                        ),),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                children: [
                  _buildTableRow("País", profile.country),
                  _buildTableRow("Correo", profile.email),
                  _buildTableRow("Teléfono", profile.phone),
                  _buildTableRow("RUC", profile.ruc),
                  _buildTableRow("Sitio web", profile.website),
                  _buildTableRow("Sector", profile.sector),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Descripción",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(profile.description,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String key, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            key,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value, style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}

/*class ProfilePic extends StatelessWidget {
  final String urlToImage="https://cdn-icons-png.flaticon.com/512/3237/3237472.png";

  ProfilePic({required urlToImage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: CircleAvatar(
        backgroundImage:
        NetworkImage(urlToImage),
      ),
    );
  }
}*/
