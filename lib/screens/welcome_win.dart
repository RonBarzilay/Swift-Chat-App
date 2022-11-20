import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/rounded_button.dart';
import '../screens/registration_win.dart';
import 'login_win.dart';

class WelcomeWindow extends StatefulWidget {
  static String id = '/';
  const WelcomeWindow({Key? key}) : super(key: key);

  @override
  _WelcomeWindowState createState() => _WelcomeWindowState();
}

class _WelcomeWindowState extends State<WelcomeWindow>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
        upperBound: 1);
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.forward();

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return CupertinoPageScaffold(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                const CupertinoSliverNavigationBar(
                  largeTitle: const Text('Let\'s Begin'),
                )
              ];
            },
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Hero(
                          tag: 'logo',
                          child: Container(
                            height: animation.value * 100,
                            child: Image.asset('assets/images/logo.png'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Swift \nChat',
                          style: TextStyle(
                              fontSize: 40.0 * animation.value,
                              fontWeight: FontWeight.w900,
                              color: Colors.amber),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RoundedButton(
                        title: 'Log In',
                        color: Colors.lightBlueAccent,
                        onPress: () =>
                            Navigator.pushNamed(context, LoginWindow.id)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RoundedButton(
                      title: 'Register',
                      color: Colors.blueAccent,
                      onPress: () =>
                          Navigator.pushNamed(context, RegistrationWindow.id),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
