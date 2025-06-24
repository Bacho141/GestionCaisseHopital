import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:migo/controller/auth_controller.dart';
import 'package:migo/view/servicemedical/saleshistory/sales_history.dart';
import 'package:migo/view/servicemedical/servicemedical_page.dart';
import 'package:migo/view/agents/agents.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/widgets/dashboard_page_cta_cards.dart';
import 'package:migo/view/receipt/create_receipt.dart';

class CTARow extends StatelessWidget {
  const CTARow({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    // Détermine le nombre de colonnes selon le type d'écran
    int crossAxisCount = Responsive.isMobile(context) ? 2 : 4;

    // Récupère l'AuthController pour lire userRole
    final authCtrl = Get.find<AuthController>();
    print('Role dans build de CTARow : ${authCtrl.userRole.value}');

    return Obx(() {
      // Si l'utilisateur n'est pas admin, on n'inclut pas la case "Agents"
      final isAdmin = authCtrl.userRole.value == 'Admin';
      

      // Liste de cartes communes à tous
      final commonCards = <Widget>[
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
      ];

      // Ajoute la carte "Agents" uniquement si l'utilisateur est admin
      if (isAdmin) {
        commonCards.add(
          const BoxCTACard(
            toPage: Agents(),
            caption: "Agents",
            image: "assets/order_a_product.png",
            cardColor: Color(0xffBEE4FF),
          ),
        );
      }

      return SizedBox(
        width: MediaQuery.of(context).size.width - 90,
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: commonCards,
        ),
      );
    });
  }

}
