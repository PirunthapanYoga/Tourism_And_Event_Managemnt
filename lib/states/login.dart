import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smarttourism/states/location_view.dart';
import 'package:smarttourism/states/sign_up.dart';

class LogIn extends StatefulWidget {

  @override
  _LogInState createState() => _LogInState();

}

class _LogInState extends State<LogIn> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _notificationController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isRememberMe = false;

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
        .authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(
        credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      return '$user';
    }
    return null;
  }

  void _login(BuildContext context) async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text
      )).user;
      if (user != null) {
        if (!user.emailVerified) {
          await user.sendEmailVerification();
          _notificationController.text = 'Please verify your email';
        } else {
          goHome();
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _notificationController.text = 'Wrong Credentials';
      } else if (e.code == 'wrong-password') {
        _notificationController.text = 'Wrong Credentials';
      }
    }
  }

  void goHome() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LocationView()
        )
    );
  }

  Widget googleSignInButton() {
    return OutlineButton(
      color: Colors.white10,
      splashColor: Colors.white,
      onPressed: () {
        signInWithGoogle().then((result) {
          goHome();
        });
      },

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.white70, width: 2),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("lib/assets/google_logo.png"),
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .06),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildEmail(){
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Email',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: MediaQuery
              .of(context)
              .size
              .height * .01),
          Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white10,
                        blurRadius: 500,
                        offset: Offset(0,5)
                    )
                  ]
              ),
              height: MediaQuery
                  .of(context)
                  .size
                  .height * .07,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    color: Colors.black
                ),
                validator: (String value){
                  if(value.isEmpty){
                    return 'Email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top:14),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color(0xFF18FFFF),
                    )
                ),

              )
          )
        ]
    );
  }

  Widget buildPassword(){
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Password',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: MediaQuery
              .of(context)
              .size
              .height * .01),
          Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white10,
                        blurRadius: 6,
                        offset: Offset(0,2)
                    )
                  ]
              ),
              height: MediaQuery
                  .of(context)
                  .size
                  .height * .07,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(
                    color: Colors.black54
                ),
                validator: (String value){
                  if(value.isEmpty){
                    return 'Email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top:14),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Color(0xFF18FFFF),
                    )
                ),
              )
          )
        ]
    );
  }

  Widget buildForgotPassBtn(){
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
          onPressed: () => () {},
          padding: EdgeInsets.only(right:0),
          child: Text(
            'Forgot Password?',
            style:TextStyle(
                color: Colors.white
            ),
          )
      ),
    );
  }

  Widget buildRememberCb() {
    return Container(
        height: MediaQuery
            .of(context)
            .size
            .height * .04,
        child: Row(
          children: <Widget>[
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(

                value: isRememberMe,
                checkColor: Colors.black,
                activeColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    isRememberMe = value;
                  });
                },
              ),
            ),
            Text(
              'Remember me',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            )
          ],
        )
    );
  }

  Widget buildLoginBtn(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25),
        width: double.infinity,
        child: FlatButton(
          minWidth: MediaQuery
              .of(context)
              .size
              .width * .20,
          onPressed: () async {
            _login(context);
          },
          padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          color: Colors.white10,
          child: Text(
            'Log In',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "Times New Roman"
            ),
          ),
        )
    );
  }

  Widget buildSignUpBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  SignUp(),)
        )
      },
      child: RichText(
          text: TextSpan(
              children: [
                TextSpan(
                    text: 'Don\'t have an Account?   ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontFamily: "Times new Roman"
                    )
                ),

                TextSpan(
                    text: 'Sign Up',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times new Roman"
                    )
                )
              ]
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Text(
          'Smart Tourism',
          style: TextStyle(
              fontFamily: "Times New Roman",
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xDD6200EA),
      ),
      key: _formKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                    alignment: Alignment.centerRight,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
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
                          ]
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * .04,
                          ),
                          buildEmail(),
                          SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * .03,
                          ),
                          buildPassword(),
                          Row(
                            children: <Widget>[
                              buildRememberCb(),
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * .32,
                              ),
                              buildForgotPassBtn(),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * .60,
                            child: TextFormField(
                              decoration: InputDecoration(border: InputBorder
                                  .none),
                              readOnly: true,
                              controller: _notificationController,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .60,
                              child: buildLoginBtn(context)
                          ),
                          Text(
                            'or',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * .04,
                          ),
                          googleSignInButton(),
                          SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * .04,
                          ),
                          buildSignUpBtn(context)
                        ],
                      ),
                    )
                )
              ],
            ),
          )),
    );
  }

}
