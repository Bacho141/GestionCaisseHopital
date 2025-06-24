// import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
// import 'package:get/get.dart';
// import 'package:migo/controller/controller_agent.dart';
// import 'package:migo/controller/auth_controller.dart'; // ou AuthenticationManager
// import 'package:migo/view/responsive.dart';

// class AgentLogin extends StatefulWidget {
//   const AgentLogin({Key? key}) : super(key: key);

//   @override
//   _AgentLoginState createState() => _AgentLoginState();
// }

// class _AgentLoginState extends State<AgentLogin> {
//   final _phoneCtrl = TextEditingController();
//   final _pwdCtrl   = TextEditingController();
//   final _formKey   = GlobalKey<FormState>();

//   // Controller Agent + AuthManager
//   final AgentController _agentCtrl = Get.put(AgentController());
//   // final AuthenticationManager _authMgr = Get.find();

//   bool _loading = false;

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _loading = true);

//     final success = await _agentCtrl.loginAgent(
//       _phoneCtrl.text.trim(),
//       _pwdCtrl.text,
//     );
//     setState(() => _loading = false);

//     if (success) {
//       // AuthenticationManager.login() a déjà été appelé
//       Get.offAllNamed('/dashboard');
//     } else {
//       Get.snackbar(
//         'Erreur',
//         'Téléphone ou mot de passe incorrect',
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _phoneCtrl.dispose();
//     _pwdCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isMobile = Responsive.isMobile(context);
//     final screenW  = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(
//               horizontal: isMobile ? 24 : screenW * 0.2,
//               vertical: 32,
//             ),
//             child: Neumorphic(
//               style: NeumorphicStyle(
//                 depth: 8,
//                 intensity: 0.85,
//                 boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
//                 color: Colors.white,
//               ),
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Logo (même que pour l’admin)
//                   Image.asset(
//                     'assets/migo_logo.png',
//                     width: isMobile ? 120 : 180,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Connexion Agent',
//                     style: TextStyle(
//                       fontSize: isMobile ? 24 : 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         // Téléphone
//                         Neumorphic(
//                           style: NeumorphicStyle(
//                             depth: -4,
//                             intensity: 0.6,
//                             boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
//                             color: Colors.white,
//                           ),
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           child: TextFormField(
//                             controller: _phoneCtrl,
//                             keyboardType: TextInputType.phone,
//                             decoration: const InputDecoration(
//                               hintText: 'Téléphone',
//                               border: InputBorder.none,
//                             ),
//                             validator: (v) {
//                               if (v == null || v.isEmpty) return 'Requis';
//                               if (!RegExp(r'^\d{8,15}$').hasMatch(v)) {
//                                 return 'Numéro invalide';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         // Mot de passe
//                         Neumorphic(
//                           style: NeumorphicStyle(
//                             depth: -4,
//                             intensity: 0.6,
//                             boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
//                             color: Colors.white,
//                           ),
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           child: TextFormField(
//                             controller: _pwdCtrl,
//                             obscureText: true,
//                             decoration: const InputDecoration(
//                               hintText: 'Mot de passe',
//                               border: InputBorder.none,
//                             ),
//                             validator: (v) {
//                               if (v == null || v.isEmpty) return 'Requis';
//                               return null;
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         // Bouton Se connecter
//                         NeumorphicButton(
//                           onPressed: _loading ? null : _submit,
//                           style: NeumorphicStyle(
//                             depth: 4,
//                             intensity: 0.8,
//                             boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
//                             color: Theme.of(context).primaryColor,
//                           ),
//                           child: SizedBox(
//                             width: double.infinity,
//                             height: 48,
//                             child: Center(
//                               child: _loading
//                                   ? const CircularProgressIndicator(color: Colors.white)
//                                   : const Text(
//                                       'Se connecter',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 16),
//                   // Lien vers login Admin
//                   GestureDetector(
//                     onTap: () => Get.offAllNamed('/login'),
//                     child: Text(
//                       'Connexion Admin',
//                       style: TextStyle(
//                         color: Theme.of(context).primaryColor,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:migo/controller/simple_ui_controller.dart';
import 'package:migo/controller/controller_agent.dart';
import 'package:migo/controller/auth_controller.dart';
import 'package:migo/view/receipt/create_receipt.dart';
import 'package:migo/view/auth/login.dart' as admin_login; // import de la page login admin
import 'package:migo/view/responsive.dart';
import 'package:migo/widgets/buttons.dart';

class AgentLoginView extends StatefulWidget {
  const AgentLoginView({Key? key}) : super(key: key);

  @override
  State<AgentLoginView> createState() => _AgentLoginViewState();
}

class _AgentLoginViewState extends State<AgentLoginView> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // final AgentController _agentCtrl = Get.put(AgentController());
  final AuthController _authCtrl = Get.put(AuthController());
  
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SimpleUIController simpleUIController = Get.put(SimpleUIController());
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Responsive(
            desktop: _buildLargeScreen(size, simpleUIController),
            mobile: _buildSmallScreen(size, simpleUIController),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Row(
      children: [
        Expanded(child: _buildMainBody(size, simpleUIController)),
        Expanded(
          child: Image.asset(
            'assets/side_image.png',
            height: size.height,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Center(child: _buildMainBody(size, simpleUIController));
  }

  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Image.asset(
              'assets/migo_logo.png',
              width: size.width / 2,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Connexion Agent',
              style: TextStyle(fontSize: size.height * 0.030),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Téléphone
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.call),
                      hintText: 'Téléphone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un numéro';
                      } else if (!RegExp(r'^\d{8,15}$').hasMatch(value)) {
                        return 'Numéro invalide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Mot de passe
                  Obx(() => TextFormField(
                        controller: passwordController,
                        obscureText: simpleUIController.isObscure.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.lock),
                          suffixIcon: IconButton(
                            icon: Icon(simpleUIController.isObscure.value
                                ? Iconsax.eye
                                : Iconsax.eye_slash),
                            onPressed: simpleUIController.isObscureActive,
                          ),
                          hintText: 'Mot de passe',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un mot de passe';
                          } else if (value.length < 6) {
                            return 'Au moins 6 caractères';
                          }
                          return null;
                        },
                      )),
                  const SizedBox(height: 16),

                  PrimaryButton(
                    vertPad: 20,
                    buttonTitle: 'Login',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _authCtrl.loginAgent(
                          phoneController.text.trim(),
                          passwordController.text,
                        );
                        if (_authCtrl.agentUser.value != null) {
                          Get.offAll(() => const CreateReceipt());
                        } else {
                          Get.snackbar(
                            'Erreur',
                            'View Login Téléphone ou mot de passe invalide',
                            backgroundColor: Colors.redAccent,
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: size.height * 0.03),

                  // Lien vers login admin
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const admin_login.LoginView());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Vous êtes admin ? ',
                        style: const TextStyle(color: Colors.black54),
                        children: [
                          TextSpan(
                            text: 'Connexion Admin',
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
