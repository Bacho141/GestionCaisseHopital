import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:migo/controller/simple_ui_controller.dart';
import 'package:migo/controller/auth_controller.dart';
import 'package:migo/view/receipt/create_receipt.dart';
import 'package:migo/view/auth/login.dart' as admin_login;
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
    final size = MediaQuery.of(context).size;
    SimpleUIController simpleUIController = Get.put(SimpleUIController());

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 74, 231, 158),
              ],
            ),
          ),
          child: Responsive(
            desktop: _buildLargeScreen(size, simpleUIController),
            mobile: _buildSmallScreen(size, simpleUIController),
          ),
        ),
      ),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2, // 75% de l'espace
          child: _buildMainBody(size, simpleUIController),
        ),
        Expanded(
          flex: 2, // 25% de l'espace
          child: Image.asset(
            'assets/side_image.png',
            height: size.height * 1,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 210.0,
          ),
          child: _buildMainBody(size, simpleUIController),
        ),
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ajustement dynamique basé sur la présence du clavier
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 40
        ),

        // Logo et titre
        Center(
          child: Image.asset(
            'assets/Logo_CV01.png',
            width: isDesktop ? size.width / 6 : size.width / 2,
            height: isMobile ? 150 : null,
          ),
        ),
        SizedBox(height: isMobile ? 15 : 15),
        Text(
          'Connexion Agent 😊',
          style: TextStyle(
            fontSize: isMobile ? 20 : size.height * 0.035,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isMobile ? 15 : 20),

        // Formulaire dans un SizedBox avec ombre
        Center(
          child: SizedBox(
            width: isDesktop ? (size.width * 0.75) * 0.5 : size.width * 0.95,
            child: Container(
              padding: EdgeInsets.all(isMobile ? 15.0 : 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Téléphone
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Iconsax.call, color: Color(0xFF667eea)),
                        hintText: 'Téléphone',
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF667eea), width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: isMobile ? 12 : 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un numéro';
                        } else if (!RegExp(r'^\d{8,15}$').hasMatch(value)) {
                          return 'Numéro invalide';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: isMobile ? 12 : 20),

                    // Mot de passe
                    Obx(() => TextFormField(
                          controller: passwordController,
                          obscureText: simpleUIController.isObscure.value,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Iconsax.lock,
                                color: Color(0xFF667eea)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                simpleUIController.isObscure.value
                                    ? Iconsax.eye
                                    : Iconsax.eye_slash,
                                color: Color(0xFF667eea),
                              ),
                              onPressed: simpleUIController.isObscureActive,
                            ),
                            hintText: 'Mot de passe',
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFF667eea), width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: isMobile ? 12 : 16),
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
                    SizedBox(height: isMobile ? 15 : 30),

                    // Login Button
                    Obx(() {
                      final loading = _authCtrl.loading.value;
                      return Container(
                        width: double.infinity,
                        height: isMobile ? 45 : 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF667eea).withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: loading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    await _authCtrl.loginAgent(
                                      phoneController.text.trim(),
                                      passwordController.text,
                                    );
                                    if (_authCtrl.agentUser.value != null) {
                                      Get.offAll(() => const CreateReceipt());
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            loading ? 'Connexion...' : 'Se connecter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: isMobile ? 12 : 20),

                    // Lien vers login admin
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const admin_login.LoginView());
                      },
                      child: Text(
                        'Vous êtes admin ? Connexion Admin',
                        style: TextStyle(
                          color: const Color(0xFF667eea),
                          fontSize: isMobile ? 12 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Espacement en bas qui s'ajuste selon la présence du clavier
        SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 40),
      ],
    );
  }
}
