import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Database/DatabaseService.dart';
import 'package:instagram/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String dropdownValue = 'English';
  File? _imageFile;
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  int buttonColor = 0xff26A9FF;

  bool inputTextNotNull = false;
   bool _isStoring = false;

  DatabaseService databaseService = DatabaseService();
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white70,
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 10,
                    style: TextStyle(color: Colors.black54),
                    underline: Container(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['English', 'Arabic', 'Italian', 'French']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Image.asset(
                  'assets/Instagram_logo..png',
                  height: deviseWidth * .20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);

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
                              : AssetImage('assets/default_profile.jpg')
                                  as ImageProvider,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Select Profile Picture',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: deviseWidth * .90,
                      height: deviseWidth * .14,
                      decoration: BoxDecoration(
                        color: Color(0xffE8E8E8),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                          child: TextField(
                            onChanged: (String? text) {
                              setState(() {
                                // Add your validation logic if needed
                              });
                            },
                            controller: emailController,
                            style: TextStyle(fontSize: deviseWidth * .040),
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
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                          child: TextField(
                            onChanged: (String? text) {
                              setState(() {
                                // Add your validation logic if needed
                              });
                            },
                            controller: usernameController,
                            style: TextStyle(fontSize: deviseWidth * .040),
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
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                          child: TextField(
                            onChanged: (String? text) {
                              setState(() {
                                // Add your validation logic if needed
                              });
                            },
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(fontSize: deviseWidth * .040),
                            decoration: InputDecoration.collapsed(
                              hintText: 'Password',
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
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                          child: TextField(
                            onChanged: (String? text) {
                              setState(() {
                                // Add your validation logic if needed
                              });
                            },
                            controller: confirmPasswordController,
                            obscureText: true,
                            style: TextStyle(fontSize: deviseWidth * .040),
                            decoration: InputDecoration.collapsed(
                              hintText: 'Confirm Password',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: deviseWidth * .04),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _isStoring = true; // Start storing process
                        });

                        databaseService.storeUserDetails(
                            usernameController.text,
                            emailController.text,
                            passwordController.text,
                            _imageFile!);

                        if(_isStoring==true){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                       }
                        setState(() {
                          _isStoring = false; // Storing process complete
                        });
                      },
                      child: Container(
                        width: deviseWidth * .90,
                        height: deviseWidth * .14,
                        decoration: BoxDecoration(
                          color: Color(buttonColor),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                          child: _isStoring
                              ? CircularProgressIndicator() // Show progress indicator if storing process is in progress
                              : Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: deviseWidth * .040,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: deviseWidth * .035),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(fontSize: deviseWidth * .035),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    LoginPage())); // Navigate back to login page
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: deviseWidth * .035,
                              color: Color(0xff002588),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
