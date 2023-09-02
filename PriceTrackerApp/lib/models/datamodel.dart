class Data {
  String? pdtLink; // Product link
  String? expAmt; // Expected amount

  // Constructor to initialize pdtLink and expAmt
  Data({this.pdtLink, this.expAmt});

  // Constructor to create a Data object from a map
  Data.fromMap(Map<String, dynamic> data) {
    pdtLink = data["pdtLink"];
    expAmt = data["expAmt"];
  }

  // Convert the current Data object to a map
  Map<String, dynamic> toMap() {
    return {
      "pdtLink": pdtLink,
      "expAmt": expAmt,
    };
  }
}
