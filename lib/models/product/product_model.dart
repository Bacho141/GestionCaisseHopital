class Product {
  final String designation;
  final double unitPrice;
  final int quantity;
  final double amount;

  Product({
    required this.designation,
    required this.unitPrice,
    required this.quantity,
    required this.amount,
  });

  /// Crée une instance depuis une Map (ex. SQLite ou JSON)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      designation: map['designation'] as String,
      unitPrice: (map['unitPrice'] as num).toDouble(),
      quantity: map['quantity'] as int,
      amount: (map['amount'] as num).toDouble(),
    );
  }

    /// Convertit en Map pour stockage local ou sérialisation
  Map<String, dynamic> toMap() {
    return {
      'designation': designation,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'amount': amount,
    };
  }
}