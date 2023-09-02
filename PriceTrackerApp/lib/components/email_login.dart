import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:price_tracker/services/google_signin_provider.dart'; // Import GoogleSignInProvider
import 'package:price_tracker/widgets/widgets.dart'; // Import custom widgets
import 'package:provider/provider.dart'; // Import Provider package for state management

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // Get device width
    var width = MediaQuery.of(context).size.width;

    // Create controllers for email and password input fields
    final emailid = TextEditingController();
    final password = TextEditingController();

    // Function to handle login process
    void login() async {
      try {
        myDialog(context); // Show loading dialog
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailid.text, password: password.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == ('user-not-found') || e.code == ('NOT FOUND')) {
          error(password.text, false, emailid.text, false);
        } else if (e.code == 'wrong-password') {
          error(password.text, false, emailid.text, true);
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Price Tracker",
          style:
              TextStyle(fontFamily: "Itim", fontSize: 40, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading "Login in"
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              "Login in",
              style: TextStyle(
                  fontFamily: "Itim", fontSize: 50, color: Colors.black),
            ),
          ),
          // Subheading "Please login to continue"
          const Padding(
            padding: EdgeInsets.only(bottom: 50.0, left: 20.0),
            child: Text(
              "Please login to continue",
              style: TextStyle(
                  fontFamily: "Itim", fontSize: 15, color: Colors.grey),
            ),
          ),
          // Email input field
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: SizedBox(
                width: 250,
                child: TextFormField(
                  onEditingComplete: () {},
                  controller: emailid,
                  autocorrect: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(210, 165, 231, 0.41),
                    prefixIcon: const Icon(
                      Icons.person_sharp,
                      color: Colors.grey,
                      size: 20.0,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 50.0),
                    hintText: 'Username',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
              ),
            ),
          ),
          // Password input field
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: SizedBox(
                width: 250,
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) {
                    login();
                  },
                  controller: password,
                  obscureText: true,
                  autocorrect: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(210, 165, 231, 0.41),
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: Color.fromARGB(255, 36, 33, 33),
                      size: 20.0,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 50.0),
                    hintText: 'Password',
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
              ),
            ),
          ),
          // Sign-in button
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                height: 50,
                width: 250,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailid.text, password: password.text);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == ('user-not-found') ||
                          e.code == ('NOT FOUND')) {
                        error(password.text, false, emailid.text, false);
                      } else if (e.code == 'wrong-password') {
                        error(password.text, false, emailid.text, true);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    backgroundColor: const Color.fromRGBO(165, 167, 205, 1),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Sign In/Signup",
                    style: TextStyle(
                        fontFamily: "Itim",
                        fontSize: 30,
                        color: Color.fromARGB(127, 0, 0, 0)),
                  ),
                ),
              ),
            ),
          ),
          // Divider
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: (width / 2) - 18,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color.fromARGB(127, 0, 0, 0))),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Center(
                  child: Text("OR",
                      style: TextStyle(
                          fontFamily: "Itim",
                          fontSize: 15,
                          color: Color.fromARGB(255, 0, 0, 0))),
                ),
              ),
              Container(
                width: (width / 2) - 18,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color.fromARGB(127, 0, 0, 0))),
              ),
            ],
          ),
          // Google sign-in button
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
                child: GestureDetector(
              onTap: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleSignin();
              },
              child: SizedBox(
                  height: 70.0,
                  width: 90.0,
                  child: Image.asset(
                    "assets/Images/google.png",
                    alignment: Alignment.center,
                    fit: BoxFit.fill,
                  )),
            )),
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  // Function to display error dialog
  error(String? password, bool? iserror, String? email, bool pwdError) {
    final repassword = TextEditingController();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: pwdError ? const Text("Error") : const Text('REGISTRATION'),
        content: pwdError
            ? const Text("Check the entered Password")
            : const Text('Re-enter the password'),
        actions: pwdError
            ? <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ok'),
                ),
              ]
            : <Widget>[
                TextFormField(
                  controller: repassword,
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: iserror ?? false
                        ? Colors.red
                        : const Color.fromRGBO(210, 165, 231, 0.41),
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: Color.fromARGB(255, 36, 33, 33),
                      size: 20.0,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 50.0),
                    hintText: 'Password',
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (password != repassword.text) {
                      Navigator.pop(context);
                      error(password, true, email, false);
                    } else {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email ?? "admin",
                              password: password ?? "root");
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text('ok'),
                ),
              ],
      ),
    );
  }
}
