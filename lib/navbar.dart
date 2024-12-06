import 'package:flutter/material.dart';
import 'package:fromzero_app/api/profilesService.dart';
import 'package:fromzero_app/prefs/authProvider.dart';
import 'package:fromzero_app/views/ProfileWidget/MenuWidget.dart';
import 'package:fromzero_app/views/ProfileWidget/ProfileDevWidget.dart';
import 'package:fromzero_app/views/ProfileWidget/ProfileWidget.dart';
import 'package:fromzero_app/views/applyToProjectViews/ListProjects.dart';
import 'package:fromzero_app/views/createProjectViews/CreateProjectWidget.dart';
import 'package:fromzero_app/views/exploreDevelopersViews/ProjectMainList.dart';
import 'package:fromzero_app/views/highlightProjects/highlightProjectsWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navbar extends StatefulWidget {


  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedView = 0;
  String role = "";
  dynamic currentUser;
  String userId = "";
  List<Widget> views =[];

  Future<void> setUser()async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      role = prefs.getString("role")??"";
      print(role);
    }catch(e){
      Provider.of<AuthProvider>(context,listen: false).logout();
      throw Exception(e);
    }

    var service = ProfilesService();

    if(role=="COMPANY"){
      final response = await service.getCompanyByProfileId();
      setState(() {
        currentUser=response;
        userId = response.profileId;
        views = [
          currentUser!=null?ProfileWidget(profile:currentUser,):Container(),
          DeveloperListScreen(currentUser: currentUser,),
          HighlightProjects(),
          const CreateProjectApp(),
        ];
      });
    }else if(role=="DEVELOPER"){
      final response = await service.getDeveloperByProfileId();
      setState(() {
        currentUser=response;
        userId = response.profileId;
        views = [
          currentUser!=null?ProfileDevWidget(profile: currentUser,):Container(),
          const ApplyToProjects(),
          HighlightProjects(),
        ];
      });
    }else{
      Provider.of<AuthProvider>(context,listen: false).logout();
      print("Rol desconocido");
    }
  }

  @override
  void initState() {
    super.initState();
    setUser();
  }

  void setView(int view) {
    setState(() {
      selectedView = view;
    });
  }

  Text setViewTitle() {

    if(role=="COMPANY") {
      switch (selectedView) {
        case 0:
          return const Text(
            "Perfil",
            style: TextStyle(fontSize: 35),
          );
        case 1:
          return const Text(
            "Buscar Desarrolladores",
            style: TextStyle(fontSize: 25),
          );
        case 2:
          return const Text(
            "Proyectos Terminados",
            style: TextStyle(fontSize: 25),
          );
        default:
          return const Text(
            "Crear Proyecto",
            style: TextStyle(fontSize: 30),
          );
      }
    }else{
      // DEVELOPER
      switch (selectedView) {
        case 0:
          return const Text(
            "Perfil",
            style: TextStyle(fontSize: 35),
          );
        case 1:
          return const Text(
            "Buscar Proyectos",
            style: TextStyle(fontSize: 25),
          );
        default:
          return const Text(
            "Proyectos Terminados",
            style: TextStyle(fontSize: 25),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        leading: Builder(
            builder: (BuildContext aContext){
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: (){
                  Scaffold.of(aContext).openDrawer();
                },
              );
            }
        ),
        title: setViewTitle(),
      ),
      drawer: MenuWidget(currentUser: userId, role: role),
      body: IndexedStack(
        index: selectedView,
        children: views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedView,
        onTap: (index) {
          setState(() {
            selectedView = index;
          });
        },
        items: (role=="COMPANY")?[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Buscar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Proyectos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_file_rename_outline),
            label: "Publicar",
          ),
        ]:[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Buscar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Proyectos",
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
      ),
    );
  }
}
