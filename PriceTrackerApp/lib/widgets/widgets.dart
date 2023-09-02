// Import necessary packages
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

// Function to show a custom loading dialog
Future<dynamic> myDialog(context) {
  return showDialog(
      // The user CANNOT close this dialog by pressing outside of it
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          // The background color
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The loading indicator
                CircularProgressIndicator(
                  color: Colors.blue.shade300,
                ),
                const SizedBox(height: 30),
                // Some text
                const Text(
                  'Loading...',
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
        );
      });
}

// Loader widget to display loading indicator with optional text
class Loader extends StatelessWidget {
  String text;

  Loader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return text != ""
        ? Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )
        : const CircularProgressIndicator(
            color: Colors.blue,
          );
  }
}

// Function to display an error dialog
errorDialog(context, content, title) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
      elevation: 5.0,
      surfaceTintColor: Colors.white,
      content: Text(content),
      title: Text(title),
      contentPadding: const EdgeInsets.all(10.0),
      actions: [
        IconButton(
          icon: const Icon(Icons.done),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    ),
  );
}
