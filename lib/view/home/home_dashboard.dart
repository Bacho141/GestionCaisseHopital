import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:migo/controller/servicemedical_controller.dart';
import 'package:migo/layout/layout.dart';
import 'package:migo/widgets/dashboard_row.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<DashboardPage> {
  final ServiceController productController = Get.put(ServiceController());

  @override
  void initState() {
    super.initState();
    // productController.fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {

    return AppLayout(
      activeTab: 0,
      pageName: "Tableau de Bord",
      content: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 8.0, top: 20),
        primary: false,
        child: Column(
          children: [
            // top row
            Center( // Centrage horizontal
              child:const CTARow()
            ),
          ],
        ),
      ),
    );
  }
}
