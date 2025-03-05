class BillModel {
  final String customerName;
  final String address;
  final String phoneNumber;
  final List<BillItem> items;
  final double totalAmount;
  final String paymentMethod;
  final DateTime billDate;

  BillModel({
    required this.customerName,
    required this.address,
    required this.phoneNumber,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.billDate,
  });

  Map<String, dynamic> toJson() => {
    'customerName': customerName,
    'address': address,
    'phoneNumber': phoneNumber,
    'items': items.map((item) => item.toJson()).toList(),
    'totalAmount': totalAmount,
    'paymentMethod': paymentMethod,
    'billDate': billDate.toIso8601String(),
  };
}

class BillItem {
  final String itemName;
  final int quantity;
  final double price;
  final double total;

  BillItem({
    required this.itemName,
    required this.quantity,
    required this.price,
  }) : total = quantity * price;

  Map<String, dynamic> toJson() => {
    'itemName': itemName,
    'quantity': quantity,
    'price': price,
    'total': total,
  };
}