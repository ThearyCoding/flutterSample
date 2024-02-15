import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:store_image/account.dart';
import 'package:store_image/showdata.dart';
import 'package:store_image/upload_product.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  PanelController _panelController = PanelController();
  @override
  void initState() {
    screens = [
     Showdata(),
     UploadProduct(panecontroller:_panelController,),
     Account(),
  ];
    super.initState();
  }
  int _selectedIndex = 0;
  List<Widget> screens = [];

  
  
 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        panelBuilder: (sc) {
          return UploadProduct(panecontroller: _panelController,);
        },
        body: screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            padding: const EdgeInsets.all(10),
            selectedIndex: _selectedIndex,
            onTabChange: (int index) {
              if (index == 1) {
                _panelController.isPanelOpen
                    ? _panelController.close()
                    : _panelController.open();
              } else {
                setState(() {
                  _panelController.close();
                  _selectedIndex = index;
                });
              }
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Feed",
              ),
              GButton(
                icon: Icons.add,
                text: "Add",
              ),
              GButton(
                icon: Icons.person,
                text: 'User',
              )
            ],
          ),
        ),
      ),
    );
  }
}
