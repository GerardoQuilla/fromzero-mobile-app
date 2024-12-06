import 'package:flutter/material.dart';
import 'package:fromzero_app/api/profilesService.dart';
import 'package:fromzero_app/main.dart';
import 'package:fromzero_app/models/create_project_model.dart';
import 'package:fromzero_app/models/update_company_model.dart';
import 'package:fromzero_app/models/update_developer_model.dart';

class EditProfileWidget extends StatefulWidget {
  final String role;
  final String currentUser;

  const EditProfileWidget({
    super.key,
    required this.role,
    required this.currentUser,
  });

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final ProfilesService _profilesService = ProfilesService();

  TextEditingController description = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController profileImgUrl = TextEditingController();
  TextEditingController specialties = TextEditingController();
  TextEditingController ruc = TextEditingController();
  TextEditingController website = TextEditingController();
  TextEditingController sector = TextEditingController();

  List<Languages> selectedLanguages = [];
  List<Frameworks> selectedFrameworks = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    if (widget.role == "DEVELOPER") {
      final developer = await _profilesService.getDeveloper(widget.currentUser);
      setState(() {
        description.text = developer.description;
        country.text = developer.country;
        phone.text = developer.phone;
        specialties.text = developer.specialties;
        profileImgUrl.text = developer.profileImgUrl;
      });
    } else if (widget.role == "COMPANY") {
      final company = await _profilesService.getCompany(widget.currentUser);
      setState(() {
        description.text = company.description;
        country.text = company.country;
        phone.text = company.phone;
        profileImgUrl.text = company.profileImgUrl;
        ruc.text = company.ruc;
        website.text = company.website;
        sector.text = company.sector;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (widget.role == "DEVELOPER") {
      final resource = UpdateDeveloperProfileResource(
        description: description.text,
        country: country.text,
        phone: phone.text,
        specialties: _formatSpecialties(),
        profileImgUrl: profileImgUrl.text,
      );
      await _profilesService.editDeveloperProfile(widget.currentUser, resource);
    } else if (widget.role == "COMPANY") {
      final resource = UpdateCompanyProfileResource(
        description: description.text,
        country: country.text,
        phone: phone.text,
        profileImgUrl: profileImgUrl.text,
        ruc: ruc.text,
        website: website.text,
        sector: sector.text,
      );
      await _profilesService.editCompanyProfile(widget.currentUser, resource);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AuthHandler(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Changes saved')),
    );
  }

  String _formatSpecialties() {
    String frameworks = selectedFrameworks.map((f) => f.name).join(', ');
    String languages = selectedLanguages.map((l) => l.name).join(', ');
    return 'Frameworks: [$frameworks] Languages: [$languages] ${specialties.text}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Perfil"),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4.0,
                alignment: WrapAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(profileImgUrl.text),
                  ),
                  TextFormField(
                    controller: profileImgUrl,
                    decoration: InputDecoration(labelText: "Profile Image URL"),
                    keyboardType: TextInputType.text,
                  )
                ],
              ),
              const SizedBox(height: 20),
              _buildProfileForm(),
              const SizedBox(height: 20),
              if (widget.role == "DEVELOPER") _buildSpecialtiesForm(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004CFF),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return Column(
      children: [
        _buildTextField("Description", description),
        _buildTextField("Country", country),
        _buildTextField("Phone", phone),
        if (widget.role == "COMPANY") ...[
          _buildTextField("RUC", ruc),
          _buildTextField("Website", website),
          _buildTextField("Sector", sector),
        ],
      ],
    );
  }

  Widget _buildSpecialtiesForm() {
    return Column(
      children: [
        Text("Specialties", style: TextStyle(fontSize: 20)),
        _buildDropdown<Languages>(
          "Select Languages",
          Languages.values,
          selectedLanguages,
              (Languages? value) {
            setState(() {
              if (value != null && !selectedLanguages.contains(value)) {
                selectedLanguages.add(value);
              }
            });
          },
        ),
        _buildDropdown<Frameworks>(
          "Select Frameworks",
          Frameworks.values,
          selectedFrameworks,
              (Frameworks? value) {
            setState(() {
              if (value != null && !selectedFrameworks.contains(value)) {
                selectedFrameworks.add(value);
              }
            });
          },
        ),
        TextFormField(
          controller: specialties,
          decoration: InputDecoration(labelText: "Additional Specialties"),
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }

  Widget _buildDropdown<T>(String label, List<T> items, List<T> selectedItems, ValueChanged<T?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        DropdownButton<T>(
          isExpanded: true,
          hint: Text("Select $label"),
          items: items.map((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(value.toString().split('.').last),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        Wrap(
          children: selectedItems.map((item) {
            return Chip(
              label: Text(item.toString().split('.').last),
              onDeleted: () {
                setState(() {
                  selectedItems.remove(item);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}