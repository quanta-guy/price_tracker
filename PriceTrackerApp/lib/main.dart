import 'dart:convert';
import 'package:price_tracker/components/email_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:price_tracker/services/google_signin_provider.dart';
import 'package:provider/provider.dart';
import 'components/search_items.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:price_tracker/components/saved_list.dart';
import 'services/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'widgets/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing Firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  _getSetFCM(); // Initialize Firebase Cloud Messaging

  runApp(const MyApp());
}

// Main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'Price Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Price Tracker'), // Setting home page
        debugShowCheckedModeBanner: false,
      ));
}

// Home page widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final searchKey = TextEditingController();
  bool _isLoading = false; // Loading state indicator

  @override
  void dispose() {
    searchKey.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic x, y, searchItems = [];

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoginPage(); // Redirect to login page if not authenticated
          } else if (snapshot.hasData) {
            _showForeground(); // Show foreground notifications
          }

          return Scaffold(
            backgroundColor: Colors.white,
            drawer: NavigationDrawer(children: [
              // Drawer navigation items
              ListTile(
                  trailing: const Icon(Icons.favorite),
                  iconColor: Colors.redAccent,
                  title: const Text(
                    "Saved List",
                    style: TextStyle(
                      fontFamily: "Schyler",
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  onTap: () async {
                    // Handling saved list navigation
                    List pdtName = [];
                    List currentPrice = [];
                    List imgData = [];
                    myDialog(context);
                    dynamic data = await getFirestoreData();

                    for (var i = 0; i < data['pdt_link'].length; i++) {
                      var k = data['pdt_link'][i];
                      x = await savedListData(k);
                      x = jsonDecode(x.body);
                      pdtName.add(x['pdt_name']);
                      currentPrice.add(x['price']);
                      imgData.add(x['img_link']);
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SavedList(
                                    currentPrice: currentPrice,
                                    imgData: imgData,
                                    savedItems: pdtName,
                                    expAmt: data['exp_amt'],
                                  )));
                    }
                  }),
              ListTile(
                trailing: const Icon(Icons.logout),
                iconColor: const Color.fromARGB(255, 89, 88, 88),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    fontFamily: "Schyler",
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                contentPadding: const EdgeInsets.all(8.0),
                onTap: () async {
                  await FirebaseAuth.instance.signOut(); // Logging out user
                },
              )
            ]),
            appBar: AppBar(
              title: Text(
                widget.title,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
            ),
            body: SizedBox(
              height: height,
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator() // Loading indicator
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: (width / 2) - 175, bottom: 12.0),
                              child: const Text(
                                "Product Name",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: "Schyler",
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                height: 75,
                                width: 350,
                                child: TextField(
                                  controller: searchKey,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    hintText: "Enter the product name",
                                    iconColor: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                                child: SizedBox(
                              height: 50,
                              width: 120,
                              child: ElevatedButton.icon(
                                  label: const Text("Search"),
                                  onPressed: () async => {
                                        y = searchKey.text,
                                        setState(() {
                                          _isLoading = true;
                                        }),
                                        x = await http.get(Uri.parse(
                                            "http://127.0.0.1:5000/search?link=https://www.flipkart.com/search?q=$y")),
                                        searchItems = jsonDecode(x.body),
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ListBuilder(
                                                        searchItems:
                                                            searchItems[
                                                                'products'],
                                                        imgData: searchItems[
                                                            'img_data'],
                                                        productLink:
                                                            searchItems[
                                                                'pdt_link'],
                                                        productPrice:
                                                            searchItems[
                                                                'price_lst'])),
                                          ),
                                        },
                                        setState(() {
                                          _isLoading = false;
                                          searchKey.clear();
                                        }),
                                      },
                                  icon: const Icon(Icons.search)),
                            ))
                          ]),
              ),
            ),
          );
        });
  }

  // Display foreground notifications
  _showForeground() {
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification == null) return;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text((event.notification?.title).toString()),
              content: Text((event.notification?.body).toString()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("ok")),
              ],
            );
          });
    });
  }
}

// Fetch saved list data from the backend
Future savedListData(String link) async {
  Uri url = Uri.parse("http://127.0.0.1:5000/q?link=$link");
  var x = await http.get(url);
  return x;
}

// Fetch user data from Firestore
Future getFirestoreData() async {
  final dbref = FirebaseFirestore.instance
      .collection('SavedLists')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  var x = await dbref.get();

  return x;
}

// Initialize Firebase Cloud Messaging token
_getSetFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: false,
      carPlay: false,
      criticalAlert: false,
      sound: true);
  const vapidKey = "vapid-key";
  var token = await messaging.getToken(vapidKey: vapidKey);
  var userid = FirebaseAuth.instance.currentUser?.uid;
  if (await docSearch(userid)) {
    FirebaseFirestore.instance
        .collection('SavedLists')
        .doc(userid)
        .update({'token': token});
  } else {
    FirebaseFirestore.instance.collection('SavedLists').doc(userid).set({
      'exp_amt': [''],
      'pdt_link': [''],
      'pdt_name': [''],
      'token': token
    });
  }
}

// Check if document exists in Firestore
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
