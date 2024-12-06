import 'package:flutter/material.dart';
import 'package:fromzero_app/api/profilesService.dart';
import 'package:fromzero_app/models/company_model.dart';
import 'package:fromzero_app/models/developer_model.dart';
import 'package:fromzero_app/models/create_project_model.dart';
import 'package:fromzero_app/views/exploreDevelopersViews/previewDevelopers.dart';

class DeveloperListScreen extends StatefulWidget {
  final Company currentUser;
  const DeveloperListScreen({
    super.key,
    required this.currentUser
  });

  @override
  State<DeveloperListScreen> createState() => _DeveloperListScreenState();
}

class _DeveloperListScreenState extends State<DeveloperListScreen> {
  List<Developer> developers = [];
  List<Developer> filteredDevelopers = [];
  String selectedCountry = 'All';
  String selectedFramework = 'All';
  String selectedLanguage = 'All';
  List<String> countries = ['All'];
  List<String> frameworks = ['All'];
  List<String> languages = ['All'];

  @override
  void initState() {
    super.initState();
    fetchDevelopers();
  }

  Future<void> fetchDevelopers() async {
    var service = ProfilesService();
    final response = await service.getAllDevelopers();
    setState(() {
      developers = response;
      filteredDevelopers = response;
      countries.addAll(response.map((dev) => dev.country).toSet().toList());
      frameworks.addAll(Frameworks.values.map((f) => f.name).toList());
      languages.addAll(Languages.values.map((l) => l.name).toList());
    });
  }

  void filterDevelopers() {
    setState(() {
      filteredDevelopers = developers.where((developer) {
        final matchesCountry = selectedCountry == 'All' || developer.country == selectedCountry;
        final matchesFramework = selectedFramework == 'All' || developer.specialties.contains(selectedFramework);
        final matchesLanguage = selectedLanguage == 'All' || developer.specialties.contains(selectedLanguage);
        return matchesCountry && matchesFramework && matchesLanguage;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedCountry,
                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value!;
                        filterDevelopers();
                      });
                    },
                    items: countries.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedFramework,
                    onChanged: (value) {
                      setState(() {
                        selectedFramework = value!;
                        filterDevelopers();
                      });
                    },
                    items: frameworks.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        selectedLanguage = value!;
                        filterDevelopers();
                      });
                    },
                    items: languages.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredDevelopers.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredDevelopers.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(filteredDevelopers[index].profileImgUrl),
                      radius: 30,
                    ),
                    title: Text(
                      '${filteredDevelopers[index].firstName} ${filteredDevelopers[index].lastName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Proyectos Completados: ${filteredDevelopers[index].completedProjects}',
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PreviewDeveloper(developer: filteredDevelopers[index], currentUser: widget.currentUser),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Ver perfil', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}