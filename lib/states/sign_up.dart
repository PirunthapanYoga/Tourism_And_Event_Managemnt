import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final String noImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/smarttourism-20178273.appspot.com/o/noImage.png?alt=media&token=d0c02cf1-3a51-4114-ab69-b1236552862f";

  FirebaseStorage storage = FirebaseStorage.instance;

  FirebaseFirestore firebase = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _rePasswordController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _notificationController = TextEditingController();

  var info;

  File image;

  Widget buildFirstName() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'First Name',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "Times New Roman",
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1),
          Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white30,
                        blurRadius: 2,
                        offset: Offset(0, 2)),
                  ]),
              height: 50,
              child: TextFormField(
                controller: _firstNameController,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.blueGrey),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: Color(0xFF18FFFF),
                    )),
              ))
        ]);
  }

  Widget buildLastName() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Last Name',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "Times New Roman",
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1),
          Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white30,
                        blurRadius: 2,
                        offset: Offset(0, 2)),
                  ]),
              height: 50,
              child: TextFormField(
                controller: _lastNameController,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.blueGrey),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: Color(0xFF18FFFF),
                    )),
              ))
        ]);
  }

  Widget buildEmail() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Email',
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Times New Roman",
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1),
          Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white30,
                        blurRadius: 2,
                        offset: Offset(0, 2)),
                  ]),
              height: 50,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.blueGrey),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color(0xFF18FFFF),
                    )),
              ))
        ]);
  }

  Widget buildPhoneNumberName() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Phone Number',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "Times New Roman",
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1),
          Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white30,
                        blurRadius: 2,
                        offset: Offset(0, 2)),
                  ]),
              height: 50,
              child: TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.blueGrey),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Color(0xFF18FFFF),
                    )),
              ))
        ]);
  }

  Widget buildPassword() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Password',
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Times New Roman",
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1),
          Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white30,
                        blurRadius: 2,
                        offset: Offset(0, 2)),
                  ]),
              height: 50,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.black54),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Color(0xFF18FFFF),
                    )),
              ))
        ]);
  }

  Widget buildRePassword() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Re-Enter Password',
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Times New Roman",
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1),
          Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white30,
                        blurRadius: 2,
                        offset: Offset(0, 2)),
                  ]),
              height: 50,
              child: TextFormField(
                onChanged: (text) {
                  passMatch(text);
                },
                controller: _rePasswordController,
                obscureText: true,
                style: TextStyle(color: Colors.black54),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Color(0xFF18FFFF),
                    )),
              )),
        ]);
  }

  Widget buildSignUpBtn(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: FlatButton(
          minWidth: 200,
          height: 50,
          onPressed: () {
            checkNumber();
          },
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.white24,
          child: Text(
            'Sign  Up',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "Times New Roman"),
          ),
        ));
  }

  Widget popup() {
    return AlertDialog(
      title: const Text("Please Verfy Email"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"))
      ],
    );
  }

  Widget showImg() {
    var val = MediaQuery
        .of(context)
        .size
        .width;
    if (image != null) {
      return Image.file(image);
    }
    return Container(
      padding: EdgeInsets.only(
          top: val * .1, left: val * .1, right: val * .1, bottom: val * .1),
      color: Colors.white60,
      child: Column(
        children: [
          Container(
              height: 150,
              width: 150,
              child: IconButton(
                icon: Icon(
                  Icons.file_upload,
                  size: 120,
                  color: Colors.black,
                ),
                onPressed: () {},
              )
          ),
          Text(
            "Upload Profile Image",
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Times New Roman",
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Widget _uploadImageWindow(BuildContext context) {
    return new AlertDialog(
      title: const Text('Choose from '),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            _imgFromGallery();
            Navigator.of(context).pop();
          },
          textColor: Theme
              .of(context)
              .primaryColor,
          child: const Text('Gallary'),
        ),
        new FlatButton(
          onPressed: () {
            _imgFromCamera();
            Navigator.of(context).pop();
          },
          textColor: Theme
              .of(context)
              .primaryColor,
          child: const Text('Camera'),
        ),
      ],
    );
  }

  Future<void> checkNumber() async{
    if(_phoneNumberController.text.length!=10){
     info="Enter a valid Contact Number";
    }else{
      signUp();
    }
    _notificationController.text = info;
  }

  void passMatch(String pass) {
    if (pass != _passwordController.text) {
      _notificationController.text = 'Pleae make sure your password match';
    } else if (_passwordController.text == '') {
      _notificationController.text = '';
    } else {
      _notificationController.text = '';
    }
  }

  Future<void> uploadWithImg(email) async {
    CollectionReference user = firebase.collection('Users');
    String downloadURL = await FirebaseStorage.instance
        .ref('UserImages/$email.jpg')
        .getDownloadURL();
    user.doc(email).update({
      'ImgUrl': downloadURL,
    }).then((value) {
      _notificationController.text = "Image Added";
      verifyEmail();
    }).catchError((error) =>
    _notificationController.text = "Failed to add Image: $error");
  }

  Future<void> verifyEmail() async {
    User user = auth.currentUser;
    if (!user.emailVerified) {
      await user.sendEmailVerification().then((value) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => popup()));
      });
    }
  }

  Future<void> _imgFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
  }

  Future<void> _imgFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );

    setState(() {
      image = File(pickedFile.path);
    });
  }

  Future uploadPic(email) async {
    CollectionReference user = firebase.collection('Users');
    _notificationController.clear();

    if (image != null) {
      Reference ref = storage.ref().child('UserImages/$email.jpg');
      UploadTask uploadTask = ref.putFile(image);
      uploadTask.then((res) {
        uploadWithImg(email);
      });
      uploadTask.catchError((error) {
        _notificationController.text = 'Unable to Upload Image $error';
      });
    } else {
      user
          .doc(email)
          .update({
        'ImgUrl': noImageUrl,
      })
          .then((value) => _notificationController.text = "Image Added")
          .catchError((error) =>
      _notificationController.text = "Failed to add Image: $error");
      Navigator.pop(context);
    }
  }

  //sign Up call
  Future<void> signUp() async {
    _notificationController.clear();
    var firstName = _firstNameController.text;
    var lastName = _lastNameController.text;
    var email = _emailController.text.toLowerCase();
    var password = _passwordController.text;
    var phoneNumber = _phoneNumberController.text;
    var uid = '';
    String info = '';
    CollectionReference user = firebase.collection('Users');

    if (firstName != '' &&
        lastName != '' &&
        email != '' &&
        password != '' &&
        phoneNumber != '') {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        uid = value.user.uid;
        user.doc(email).set({
          'First Name': firstName,
          'Last Name': lastName,
          'Email': email,
          'User ID': uid,
          'Contact Number': phoneNumber,
        }).then((value) {
          uploadPic(email);
        }).catchError((error) => info = error.toString());
      }).catchError((error) => info = error.toString().split("]")[1]);
    } else {
      info = '* Fill required fields';
    }
    _notificationController.text = info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Smart Tourism",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Times New Roman",
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        backgroundColor: Color(0xDD6200EA),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xDD6200EA),
                  Color(0xAA6200EA),
                  Color(0x996200EA),
                  Color(0x886200EA),
                  Color(0x776200EA),
                  Color(0x666200EA),
                  Color(0x666200EA),
                ]),
          ),
          child: ListView(
            children: <Widget>[
              Row(children: <Widget>[
                Text(
                  'New User Registration',
                  style: TextStyle(
                      fontFamily: "Times New Roman",
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 50,
                )
              ]),
              SizedBox(
                height: 20,
              ),
              buildFirstName(),
              SizedBox(
                height: 20,
              ),
              buildLastName(),
              SizedBox(
                height: 20,
              ),
              buildEmail(),
              SizedBox(
                height: 20,
              ),
              buildPassword(),
              SizedBox(
                height: 20,
              ),
              buildRePassword(),
              SizedBox(
                height: 20,
              ),
              buildPhoneNumberName(),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _uploadImageWindow(context),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  height: MediaQuery
                      .of(context)
                      .size
                      .width * .8,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * .8,
                  child: showImg(),
                ),
              ),
              TextField(
                enabled: false,
                controller: _notificationController,
                style: TextStyle(color: Colors.red),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
              SizedBox(width: 200, height: 40, child: buildSignUpBtn(context)),
              SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }
}
