import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_image/button_login.dart';



// ignore: must_be_immutable
class MyLoginScreen extends StatefulWidget {
  void Function()? onPressed;
  MyLoginScreen({super.key, required this.onPressed});

  @override
  State<MyLoginScreen> createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool isPasswordVisible = false;
  final TextEditingController _passwordController = TextEditingController();
  void signUserIn() async {
  final isValid = formkey.currentState!.validate();
  if (!isValid) return;

  showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context); // Dismiss the loading dialog
    String errorMessage;

    if (e.code == 'user-not-found') {
      errorMessage = 'User not found. Please check your email.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Wrong password. Please try again.';
    } else {
      errorMessage = e.message ?? 'An error occurred';
    }

    showErrorMessage(errorMessage);
    return;
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

  final formkey = GlobalKey<FormState>();
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
            top: 10,
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
            anchor: 0.28,
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
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  height: MediaQuery.of(context).size.height / 1.6,
                  width: double.maxFinite,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Form(

                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 6,
                          ),
                          const Text(
                            "Login Account",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) =>
                                email != null && !EmailValidator.validate(email)
                                    ? 'please enter a valid email'
                                    : null,
                            controller: _emailController,
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
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                child: const Text(
                                  "Is case you forgot password?",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 51, 116, 228),
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            onPressed: signUserIn,
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.blueAccent,
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(double.infinity, 50),
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
                              "Login",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: widget.onPressed,
                      child: const Text(
                        "Register Now",
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
