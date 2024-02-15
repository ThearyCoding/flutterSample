import 'package:flutter/material.dart';
import 'package:store_image/Login.dart';
import 'package:store_image/signupPage.dart';



class RegisterOrLoginPage extends StatefulWidget {
  const RegisterOrLoginPage({super.key});

  @override
  State<RegisterOrLoginPage> createState() => _RegisterOrLoginPageState();
}

class _RegisterOrLoginPageState extends State<RegisterOrLoginPage> {
  bool showloginPage = true;

  void togglePages(){
    setState(() {
      showloginPage = !showloginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showloginPage) {
      return MyLoginScreen(onPressed: togglePages);
    }else{
      return RegistrationForm(onPressed: togglePages,);
    }
  }
}