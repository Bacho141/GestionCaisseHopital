
class ReceiptItem {
  final String? productId;
  final String label;
  final double tarif;
  final int quantity;
  final double amount;

  ReceiptItem({
    required this.productId,
    required this.label,
    required this.tarif,
    required this.quantity,
    required this.amount,
  });

  factory ReceiptItem.fromMap(Map<String, dynamic> m) => ReceiptItem(
        productId: m['_id'] as String?,
        label:     m['label']     as String,
        tarif:     (m['tarif']    as num).toDouble(),
        quantity:  m['quantity']  as int,
        amount:    (m['amount']   as num).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'label':     label,
        'tarif':     tarif,
        'quantity':  quantity,
        'amount':    amount,
      };
}
