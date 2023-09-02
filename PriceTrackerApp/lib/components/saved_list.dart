// Importing required package

import 'package:flutter/material.dart';

// Stateful widget to display saved items
class SavedList extends StatefulWidget {
  // Properties to store saved items data
  List savedItems, currentPrice, imgData, expAmt;

  SavedList({
    super.key,
    required this.savedItems,
    required this.currentPrice,
    required this.imgData,
    required this.expAmt,
  });

  @override
  State<SavedList> createState() => SavedListState(
        savedItems: savedItems,
        currentPrice: currentPrice,
        imgData: imgData,
        expAmt: expAmt,
      );
}

class SavedListState extends State<SavedList> {
  int selectedIndex = -1; // Selected index for highlighting

  // Properties to store saved items data
  List savedItems, currentPrice, imgData, expAmt;

  SavedListState({
    required this.savedItems,
    required this.currentPrice,
    required this.imgData,
    required this.expAmt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue),
      body: ListView.builder(
        itemCount: savedItems.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text(
              savedItems[index], // Display the saved item name
            ),
            leading: SizedBox(
              height: 75,
              width: 75,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/Images/Loading.gif',
                image: imgData[index], // Display the associated image
                fit: BoxFit.contain,
              ),
            ),
            // Add more UI elements here as needed

            // For example, if you want to display the current price
            subtitle: Text('Current Price: ₹${currentPrice[index]}'),

            // To display the expected amount
            trailing: Text('Expected Price: ₹${expAmt[index]}'),

            // Add onTap function to handle item selection
            onTap: () {
              setState(() {
                selectedIndex = index; // Update selected index
              });

              // You can add more logic here when an item is tapped
            },

            // Customize the appearance based on the selected index
            tileColor: selectedIndex == index ? Colors.grey : Colors.white,
          );
        },
      ),
    );
  }
}
