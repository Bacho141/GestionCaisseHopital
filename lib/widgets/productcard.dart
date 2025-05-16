import 'package:migo/models/product/product.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/utils/custome_drive.dart';
import 'package:migo/utils/icon_mapping.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    // Calcul dynamique de la largeur de la carte en fonction de l'écran
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);
    
    // Largeur calculée pour s'adapter à deux cartes par ligne en mobile
    final cardWidth = isMobile 
        ? (screenWidth / 2) - 24 // Deux cartes par ligne en mobile avec espacement
        : isDesktop 
            ? (screenWidth - 100) / 3
            : 315;
            
    // Hauteur adaptative pour maintenir un bon rapport hauteur/largeur
    final cardHeight = isMobile ? 200.0 : 300.0;

    return Center(
      child: Container(
        width: cardWidth.toDouble(),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            GestureDetector(
              onTap: () {
                _showEditDialog(context, product);
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: cardWidth.toDouble(),
                  height: cardHeight,
                  padding: EdgeInsets.all(isMobile ? 6.0 : 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: -8, // Effet concave plus prononcé
                            intensity: 0.8, // Intensité raffinée
                            shape: NeumorphicShape.concave,
                            lightSource: LightSource.topLeft, // Source de lumière pour un effet plus réaliste
                            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                            color: Colors.white,
                            shadowLightColor: Colors.white.withOpacity(0.9),
                            shadowDarkColor: Colors.grey.shade300,
                            border: NeumorphicBorder(
                              color: Colors.grey.shade100,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: product.icon != null && iconMapping.containsKey(product.icon)
                              ? Icon(
                                  iconMapping[product.icon], 
                                  size: isMobile ? 80 : 100,
                                  color: Theme.of(context).primaryColor,
                                )
                              : FadeInImage(
                                  image: const AssetImage('assets/company_logo.png'),
                                  placeholder: const AssetImage('assets/company_logo.png'),
                                  fit: BoxFit.contain,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(height: isMobile ? 8 : 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          product.label.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: isMobile ? 12 : 13,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Text(
                              "Prix : ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500, 
                                fontSize: isMobile ? 14 : 15,
                              ),
                            ),
                            Text(
                              "${product.tarif} F",
                              style: TextStyle(
                                fontWeight: FontWeight.w700, 
                                fontSize: isMobile ? 15 : 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Product product) {
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    TextEditingController nameController = TextEditingController(text: product.label);
    TextEditingController priceController = TextEditingController(text: product.tarif);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                "Modifier",
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              CustomDivider(),
              SizedBox(height: isMobile ? 20 : 30),
            ],
          ),
          content: SizedBox(
            width: isDesktop 
                ? screenWidth * 0.3
                : isMobile 
                    ? screenWidth * 0.8
                    : screenWidth * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nom du produit",
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: "Prix du produit",
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Annuler',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Enregistrer les modifications
                product.label = nameController.text;
                product.tarif = priceController.text;
                Navigator.pop(context);
              },
              icon: Icon(Icons.save),
              label: Text('Enregistrer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 16,
                  vertical: isMobile ? 8 : 10,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class VariantCircle extends StatelessWidget {
  const VariantCircle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 36,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xffFF6900), width: 2.0),
      ),
    );
  }
}

RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
String Function(Match) mathFunc = (Match match) => '${match[1]},';