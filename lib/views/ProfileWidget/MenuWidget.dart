import 'package:flutter/material.dart';
import 'package:fromzero_app/prefs/authProvider.dart';
import 'package:provider/provider.dart';
import '../messages/ChatListView.dart';
import '../paymentViews/DeveloperPaymentStatusView.dart';
import '../paymentViews/CompanyPendingPaymentsView.dart';
import 'EditProfileWidget.dart';

class MenuWidget extends StatelessWidget {
  final String currentUser;
  final String role;

  const MenuWidget({
    super.key,
    required this.currentUser,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            DrawerHeader(
              child: Text("Menu", style: TextStyle(fontSize: 40)),
            ),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Pagos",
              icon: Icons.credit_card,
              onTap: () {
                if (role == "DEVELOPER") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeveloperPaymentStatusView(developerId: currentUser),
                    ),
                  );
                } else if (role == "COMPANY") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompanyPendingPaymentsView(companyId: currentUser),
                    ),
                  );
                }
              },
            ),
            ProfileMenu(
              text: "Editar Perfil",
              icon: Icons.edit,
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)=>EditProfileWidget(role: role, currentUser: currentUser)
                    )
                );
              },
            ),
            ProfileMenu(
              text: "Chat",
              icon: Icons.chat,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatListView(profileId: currentUser, role: role),
                  ),
                );
              },
            ),
            ProfileMenu(
              text: "Log Out",
              icon: Icons.logout,
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onTap;

  const ProfileMenu({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: onTap!,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }
}