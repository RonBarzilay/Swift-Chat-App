import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPress;
  const RoundedButton(
      {Key? key,
      required this.title,
      required this.color,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3.0,
      color: color,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed: onPress,
        minWidth: 200.0,
        height: 42.0,
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
