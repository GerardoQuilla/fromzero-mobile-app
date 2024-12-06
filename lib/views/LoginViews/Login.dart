import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fromzero_app/api/authService.dart';
import 'package:fromzero_app/api/profilesService.dart';
import 'package:fromzero_app/api/usersService.dart';
import 'package:fromzero_app/prefs/authProvider.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final service = AuthService();
  final userService = UsersService();
  final profileService = ProfilesService();
  bool _obscurePassword = true;

  Future<void> login(BuildContext context)async{
    FocusScope.of(context).unfocus();
    final response = await service.login(emailController.text, passwordController.text);
    if(response.statusCode==200){
      Map<String,dynamic> data = jsonDecode(response.body);
      String token = data['token'];
      int userId = int.parse(data['id'].toString());
      String email = data['email'];
      Map<String,dynamic> rolesData = await userService.getUserById(userId,token);
      String role = rolesData['role'];
      String profileId="";
      if(role=="COMPANY"){
        profileId=await profileService.getCompanyProfileIdByEmail(email, token);
      }else if(role=="DEVELOPER"){
        profileId = await profileService.getDeveloperProfileIdByEmail(email, token);
      }

      if(!mounted)return;

      Provider.of<AuthProvider>(context,listen: false).login(token, profileId, role);
      Navigator.pop(context);
    }else return;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100), // Espacio superior
                Row(
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8), // Espacio entre el título y la frase
                Row(
                  children: [
                    Text(
                      "Good to see you back!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 4), // Ajuste de espacio entre la frase y el corazón
                    Icon(
                      Icons.favorite,
                      color: Colors.black,
                    ),
                  ],
                ),
                SizedBox(height: 40), // Espacio entre la frase y las cajas de texto
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
                SizedBox(height: 20), // Espacio entre las cajas de texto
                _buildInputContainer(
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword, // Controla la visibilidad de la contraseña
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.grey[800]), // Color gris oscuro para la letra
                      filled: true, // Para llenar el fondo
                      fillColor: Colors.grey[200], // Color de fondo del campo
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.transparent), // Sin borde visible
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.transparent), // Sin borde visible
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.transparent), // Sin borde visible
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword; // Alternar visibilidad
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
                SizedBox(height: 40), // Espacio entre el campo de contraseña y el botón
                Center( // Centra el botón en la pantalla
                  child: ElevatedButton(
                    child: Text("Next", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF004CFF), // Color de fondo del botón
                      padding: EdgeInsets.symmetric(vertical: 15), // Ajuste del padding
                      minimumSize: Size(double.infinity, 50), // Ancho del botón
                    ),
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("No válido")),
                        );
                      } else {

                        login(context);

                      }
                    },
                  ),
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
        color: Colors.grey[200], // Fondo gris suave
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Cambia la posición de la sombra
          ),
        ],
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[800]), // Color gris oscuro para la letra
      filled: true, // Para llenar el fondo
      fillColor: Colors.grey[200], // Color de fondo del campo
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.transparent), // Sin borde visible
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.transparent), // Sin borde visible
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.transparent), // Sin borde visible
      ),
    );
  }
}
