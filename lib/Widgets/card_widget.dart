import 'package:flutter/material.dart';

class PasswordCard extends StatelessWidget {
  final String website;
  final String username;
  final String description;
  final void Function() popup;

  const PasswordCard({
    required this.website,
    required this.username,
    required this.description,
    required this.popup
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(
          right: 30.0,
          left: 30,
          top: 10,
          bottom: 10
      ),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            offset: Offset(0.0, 3.0), //(x,y)
            blurRadius: 5.0,
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Colors.lightBlue.shade200,
            Colors.indigoAccent.shade200,
          ],
        ),
      ),
      child: RaisedButton(
        highlightColor: Colors.grey[500],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        onPressed: popup,
        color: Colors.transparent,
        padding: const EdgeInsets.all(8.0),
        child:Text(
          "Website: $website\nUsername: $username\n$description",
          overflow: TextOverflow.fade,
          textAlign: TextAlign.center,
          softWrap: false,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: "Source Sans Pro",
            color: Colors.white,
            height: 1.5,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}