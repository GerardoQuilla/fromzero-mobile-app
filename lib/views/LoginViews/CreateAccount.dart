import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fromzero_app/api/authService.dart';

class CreateAccountWidget extends StatefulWidget {
  const CreateAccountWidget({super.key});

  @override
  _CreateAccountWidgetState createState() => _CreateAccountWidgetState();
}

class _CreateAccountWidgetState extends State<CreateAccountWidget> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? selectedProfile;
  bool _obscurePassword = true;
  String terms = "";
  bool isTAndCChecked = false;

  Future<String> loadTAndC()async{
    return await rootBundle.loadString('lib/assets/Terms_And_Conditions_Fromzero.txt');
  }

  Future<void> registerUser(BuildContext context)async{
    var service = AuthService();
    if(selectedProfile=="Empresa"){
      final response = await service.registerCompany(
          emailController.text,
          passwordController.text,
          companyNameController.text
      );
      if(response.statusCode==201){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuario Empresa creado"))
        );
        Navigator.pop(context);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Ocurrió un error"))
        );
      }
    }else {
      final response = await service.registerDeveloper(
          emailController.text,
          passwordController.text,
          firstNameController.text,
          lastNameController.text
      );
      if(response.statusCode==201){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Usuario Desarrollador creado"))
        );
        Navigator.pop(context);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Ocurrió un error"))
        );
      }
    }

  }

  String? validateCheckbox(bool? value) {
    if (value == null || !value) {
      return 'Debes aceptar los Términos y Condiciones';
    }
    return null;
  }

  void showTermsAndConditions(BuildContext context)async{
    terms= await loadTAndC();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Términos y Condiciones"),
            content: SingleChildScrollView(
              child: terms==""?CircularProgressIndicator():Text(
                terms,
                style: TextStyle(fontSize: 14),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("Cerrar")
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Create\nAccount",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 40),
                  _buildInputContainer(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedProfile,
                        hint: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text("Profile"),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        items: [
                          DropdownMenuItem(
                            child: Text("Empresa"),
                            value: "Empresa",
                          ),
                          DropdownMenuItem(
                            child: Text("Desarrollador"),
                            value: "Desarrollador",
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedProfile = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Seleccione un perfil";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInputContainer(
                    child: TextFormField(
                      controller: emailController,
                      decoration: _inputDecoration("Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Este campo es obligatorio";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInputContainer(
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.grey[800]),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Este campo es obligatorio";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  if (selectedProfile == "Desarrollador") ...[
                    _buildInputContainer(
                      child: TextFormField(
                        controller: firstNameController,
                        decoration: _inputDecoration("First Name"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Este campo es obligatorio";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildInputContainer(
                      child: TextFormField(
                        controller: lastNameController,
                        decoration: _inputDecoration("Last Name"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Este campo es obligatorio";
                          }
                          return null;
                        },
                      ),
                    ),
                  ]else if(selectedProfile == "Empresa")...[
                    _buildInputContainer(
                      child: TextFormField(
                        controller: companyNameController,
                        decoration: _inputDecoration("Company Name"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Este campo es obligatorio";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Checkbox(
                          value: isTAndCChecked,
                          onChanged: (bool? value){
                            setState(() {
                              isTAndCChecked=value??false;
                            });
                          }
                      ),
                      GestureDetector(
                        onTap: ()=>showTermsAndConditions(context),
                        child: Text(
                          "Acepto los Términos y Condiciones",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    enabled: false,
                    validator: (value)=>validateCheckbox(isTAndCChecked),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF004CFF),
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Registrarse"),
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("No válido")),
                        );
                      } else {
                        registerUser(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[800]),
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.transparent),
      ),
    );
  }
}
