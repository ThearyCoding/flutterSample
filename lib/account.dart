import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_image/accounttile.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final user = FirebaseAuth.instance.currentUser;
  void signOut() async {
    FirebaseAuth.instance.signOut();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        return await FirebaseFirestore.instance
            .collection('info')
            .doc(currentUser.email)
            .get();
      } else {
        throw FirebaseAuthException(
          code: 'user-not-authenticated',
          message: 'User is not authenticated',
        );
      }
    } catch (e) {
      print("Error fetching user details: $e");
      throw e;
    }
  }

  void removeAccount() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await currentUser.delete();
        await FirebaseFirestore.instance
            .collection('info')
            .doc(currentUser.email)
            .delete();
      }
    } catch (e) {
      print("Error removing account: $e");
    }
  }

  void _showLogoutDialog(String title, String content, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                signOut();
              },
              child: Text(message, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(String title, String content, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                removeAccount();
              },
              child: Text(message, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
            
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            Map<String, dynamic>? datauser = snapshot.data!.data();
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3.9,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset(
                            'assets/profile.png',
                            width: 120,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  datauser?['firstname'],
                                  style: const TextStyle(
                                    fontSize: 23,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  datauser?['lastname'],
                                  style: const TextStyle(
                                    fontSize: 23,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ))
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        MyListTile(
                            onTap: () {},
                            text: 'Earned Points: 0',
                            icon: Icon(Icons.star)),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                        MyListTile(
                            onTap: () {
                              _showDeleteDialog(
                                  'Remove account',
                                  'Are you sure you want to remove this account? this account will be removed from shopping-online.',
                                  'Remove');
                            },
                            text: 'Remove account',
                            icon: Icon(Icons.delete)),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                        MyListTile(
                            onTap: () {},
                            text: 'Saved Orders',
                            icon: Icon(Icons.location_pin)),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                        MyListTile(
                            onTap: () {},
                            text: 'Payment Method',
                            icon: Icon(Icons.payment_outlined)),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                        MyListTile(
                            onTap: () {},
                            text: 'Settings',
                            icon: Icon(Icons.settings)),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                        MyListTile(
                            onTap: () {
                              // _launchURL('https://flutter.dev/');

                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30)
                                        )
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3.2,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            "Contact Us",
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 23),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              _launchURL(
                                                  'https://www.facebook.com/thearyhello?mibextid=ZbWKwL');
                                            },
                                            leading: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.grey.shade200),
                                              child: Image.asset(
                                                  "assets/facebook.png"),
                                            ),
                                            title: const Text(
                                                "Contact Us with Facebook"),
                                            subtitle: Text("Thea Ry Company"),
                                          ),
                                          ListTile(
                                            onTap: () async {
                                              final Uri url = Uri(
                                                scheme: 'tel',
                                                path: '0884996818',
                                              );

                                              if (await canLaunch(
                                                  url.toString())) {
                                                await launch(url.toString());
                                              } else {
                                                print('Cannot launch this URL');
                                              }
                                            },
                                            leading: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color:
                                                        Colors.grey.shade200),
                                                child: Image.network(
                                                  'https://icons.veryicon.com/png/o/miscellaneous/communication-2/call-21.png',
                                                  width: 55,
                                                  height: 55,
                                                )),
                                            title: Text(
                                                "Contact Us with Call"),
                                            subtitle: Text("Thea Ry Company"),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              _launchURL(
                                                  'https://t.me/chorntheary');
                                            },
                                            leading: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.grey.shade200),
                                              child: Image.network(
                                                  "https://static.vecteezy.com/system/resources/previews/026/127/326/original/telegram-logo-telegram-icon-transparent-social-media-icons-free-png.png"),
                                            ),
                                            title: Text(
                                                "Contact Us with Telegram"),
                                            subtitle: Text("Thea Ry Company"),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            text: 'Contact Us',
                            icon: Icon(Icons.mark_email_read)),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                        MyListTile(
                          text: 'Log Out',
                          icon: Icon(Icons.logout),
                          onTap: () {
                            _showLogoutDialog('Log Out',
                                'Are you sure you want to log out?', 'Logout');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("No Data"),
            );
          }
        },
      ),
    );
  }
}
