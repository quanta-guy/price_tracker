import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FinalPage extends StatefulWidget {
  bool islow = false;

  FinalPage({super.key, required this.islow});

  @override
  State<FinalPage> createState() => FinalPageState();
}

class FinalPageState extends State<FinalPage> {
  @override
  Widget build(BuildContext context) {
    // Get the height of the device screen
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display an animated loader image
              Center(
                child: SizedBox(
                    height: 150,
                    width: 350,
                    child: Image.asset('assets/Images/loader.gif')),
              ),
              // Display a message based on the value of islow
              !widget.islow
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Center(
                        child: SizedBox(
                            height: 75,
                            width: 350,
                            child: Text(
                              // Message when the price is lower than expected
                              "Hurray! the price is already lower than you expected ;)",
                              style: TextStyle(
                                  fontFamily: 'Schyler', fontSize: 20),
                            )),
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                      child: Center(
                        child: SizedBox(
                            height: 75,
                            width: 350,
                            child: Text(
                              // Message when the price is higher than expected
                              "You will be notified ;)",
                              style: TextStyle(
                                  fontFamily: 'Schyler', fontSize: 20),
                            )),
                      ),
                    ),
              // Button to navigate back to the home screen
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                        child: const Text("Home"),
                        onPressed: () {
                          // Navigate back to the home screen
                          Navigator.popUntil(
                              context, (Route<dynamic> route) => route.isFirst);
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to get the UID of the currently logged-in user
Future getCurrentUser() async {
  final FirebaseAuth firebaseUserdata = FirebaseAuth.instance;
  final User? user = firebaseUserdata.currentUser;
  final uid = user!.uid;
  return uid;
}
