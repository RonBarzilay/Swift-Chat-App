import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swift_chat/win/chat_win.dart';
import 'package:swift_chat/win/login_win.dart';
import 'package:swift_chat/win/registration_win.dart';
import 'package:swift_chat/win/welcome_win.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // copyWith: copy all properties, except make change in one property
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeWindow.id,
      routes: {
        WelcomeWindow.id: (context) => WelcomeWindow(),
        LoginWindow.id: (context) => LoginWindow(),
        RegistrationWindow.id: (context) => RegistrationWindow(),
        ChatWindow.id: (context) => ChatWindow()
      },
    );
  }
}
