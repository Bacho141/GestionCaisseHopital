import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:migo/controller/product_controller.dart';
import 'package:migo/layout/layout.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/widgets/product_page_cta_row.dart';
import 'package:migo/widgets/productcard.dart';
import 'package:migo/widgets/search_and_profile_section.dart';
/*

Une exception s'est produite.
FlutterError (setState() or markNeedsBuild() called during build.
This Obx widget cannot be marked as needing to build because the framework is already in the process of building widgets. A widget can be marked as needing to be built during the build phase only if one of its ancestors is currently building. This exception is allowed because the framework builds parent widgets before children, which means a dirty descendant will always be built. Otherwise, the framework might not visit this widget during this build phase.
The widget on which setState() or markNeedsBuild() was called was:
  Obx
The widget which was currently being built when the offending call was made was:
  Builder)

 */
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    productController.fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    
    return AppLayout(
      activeTab: 2,
      pageName: "Services",
      content: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 8.0, top: 20),
        primary: false,
        child: Column(
          children: [
            // top row
            Center(
              child:const CTARow(),
            ),
            // heading row with filters
            SearchAndProfileSection(
              itemCount: productController.productList.length,  // Passez le nombre d'éléments
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: !Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width - 90
                    : null,
                child: Obx(
                  () {
                    if (productController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.isDesktop(context)
                              ? 5
                              : Responsive.isMobile(context)
                                  ? 2  // 2 éléments par ligne en mobile
                                  : 2,
                          childAspectRatio: Responsive
                              .isDesktop(context)
                                  ? 6/5  // Ratio pour desktop
                                  : Responsive.isMobile(context)
                                      ? 1 // Ratio pour mobile (plus haute que large)
                                      : 6/5,  // Ratio pour tablette
                          mainAxisSpacing: Responsive.isMobile(context) ? 8 : 12,  // Espacement vertical entre les cartes
                          crossAxisSpacing: Responsive.isMobile(context) ? 8 : 12,  // Espacement horizontal entre les cartes
                        ),
                        itemCount: productController.productList.length,
                        itemBuilder: (_, index) =>
                            ProductCard(productController.productList[index]),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
