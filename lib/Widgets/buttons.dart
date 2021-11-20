import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final void Function() onPress;
  final String content;

  const LoginButton({
    required this.onPress,
    required this.content,
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 60,
      child: RaisedButton(
        highlightColor: Colors.grey[500],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        onPressed: onPress,
        color: Colors.lime[50],
        padding: const EdgeInsets.all(12.0),
        child: Text(
          content,
          style: const TextStyle(
            fontFamily: 'Source Sans Pro',
            fontSize: 25.0,
            color: Colors.indigoAccent,
            //Colors.indigoAccent.shade200,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class SimpleButton extends StatelessWidget {
  final void Function() onPress;
  final String content;
  final double width;
  final double height;

  const SimpleButton({
    required this.onPress,
    required this.content,
    required this.width,
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Colors.lightBlue.shade200,
            Colors.indigoAccent.shade200,
          ],
        ),
      ),
      width: width,
      height: height,
      child: RaisedButton(
        highlightColor: Colors.grey[500],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        onPressed: onPress,
        color: Colors.transparent,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          content,
          style: const TextStyle(
            fontFamily: 'Source Sans Pro',
            fontSize: 25.0,
            color: Colors.white,
            //Colors.indigoAccent.shade200,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

