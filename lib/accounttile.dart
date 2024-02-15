import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyListTile extends StatelessWidget {
  final String text;
  final Icon icon;
  Function()? onTap;
  MyListTile({Key? key, required this.text, required this.icon, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade300,
        ),
        child: icon,
      ),
      title: Text(text),
    );
  }
}
