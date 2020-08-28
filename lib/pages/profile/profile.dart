import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String title;

  const Profile({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title),
    );
  }
}
