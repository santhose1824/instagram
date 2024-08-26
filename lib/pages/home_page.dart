import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Database/DatabaseService.dart';
import 'package:instagram/tabs/activity_tab.dart';
import 'package:instagram/tabs/home_tab.dart';
import 'package:instagram/tabs/profile_tab.dart';
import 'package:instagram/tabs/search_tab.dart';
import 'package:instagram/tabs/upload_tab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseService databaseService = DatabaseService();
  String USERID = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    Map<String, dynamic>? userDetails =
        await databaseService.getUserDetails(USERID);
    if (userDetails != null) {
      setState(() {
        userData = userDetails;
      });
    } else {
      // Handle case where user details could not be retrieved
    }
  }

  int _currentTab = 0;
  PageController _pageController = PageController(); // Add PageController

  Future _pickImage() async {
    final _image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController, // Assign PageController to PageView
        onPageChanged: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
        children: <Widget>[
          HomeTab(),
          SearchTab(),
          UploadTab(),
          ActivityTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentTab,
        onTap: (int value) {
          setState(() {
            _currentTab = value;
          });
          _pageController.animateToPage(
            value,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey, size: 30.0),
            label: 'Home',
            activeIcon: Icon(Icons.home, color: Colors.black, size: 30.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.grey, size: 30.0),
            label: 'Search',
            activeIcon: Icon(Icons.search, color: Colors.black, size: 30.0),
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: _pickImage,
              child: Icon(Icons.add_circle_outline,
                  color: Colors.grey, size: 30.0),
            ),
            label: 'Post',
            activeIcon: Icon(Icons.add_circle_outline,
                color: Colors.black, size: 30.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.heart, color: Colors.grey),
            label: 'Activity',
            activeIcon:
                Icon(FontAwesomeIcons.solidHeart, color: Colors.black),
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 15.0,
              backgroundImage: userData != null &&
                      userData!['profilePictureURL'] != null &&
                      userData!['profileUrl'] != ''
                  ? NetworkImage(userData!['profilePictureURL'])
                      as ImageProvider
                  : AssetImage('assets/default_profile.jpg'),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
