import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Database/DatabaseService.dart';
import 'package:instagram/tabs/profile_tab.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _imageFile;
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String USERID = FirebaseAuth.instance.currentUser!.uid;
  int buttonColor = 0xff26A9FF;

  bool inputTextNotNull = false;
  bool _isStoring = false;

  DatabaseService databaseService = DatabaseService();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    // Assign controllers here after initializing the text fields
    usernameController = TextEditingController();
    emailController = TextEditingController();
    bioController = TextEditingController();
  }

  void fetchUserDetails() async {
    Map<String, dynamic>? userDetails =
        await databaseService.getUserDetails(USERID);
    print(USERID);
    if (userDetails != null) {
      setState(() {
        userData = userDetails;
        // Set text fields only if user details are available
        usernameController.text = userData!['username'] ?? '';
        emailController.text = userData!['email'] ?? '';
        bioController.text = userData!['bio'] ?? '';
      });
    } else {
      // Handle case where user details could not be retrieved
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviseWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 90,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                          );

                          if (pickedFile != null) {
                            setState(() {
                              _imageFile = File(pickedFile.path);
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : NetworkImage(
                                      userData?['profilePictureURL'] ?? '')
                                  as ImageProvider,
                        ),
                      ),
                      SizedBox(height: deviseWidth * .02),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: deviseWidth * .90,
                            height: deviseWidth * .14,
                            decoration: BoxDecoration(
                              color: Color(0xffE8E8E8),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Center(
                                child: TextField(
                                  enabled: true, // Enable user input
                                  onChanged: (String? text) {
                                    setState(() {
                                      // Add your validation logic if needed
                                    });
                                  },
                                  controller: usernameController,
                                  style:
                                      TextStyle(fontSize: deviseWidth * .040),
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Username',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: deviseWidth * .02),
                          Container(
                            width: deviseWidth * .90,
                            height: deviseWidth * .14,
                            decoration: BoxDecoration(
                              color: Color(0xffE8E8E8),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Center(
                                child: TextField(
                                  enabled: true, // Enable user input
                                  onChanged: (String? text) {
                                    setState(() {
                                      // Add your validation logic if needed
                                    });
                                  },
                                  controller: emailController,
                                  style:
                                      TextStyle(fontSize: deviseWidth * .040),
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Email',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: deviseWidth * .02),
                          Container(
                            width: deviseWidth * .90,
                            height: deviseWidth * .14,
                            decoration: BoxDecoration(
                              color: Color(0xffE8E8E8),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Center(
                                child: TextField(
                                  enabled: true, // Enable user input
                                  onChanged: (String? text) {
                                    setState(() {
                                      // Add your validation logic if needed
                                    });
                                  },
                                  controller: bioController,
                                  style:
                                      TextStyle(fontSize: deviseWidth * .040),
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Bio',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: deviseWidth * .04),
                          GestureDetector(
                            onTap: () async {
                              if (_isStoring)
                                return; // Prevent multiple taps while storing
                              setState(() {
                                _isStoring = true; // Set storing flag to true
                              });

                              // Update user details in the database
                              await databaseService.updateUserDetails(
                                USERID,
                                usernameController.text,
                                emailController.text,
                                bioController.text,
                                _imageFile,
                              );
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context)=>ProfileTab()));
                              setState(() {
                                _isStoring = false; // Reset storing flag
                              });
                            },
                            child: Container(
                              width: deviseWidth * .90,
                              height: deviseWidth * .14,
                              decoration: BoxDecoration(
                                color: Color(buttonColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Center(
                                child: _isStoring
                                    ? CircularProgressIndicator()
                                    : Text(
                                        'Save Profile',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: deviseWidth * .040,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
