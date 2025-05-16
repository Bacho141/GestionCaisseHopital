import 'package:flutter/material.dart';
import 'package:migo/view/products/saleshistory/sales_history.dart';
import 'package:migo/view/products/productpage.dart';
import 'package:migo/view/agents/agents.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/widgets/dashboard_page_cta_cards.dart';
import 'package:migo/view/receipt/create_receipt.dart';

class CTARow extends StatelessWidget {
  const CTARow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = Responsive.isMobile(context) ? 2 : 4; // 2 colonnes sur mobile, 4 sur desktop

    return SizedBox(
      width: MediaQuery.of(context).size.width - 90,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: crossAxisCount, // Nombre de colonnes selon le type d'écran
        crossAxisSpacing: 8, // Espacement horizontal
        mainAxisSpacing: 8, // Espacement vertical
        children: [
          BoxCTACard(
            toPage: CreateReceipt(),
            caption: "Créer un reçu",
            image: "assets/create_bill_ill.png",
            cardColor: const Color(0xffB9B7FF),
          ),
          const BoxCTACard(
            toPage: SalesHistory(),
            caption: "Historiques",
            image: "assets/view_sales_history.png",
            cardColor: Color(0xffBEE4FF),
          ),
          const BoxCTACard(
            toPage: ProductsPage(),
            caption: "Order a Product",
            image: "assets/order_a_product.png",
            cardColor: Color(0xffBEE4FF),
          ),
          const BoxCTACard(
            toPage: Agents(),
            caption: "Agents",
            image: "assets/order_a_product.png",
            cardColor: Color(0xffBEE4FF),
          ),
        ],
      ),
    );
  }
}
