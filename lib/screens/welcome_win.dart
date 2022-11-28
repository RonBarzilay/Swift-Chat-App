import 'package:animated_text_kit/animated_text_kit.dart';
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
                  largeTitle: Text('Swift Chat',
                      style: TextStyle(color: Colors.white70)),
                  backgroundColor: Color(0XFF9F73AA),
                )
              ];
            },
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0XFF9F73AB), Color(0XFFA3C7D6)]),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Let\'s',
                            style: TextStyle(
                                fontSize: 40.0 * animation.value,
                                fontWeight: FontWeight.w900,
                                color: Colors.white70),
                          ),
                          const SizedBox(width: 20.0, height: 100.0),
                          Container(
                            height: 60,
                            width: 160,
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 40.0,
                                fontFamily: 'Horizon',
                              ),
                              child: AnimatedTextKit(
                                isRepeatingAnimation: true,
                                repeatForever: true,
                                animatedTexts: [
                                  RotateAnimatedText('Connect',
                                      rotateOut: true),
                                  RotateAnimatedText('Chat'),
                                  RotateAnimatedText('Begin'),
                                ],
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
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
          ),
        );
      },
    );
  }
}
