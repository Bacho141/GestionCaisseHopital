// import 'package:flutter/material.dart';
// import 'package:migo/view/products/billing/billing.dart';
// import 'package:migo/view/products/saleshistory/sales_history.dart';
// import 'package:migo/view/responsive.dart';
// import 'package:migo/widgets/product_page_cta_cards.dart';
// import 'package:url_launcher/url_launcher.dart';

// class CTARow extends StatelessWidget {
//   const CTARow({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       // height: Responsive.isDesktop(context) ? 270 : null,
//       width: !Responsive.isMobile(context)
//           ? MediaQuery.of(context).size.width - 90
//           : MediaQuery.of(context).size.width,
//       child: Wrap(
//         spacing: 4,
//         alignment: WrapAlignment.center,
//         runAlignment: WrapAlignment.center,
//         crossAxisAlignment: WrapCrossAlignment.center,
//         direction:
//             !Responsive.isMobile(context) ? Axis.horizontal : Axis.vertical,
//         children: [ 
//           Expanded(
//             child: ProductCTACard(
//               toPage: Billing(isMobile: Responsive.isMobile(context)),
//               caption: "Prestation",
//               image: "assets/soins-medicaux.png",
//               cardColor: const Color(0xffDAEEB8)
//             ),
//           ),
//           Expanded(
//             child: ProductCTACard(
//               toPage: SalesHistory(),
//                 caption: "Examen de Laboratoire",
//                 image: "assets/laboratoire-medical.png",
//                 cardColor: Color(0xffFFD58E)
//             ),
//           ),
//           Expanded(
//             child: ProductCTACard(
//              caption: "Actes Medico-Chirurgicaux",
//               image: "assets/chirurgie.png",
//               cardColor: Color(0xffBEE4FF),
//               isGoToAdmin: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:migo/view/products/billing/billing.dart';
import 'package:migo/view/products/saleshistory/sales_history.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/widgets/product_page_cta_cards.dart';
import 'package:url_launcher/url_launcher.dart';

class CTARow extends StatelessWidget {
  const CTARow({
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calculer la largeur appropriée pour éviter le dépassement sur mobile
    final containerWidth = isMobile 
        ? screenWidth - 32 // Ajout de marge pour éviter le dépassement
        : !isMobile 
            ? screenWidth - 90
            : screenWidth;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16.0 : 0,
        vertical: 16.0,
      ),
      child: SizedBox(
        width: containerWidth,
        child: isMobile
            ? Column(
                children: _buildCTAItems(context),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildCTAItems(context),
              ),
      ),
    );
  }
  
  List<Widget> _buildCTAItems(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calculer la largeur du card en fonction de la taille de l'écran
    final cardWidth = isMobile 
        ? screenWidth - 32 // Pleine largeur sur mobile (moins les marges)
        : (screenWidth - 90) / 3 - 16; // Diviser l'espace disponible par 3 sur desktop
    
    // Hauteur fixe pour un meilleur rendu
    final cardHeight = isMobile ? 130.0 : 220.0;
    
    return [
      _buildNeumorphicCTACard(
        context,
        caption: "Prestation",
        imagePath: "assets/soins-medicaux.png",
        color: const Color(0xffDAEEB8),
        width: cardWidth,
        height: cardHeight,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Billing(isMobile: isMobile),
            ),
          );
        },
      ),
      SizedBox(height: isMobile ? 16 : 0, width: isMobile ? 0 : 16),
      _buildNeumorphicCTACard(
        context,
        caption: "Examen de Laboratoire",
        imagePath: "assets/laboratoire-medical.png",
        color: Color(0xffFFD58E),
        width: cardWidth,
        height: cardHeight,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesHistory(),
            ),
          );
        },
      ),
      SizedBox(height: isMobile ? 16 : 0, width: isMobile ? 0 : 16),
      _buildNeumorphicCTACard(
        context,
        caption: "Actes Medico-Chirurgicaux",
        imagePath: "assets/chirurgie.png",
        color: Color(0xffBEE4FF),
        width: cardWidth,
        height: cardHeight,
        isAdmin: true,
        onTap: () {
          // Action pour admin
        },
      ),
    ];
  }
  
  Widget _buildNeumorphicCTACard(
    BuildContext context, {
    required String caption,
    required String imagePath,
    required Color color,
    required double width,
    required double height,
    bool isAdmin = false,
    required VoidCallback onTap,
  }) {
    final isMobile = Responsive.isMobile(context);
    
    return NeumorphicButton(
      onPressed: onTap,
      style: NeumorphicStyle(
        depth: 10,
        intensity: 0.85,
        surfaceIntensity: 0.5,
        shape: NeumorphicShape.convex,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        color: color,
        lightSource: LightSource.topLeft,
        shadowLightColor: Colors.white.withOpacity(0.8),
        shadowDarkColor: Colors.black38,
        border: NeumorphicBorder(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: EdgeInsets.zero,
              child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(isMobile ? 12 : 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.9),
              color.withOpacity(0.7),
            ],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(isMobile ? 8 : 12),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: -5,
                    intensity: 0.9,
                    boxShape: NeumorphicBoxShape.circle(),
                    color: Colors.white,
                    shadowLightColor: Colors.white,
                    shadowDarkColor: color.withOpacity(0.5),
                    lightSource: LightSource.topLeft,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 6 : 10),
                    child: Image.asset(
                      imagePath,
                      height: isMobile ? 40 : 60,
                      width: isMobile ? 40 : 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    caption,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Neumorphic(
                        style: NeumorphicStyle(
                          depth: 4,
                          intensity: 0.8,
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12),
                          ),
                          color: color,
                          lightSource: LightSource.topLeft,
                          shadowLightColor: Colors.white.withOpacity(0.8),
                          shadowDarkColor: Colors.black26,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isAdmin ? Icons.admin_panel_settings : Icons.arrow_forward,
                                size: isMobile ? 16 : 20,
                                color: Colors.black54,
                              ),
                              SizedBox(width: 4),
                              Text(
                                isAdmin ? "Admin" : "Ouvrir",
                                style: TextStyle(
                                  fontSize: isMobile ? 12 : 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}