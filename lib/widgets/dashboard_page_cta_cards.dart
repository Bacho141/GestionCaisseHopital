import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:migo/view/products/productpage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:migo/view/responsive.dart';

class BoxCTACard extends StatelessWidget {
  final Widget toPage;
  final String caption;
  final String image;
  final bool isGoToAdmin;
  final Color? cardColor;
  const BoxCTACard({
    Key? key,
    this.toPage = const ProductsPage(),
    required this.caption,
    required this.image,
    required this.cardColor,
    this.isGoToAdmin = false,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    // Flag mobile
  final bool mobile = Responsive.isMobile(context);
  // Échelles
  final double cardScale = mobile ? 1.07 : 1.0;
  final double imageScale = mobile ? 0.85 : 1.0;
  final double fontScale = mobile ? 0.5 : 1.0;

    return InkWell(
      onTap: () {
        if (!isGoToAdmin) {
          Get.to(() => toPage, transition: Transition.noTransition);
        } else {
          _launchUrl("https://backpos.herokuapp.com/admin/");
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Transform.scale(
        scale: cardScale,
        alignment: Alignment.topCenter,
        child: Card(
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: imageScale,
                  child: Image.asset(image, fit: BoxFit.cover),
                ),
                const SizedBox(height: 8),
                // Texte réduit
                Text(
                  caption,
                  style: TextStyle(
                    color: const Color(0xff0c0d16),
                    fontWeight: FontWeight.w800,
                    fontSize: 24 * fontScale,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _launchUrl(url) async {
  // ignore: no_leading_underscores_for_local_identifiers
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $_url';
  }
}
