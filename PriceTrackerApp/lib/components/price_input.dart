// Importing required packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:price_tracker/components/final.dart';
import 'package:http/http.dart' as http;

// Stateful widget to input expected price
class PriceInput extends StatefulWidget {
  // Properties to store product information
  String productImg, price, pdtLink, pdtName;

  PriceInput({
    super.key,
    required this.productImg,
    required this.price,
    required this.pdtLink,
    required this.pdtName,
  });

  @override
  State<PriceInput> createState() => PriceInputState(
        productImg: productImg,
        price: price,
        pdtLink: pdtLink,
        pdtName: pdtName,
      );
}

class PriceInputState extends State<PriceInput> {
  // Properties to store product information
  String productImg, price, pdtLink, pdtName;
  final expectedPrice = TextEditingController();
  String currentPrice = "0.00";

  PriceInputState({
    required this.productImg,
    required this.price,
    required this.pdtLink,
    required this.pdtName,
  });

  @override
  void dispose() {
    expectedPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Build the user interface
    return Scaffold(
      appBar: AppBar(title: const Text("Results")),
      body: SizedBox(
        height: height,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    productImg,
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    height: 200,
                    width: 200.0,
                  ),
                ),
                // Display current price
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Current Price: ",
                        style: TextStyle(fontFamily: "Schyler", fontSize: 16.0),
                      ),
                      Text(
                        "₹ $price",
                        style: const TextStyle(
                            fontFamily: "Schyler", fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                // Input expected price
                Padding(
                  padding: EdgeInsets.only(
                      left: (width / 2) - 175, bottom: 12.0, top: 30),
                  child: const Text(
                    "Expected Price",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: "Schyler",
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    height: 100,
                    width: 350,
                    child: TextField(
                      controller: expectedPrice,
                      decoration: const InputDecoration(
                        labelText: "Expected Price",
                        border: OutlineInputBorder(),
                        hintText: "Enter the expected price",
                      ),
                    ),
                  ),
                ),
                // Submit button
                Padding(
                  padding: EdgeInsets.only(
                      left: (width / 2) + 100, bottom: 12.0, right: 12),
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (expectedPrice.text == '') {
                          // Show error dialog if expected price is not entered
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Please enter the amount'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Get FCM token
                          var token =
                              await FirebaseMessaging.instance.getToken();

                          // Update Firestore data and send notification
                          await getSetData(
                              pdtLink, expectedPrice.text, pdtName, token);

                          // Check if expected price is reached and send notification
                          if (int.parse(expectedPrice.text) <=
                              int.parse(price)) {
                            var x = await FirebaseFirestore.instance
                                .collection('SavedLists')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .get();
                            var token = x['token'];
                            notifier(pdtLink, expectedPrice.text, token);
                          }

                          // Navigate to final page
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FinalPage(
                                  islow: (int.parse(expectedPrice.text) <=
                                      int.parse(price)),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text("Submit"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to send notification
  void notifier(pdtLink, expAmt, token) {
    Uri url = Uri.parse(
        "https://flask-deployment-384613.ue.r.appspot.com/notify?link=$pdtLink&&ea=$expAmt&&token=$token");
    http.post(url);
  }

  // Function to update Firestore data
  Future getSetData(
      String pdtLink, String expAmt, String pdtName, String? token) async {
    if (await docSearch(FirebaseAuth.instance.currentUser?.uid)) {
      final dbref = FirebaseFirestore.instance
          .collection('SavedLists')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      var x = await dbref.get();
      var y = (x.data());
      var expAmtData = y?['exp_amt'];
      var prdLink = y?['pdt_link'];
      var prdName = y?['pdt_name'];
      if (!(prdName.contains(pdtName))) {
        prdLink[0] == "" || prdLink == []
            ? {
                prdLink[0] = pdtLink,
                expAmtData[0] = expAmt,
                prdName[0] = pdtName,
              }
            : {
                prdLink.add(pdtLink),
                expAmtData.add(expAmt),
                prdName.add(pdtName),
              };
      }
      var updateData = {
        "pdt_link": prdLink,
        "exp_amt": expAmtData,
        "pdt_name": prdName,
        'token': token,
      };
      dbref.set(updateData);
    } else {
      final dbref = FirebaseFirestore.instance
          .collection('SavedLists')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      var a = [], b = [], c = [];
      a.add(pdtLink);
      b.add(expAmt);
      c.add(pdtName);
      var updateData = {
        "pdt_link": a,
        "exp_amt": b,
        "pdt_name": c,
        'token': token,
      };
      dbref.set(updateData);
    }
  }

  // Function to check if document exists in Firestore
  Future<bool> docSearch(String? docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('SavedLists');

      var doc = await collectionRef.doc(docId).get();

      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }
}
