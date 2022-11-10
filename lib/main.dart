import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swift_chat/screens/chat_win.dart';
import 'package:swift_chat/screens/login_win.dart';
import 'package:swift_chat/screens/registration_win.dart';
import 'package:swift_chat/screens/welcome_win.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SwiftChat());
}

class SwiftChat extends StatelessWidget {
  const SwiftChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      title: 'Swift Chat',
      // copyWith: copy all properties, except make change in one property
      // theme: ThemeData.dark().copyWith(
      //   textTheme: const TextTheme(
      //     bodyLarge: TextStyle(color: Colors.black54),
      //   ),
      // ),
      initialRoute: WelcomeWindow.id,
      routes: {
        '/': (context) => const WelcomeWindow(),
        LoginWindow.id: (context) => LoginWindow(),
        RegistrationWindow.id: (context) => RegistrationWindow(),
        ChatWindow.id: (context) => ChatWindow()
      },
    );
  }
}
