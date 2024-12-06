import 'package:flutter/material.dart';
import 'package:fromzero_app/views/LoginViews/CreateAccount.dart';
import 'package:fromzero_app/views/LoginViews/Login.dart';

class GetStartedScreen extends StatelessWidget {

  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: Image(
                    image: AssetImage('lib/assets/FromZero.png')
                )
            ),
            const Text(
              'Magnificent user interface for\ncreating software development',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'NunitoSans',
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                child: const Text(
                  "Let's get started",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004CFF),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(340, 50),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=>CreateAccountWidget()
                      )
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'I already have an account',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'NunitoSans',
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Color(0xFF004CFF),
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=>LoginWidget()
                          )
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
