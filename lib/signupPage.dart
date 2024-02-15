import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_image/button_login.dart';

// ignore: must_be_immutable
class RegistrationForm extends StatefulWidget {
  void Function()? onPressed;
  RegistrationForm({super.key, required this.onPressed});
  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  Future signUpUser() async {
    final isvalid = formkey.currentState!.validate();
    if (!isvalid) return;
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());
     
      createUserDocument(userCredential);
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.message ?? "An error occurred");
    }
     Navigator.pop(context);
  }

  void showErrorMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(errorMessage),
          );
        });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> createUserDocument(UserCredential? credentials) async {
    if (credentials != null && credentials.user != null) {
      await FirebaseFirestore.instance
          .collection('info')
          .doc(credentials.user!.email)
          .set({
        'email': credentials.user!.email,
        'firstname': _firstnameController.text.trim(),
        'lastname': _lastnameController.text.trim()
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(70.0),
                bottomRight: Radius.circular(70.0),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/logo-Starbuks.png",
              width: 250,
              height: 250,
            ),
          ),
          // Positioned(
          //   top: 80,
          //   left: 0,
          //   right: -180,
          //   child: Image.network(
          //     "https://cdn4.iconfinder.com/data/icons/Starbucks_coffee/PNG/512x512/starbucks_coffee_2.png",
          //     width: 150,
          //     height: 150,
          //   ),
          // ),
          CustomScrollView(
            anchor: 0.2,
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: double.maxFinite,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.6,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a last name';
                                      }
                                      return null;
                                    },
                                    controller: _firstnameController,
                                    decoration: const InputDecoration(
                                      labelText: 'First Name',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF6200EE),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF6200EE)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.6,
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a last name';
                                      }
                                      return null;
                                    },
                                    controller: _lastnameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Last Name',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF6200EE),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF6200EE),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextFormField(
                            controller: _emailController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) =>
                                email != null && !EmailValidator.validate(email)
                                    ? 'please enter a valid email'
                                    : null,
                            decoration: const InputDecoration(
                              labelText: 'Name or E-mail ',
                              labelStyle: TextStyle(
                                color: Color(0xFF6200EE),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF6200EE)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) =>
                                value != null && value.length < 6
                                    ? 'please min. 6 characters'
                                    : null,
                            controller: _passwordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText:
                                !isPasswordVisible,

                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Color(0xFF6200EE),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF6200EE)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await signUpUser();
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.blueAccent,
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                  Size(double.infinity, 50),
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.white,
                                ),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            child: const Text(
                              "Register Now",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ignore: sized_box_for_whitespace
                              Container(
                                width: 130,
                                child: const Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: 130,
                                child: const Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonLogin(path: 'assets/facebook.png'),
                              const SizedBox(
                                width: 10,
                              ),
                              ButtonLogin(path: 'assets/google.png')
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Text("Have an account?"),
                    TextButton(
                      onPressed: widget.onPressed,
                      child: const Text(
                        "Login Now",
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
