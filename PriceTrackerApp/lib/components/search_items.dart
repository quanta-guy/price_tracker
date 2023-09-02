// Importing required package
import 'package:flutter/material.dart';
import '../components/price_input.dart';

class ListBuilder extends StatefulWidget {
  List searchItems, imgData, productLink, productPrice;

  ListBuilder(
      {super.key,
      required this.searchItems,
      required this.imgData,
      required this.productLink,
      required this.productPrice});

  @override
  State<ListBuilder> createState() => ListBuilderState(
        searchItems: searchItems,
        imgData: imgData,
        productLink: productLink,
        productPrice: productPrice,
      );
}

class ListBuilderState extends State<ListBuilder> {
  List searchItems, imgData, productLink, productPrice;
  String price = "0.00";
  int selectedIndex = -1;

  ListBuilderState(
      {required this.searchItems,
      required this.imgData,
      required this.productLink,
      required this.productPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Items"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.next_plan_outlined,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () async {
              if (selectedIndex == -1) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Please select an item'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PriceInput(
                      pdtName: searchItems[selectedIndex],
                      productImg: imgData[selectedIndex],
                      price: productPrice[selectedIndex],
                      pdtLink: productLink[selectedIndex],
                    ),
                  ),
                );
              }
              // do something
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: searchItems.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text(
              searchItems[index].toString(), // Display the search item name
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
            tileColor: selectedIndex == index ? Colors.blue : null,

            // Set the onTap function to update the selected index
            onTap: () {
              setState(() {
                if (selectedIndex != index) {
                  selectedIndex = index;
                } else {
                  selectedIndex = -1;
                }
              });
            },
          );
        },
      ),
    );
  }
}
