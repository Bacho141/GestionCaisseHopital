// ignore_for_file: depend_on_referenced_packages, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:migo/layout/layout.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/view/receipt/receipt_layout_widget.dart';
import 'package:migo/view/servicemedical/servicemedical_page.dart';
import 'package:migo/widgets/billing_page_divider.dart';
import 'package:migo/view/receipt/receipt_sceen.dart';
import 'package:migo/utils/custome_drive.dart';
import 'package:migo/models/receipt/receipt_model.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:migo/controller/receipt_controller.dart';


class CreateReceipt extends StatefulWidget {
  const CreateReceipt({super.key});

  @override
  State<CreateReceipt> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<CreateReceipt> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      activeTab: 1,
      pageName: "Management Reçu",
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(!Responsive.isMobile(context) ? 0 : 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BillingPageDivider(),
              const SizedBox(height: 32),
              // const Text("Gestion d'un reçu",
              //     style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
              // const SizedBox(height: 8),
              const ManagenentReceipt(),
            ],
          ),
        ),
      ),
    );
  }
}



class ManagenentReceipt extends StatelessWidget {
  const ManagenentReceipt({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: !Responsive.isMobile(context)
          ? MediaQuery.of(context).size.width - 90
          : MediaQuery.of(context).size.width,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 36,
        children: [
          const SizedBox(width: 20),
          const PatientsInfos(),

          const SizedBox(width: 39),
          if (Responsive.isDesktop(context)) const FactureInfos(),

          if (Responsive.isMobile(context)) Center(
            child:ReceiptScreen(),
          ),

          //ELLE EST OPTIONNELLE POUR L'ADMIN DE L'HOPITAL
          const SizedBox(width: 36),
          if (Responsive.isDesktop(context)) Padding(
            padding: const EdgeInsets.only(left: 10), // Ajoute 20 pixels d'espace
            child: Center(
              child: const ReceiptInfos(),
            ),
          ),
        ],
      ),
    );
  }
}

class PatientsInfos extends StatefulWidget {
  const PatientsInfos({Key? key}) : super(key: key);

  @override
  State<PatientsInfos> createState() => _PatientsInfosState();
}

class _PatientsInfosState extends State<PatientsInfos> {
  // const _PatientsInfosState({
  //   Key? key,
  // }) : super(key: key);
  final TextEditingController _nomCtrl = TextEditingController();
  final TextEditingController _prenomCtrl = TextEditingController();
  final TextEditingController _adresseCtrl = TextEditingController();
  final TextEditingController _telephoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ReceiptController _receiptCtrl = Get.put(ReceiptController());


  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          SizedBox(
          width: !Responsive.isMobile(context)
              ? (MediaQuery.of(context).size.width - 100) / 2.15
              : MediaQuery.of(context).size.width - 25,
          height: !Responsive.isMobile(context)? 580 : 500,
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: 6, // Effet élevé pour le conteneur
              intensity: 0.8,
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
              color: Colors.white, // Garde la couleur neutre pour ton design
              shadowLightColor: Colors.white, // Lumière douce
              shadowDarkColor: Colors.grey.shade500, // Ombre externe
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              
              child: Form( 
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Neumorphic(
                          style: NeumorphicStyle(
                            depth: 4, // Effet de relief pour l'icône
                            intensity: 0.8,
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.circle(),
                            color: const Color.fromARGB(152, 121, 23, 232), // Conserve la couleur originale
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.person,
                              size: 20,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Patient Infos",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomDivider(),
                    const SizedBox(height: 50),
                    // Formulaire avec effet intérieur concave
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: -4, // Effet intérieur concave
                        intensity: 0.6,
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _nomCtrl,
                        decoration: InputDecoration(
                          hintText: "Nom",
                          hintStyle: TextStyle(color: Color(0xFF7717E8)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                        validator: (value) => value!.isEmpty ? 'Nom requis' : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: -4, // Effet intérieur concave
                        intensity: 0.6,
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _prenomCtrl,
                        decoration: InputDecoration(
                          hintText: "Prénom",
                          hintStyle: TextStyle(color: Color(0xFF7717E8)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                        validator: (value) => value!.isEmpty ? 'Nom requis' : null,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: -4, // Effet intérieur concave
                        intensity: 0.6,
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _adresseCtrl,
                        decoration: InputDecoration(
                          hintText: "Adresse",
                          hintStyle: TextStyle(color: Color(0xFF7717E8)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: -4, // Effet intérieur concave
                        intensity: 0.6,
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: _telephoneCtrl,
                        decoration: InputDecoration(
                          hintText: "Téléphone",
                          hintStyle: TextStyle(color: Color(0xFF7717E8)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: NeumorphicButton(
                        onPressed: () async{
                          if (_formKey.currentState!.validate()) {
                            _receiptCtrl.initNewReceipt(
                              clientName: _nomCtrl.text.trim(),
                              clientFirstname: _prenomCtrl.text.trim(),
                              clientPhone: _telephoneCtrl.text.trim(),
                              clientAddress: _adresseCtrl.text.trim(),
                            );

                            // 2) Laisser Flutter propager le Rxn…
                            await Future.delayed(Duration.zero);

                            // 3) …et là tu pourras lire currentReceipt.value sans qu'il soit null
                            //⬇️ Impression des infos du reçu dans le terminal
                            print('📦 Nouveau reçu généré :: ${_receiptCtrl.currentReceipt.value!.toMap()}');

                            // Redirection vers la page des services
                            Get.to(() => const ProductsPage());
                          }
                        },
                        style: NeumorphicStyle(
                          depth: 6, // Léger effet de relief pour le bouton
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.send),
                            const SizedBox(width: 8),
                            const Text("Enregistré"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
            ),
          ),
          
        ),
        // Utiliser le FloatingActionButton pour les testes
        // Positioned(
        //   right: 200,
        //   bottom: 20,
        //   child: FloatingActionButton.extended(
        //     label: const Text('Tester Create'),
        //     icon: const Icon(Icons.send),
        //     onPressed: () async {
        //       print('▶ Appel createReceipt()');
        //       final success = await _receiptCtrl.createReceipt();

        //       if (success) {
        //         print('✅ createReceipt a renvoyé true');
        //         final r = _receiptCtrl.currentReceipt.value;
        //         print('▶ Receipt rechargé depuis le serveur : ${r?.toMap()}');
        //       } else {
        //         print('❌ createReceipt a échoué');
        //       }

        //       Get.snackbar(
        //         success ? 'OK' : 'Erreur',
        //         success
        //             ? 'Reçu créé avec ID ${_receiptCtrl.currentReceipt.value?.receiptNumber}'
        //             : 'La création a échoué',
        //         snackPosition: SnackPosition.BOTTOM,
        //         backgroundColor: success ? Colors.green.withOpacity(0.8) : Colors.red.withOpacity(0.8),
        //         colorText: Colors.white,
        //       );
        //     },
        //   ),
        // ),
      ]
    );
  }
}

class FactureInfos extends StatelessWidget {
  const FactureInfos({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: !Responsive.isMobile(context)
          ? (MediaQuery.of(context).size.width - 100) / 2.15
          : MediaQuery.of(context).size.width - 25,
      height: !Responsive.isMobile(context)? 580 : 380,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 6, // Effet élevé pour le conteneur
          intensity: 0.8,
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
          color: Colors.white, // Garde la couleur neutre pour ton design
          shadowLightColor: Colors.white, // Lumière douce
          shadowDarkColor: Colors.grey.shade500, // Ombre externe
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Neumorphic(
                    style: NeumorphicStyle(
                      depth: 4, // Effet de relief pour l'icône
                      intensity: 0.8,
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.circle(),
                      color: const Color.fromARGB(152, 121, 23, 232), // Conserve la couleur originale
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Iconsax.box,
                        size: 20,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Facture Info",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomDivider(),
              const SizedBox(height: 30),
              
              Center(
                child: Container(
                  width: !Responsive.isMobile(context)
                  ? (MediaQuery.of(context).size.width - 100) / 2.15
                  : MediaQuery.of(context).size.width - 25, // Largeur fixe
                  height: 400, // Hauteur fix
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ReceiptScreen(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ReceiptInfos extends StatefulWidget {
  const ReceiptInfos({Key? key}) : super(key: key);

  @override
  State<ReceiptInfos> createState() => _ReceiptInfosState();
}

class _ReceiptInfosState extends State<ReceiptInfos> {
  late Receipt? _receipt;
  late bool _isLoading;
  late String _errorMessage;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _errorMessage = '';
    _loadReceiptData();
  }

  Future<void> _loadReceiptData() async {
    try {
      // Simulation de réponse JSON
      // final mockJsonResponse = {
      //   "receiptNumber": "REC-2025-045",
      //   "dateTime": "2023-10-25T14:45:00Z",
      //   "clientName": "Dupont Jean",
      //   "produits": [
      //     {
      //       "designation": "Produit A",
      //       "unitPrice": 1500,
      //       "quantity": 7,
      //       "amount": 10500
      //     },
      //     {
      //       "designation": "Produit A",
      //       "unitPrice": 1500,
      //       "quantity": 7,
      //       "amount": 10500
      //     },
      //     {
      //       "designation": "Produit A",
      //       "unitPrice": 1500,
      //       "quantity": 7,
      //       "amount": 10500
      //     },
      //     {
      //       "designation": "Produit A",
      //       "unitPrice": 1500,
      //       "quantity": 7,
      //       "amount": 10500
      //     },
      //     {
      //       "designation": "Produit A",
      //       "unitPrice": 1500,
      //       "quantity": 7,
      //       "amount": 10500
      //     },
      //     {
      //       "designation": "Produit A",
      //       "unitPrice": 1500,
      //       "quantity": 7,
      //       "amount": 10500
      //     },
      //     {
      //       "designation": "Produit A",
      //       "unitPrice": 1500,
      //       "quantity": 7,
      //       "amount": 10500
      //     },
      //     {
      //       "designation": "Produit A",
      //       "unitPrice": 1500,
      //       "quantity": 7,
      //       "amount": 10500
      //     },
      //     {
      //       "designation": "Produit A",
      //       "unitPrice": 1500,
      //       "quantity": 7,
      //       "amount": 10500
      //     },
      //     {
      //       "designation": "Produit A",
      //       "unitPrice": 1500,
      //       "quantity": 7,
      //       "amount": 10500
      //     },
      //     {
      //       "designation": "Produit A",
      //       "unitPrice": 1500,
      //       "quantity": 7,
      //       "amount": 10500
      //     },
      //     {
      //       "designation": "Produit A",
      //       "unitPrice": 1500,
      //       "quantity": 7,
      //       "amount": 10500
      //     },
      //     {
      //       "designation": "Produit B", 
      //       "unitPrice": 2500,
      //       "quantity": 3,
      //       "amount": 7500
      //     },
      //     {
      //       "designation": "Produit C", 
      //       "unitPrice": 2500,
      //       "quantity": 3,
      //       "amount": 7500
      //     },
      //     {
      //       "designation": "Produit D", 
      //       "unitPrice": 2500,
      //       "quantity": 3,
      //       "amount": 7500
      //     },
      //     {
      //       "designation": "Produit E", 
      //       "unitPrice": 2500,
      //       "quantity": 3,
      //       "amount": 7500
      //     }
      //   ],
      //   "total": 18000,
      //   "totalInWords": "Dix-huit mille",
      //   "paid": 15000,
      //   "due": 3000,
      //   "companyName": "Ma Société",
      //   "nif": "NIF-123-456",
      //   "rccm": "RCCM-2023-789",
      //   "address": "123 Rue Principale",
      //   "contact": "+227 90 00 00 00",
      //   "nomCaissier": "Jean CAISSIER"
      // };

      // Simulation de délai réseau
      await Future.delayed(const Duration(seconds: 1));

      // setState(() {
      //   _receipt = Receipt.fromMap(mockJsonResponse);
      //   _isLoading = false;
      // });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de chargement des données: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: !Responsive.isMobile(context)
          ? (MediaQuery.of(context).size.width) -500 / 2
          : MediaQuery.of(context).size.width - 16,
      height: 970,
      child: Center( // Assure le centrage du Neumorphic
        child: Neumorphic(
          style: NeumorphicStyle(
            depth: -10, // Effet concave interne plus prononcé
            intensity: 0.7, // Intensité modérée pour un bel effet
            shape: NeumorphicShape.concave, // Forme concave pour l'intérieur
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)), // Coins arrondis
            color: Colors.white, // Conserve la couleur originale
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildContent(), // Garde ton contenu existant
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        const CustomDivider(),
        const SizedBox(height: 30),
        ReceiptLayout(receipt: _receipt!),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(152, 121, 23, 232),
            borderRadius: BorderRadius.circular(16)),
          child: const Icon(
            Iconsax.receipt_1,
            size: 20,
            color: Color(0xFFFFFFFF),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          "Informations du reçu",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
