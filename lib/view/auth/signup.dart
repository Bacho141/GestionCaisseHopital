import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:migo/controller/auth_controller.dart';
import 'package:migo/controller/simple_ui_controller.dart';
import 'package:migo/view/auth/login.dart';
import 'package:migo/view/servicemedical/servicemedical_page.dart';
import 'package:migo/view/responsive.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> with TickerProviderStateMixin {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    firstnameController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);
    
    // Détection du clavier
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    
    // Calcul de la hauteur disponible
    final availableHeight = size.height - 
        MediaQuery.of(context).padding.top - 
        MediaQuery.of(context).padding.bottom - 
        keyboardHeight;
    
    // Instanciation des controllers GetX
    final SimpleUIController uiCtrl = Get.put(SimpleUIController());
    final AuthController authCtrl = Get.put(AuthController());

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
          child: SafeArea(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const ClampingScrollPhysics(),
                child: SizedBox(
                  height: availableHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? size.width * 0.25 : 16.0,
                      vertical: 10.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo avec animation et redimensionnement adaptatif
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: _getLogoHeight(context, isKeyboardVisible, isMobile, isDesktop, size),
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Center(
                              child: Image.asset(
                                'assets/migo_logo.png',
                                width: _getLogoWidth(context, isKeyboardVisible, isMobile, isDesktop, size),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        
                        // Espacement adaptatif
                        SizedBox(height: isKeyboardVisible ? 10 : (isMobile ? 10 : 15)),
                        
                        // Titre avec animation
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            fontSize: isKeyboardVisible 
                                ? (isMobile ? 18 : size.height * 0.03)
                                : (isMobile ? 20 : size.height * 0.035),
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          child: const Text(
                            'Créons un compte 😀',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        SizedBox(height: isKeyboardVisible ? 10 : (isMobile ? 15 : 20)),
                        
                        // Formulaire avec container flexible
                        Flexible(
                          child: Center(
                            child: SizedBox(
                              width: isDesktop ? size.width * 0.5 : size.width * 0.95,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: EdgeInsets.all(
                                  isKeyboardVisible 
                                      ? (isMobile ? 12.0 : 25.0)
                                      : (isMobile ? 15.0 : 30.0)
                                ),
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
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildTextField(
                                        controller: firstnameController,
                                        icon: Iconsax.user,
                                        hint: 'Prénom',
                                        isMobile: isMobile,
                                        isKeyboardVisible: isKeyboardVisible,
                                        validator: (v) {
                                          if (v == null || v.isEmpty) {
                                            return 'Veuillez saisir votre Prénom';
                                          } else if (v.length < 4) {
                                            return 'Au moins 4 caractères';
                                          }
                                          return null;
                                        },
                                      ),
                                      
                                      _buildSpacer(isMobile, isKeyboardVisible),
                                      
                                      _buildTextField(
                                        controller: nameController,
                                        icon: Iconsax.user_edit,
                                        hint: 'Nom',
                                        isMobile: isMobile,
                                        isKeyboardVisible: isKeyboardVisible,
                                        validator: (v) {
                                          if (v == null || v.isEmpty) {
                                            return 'Veuillez saisir votre nom';
                                          } else if (v.length < 4) {
                                            return 'Au moins 4 caractères';
                                          }
                                          return null;
                                        },
                                      ),
                                      
                                      _buildSpacer(isMobile, isKeyboardVisible),
                                      
                                      _buildTextField(
                                        controller: emailController,
                                        icon: Iconsax.sms,
                                        hint: 'Email',
                                        keyboardType: TextInputType.emailAddress,
                                        isMobile: isMobile,
                                        isKeyboardVisible: isKeyboardVisible,
                                        validator: (v) {
                                          if (v == null || v.isEmpty) {
                                            return 'Veuillez saisir votre email';
                                          } else if (!GetUtils.isEmail(v)) {
                                            return 'Enter un email valide';
                                          }
                                          return null;
                                        },
                                      ),
                                      
                                      _buildSpacer(isMobile, isKeyboardVisible),
                                      
                                      Obx(() => _buildTextField(
                                        controller: passwordController,
                                        icon: Iconsax.lock,
                                        hint: 'Mot de passe',
                                        obscureText: uiCtrl.isObscure.value,
                                        isMobile: isMobile,
                                        isKeyboardVisible: isKeyboardVisible,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            uiCtrl.isObscure.value ? Iconsax.eye : Iconsax.eye_slash,
                                            color: const Color(0xFF667eea),
                                          ),
                                          onPressed: uiCtrl.isObscureActive,
                                        ),
                                        validator: (v) {
                                          if (v == null || v.isEmpty) {
                                            return 'Veuillez saisir un mot de passe';
                                          } else if (v.length < 6) {
                                            return 'Au moins 6 caractères';
                                          }
                                          return null;
                                        },
                                      )),
                                      
                                      _buildSpacer(isMobile, isKeyboardVisible),
                                      
                                      Obx(() => _buildTextField(
                                        controller: confirmPasswordController,
                                        icon: Iconsax.lock,
                                        hint: 'Confirmer le mot de passe',
                                        obscureText: uiCtrl.isObscure.value,
                                        isMobile: isMobile,
                                        isKeyboardVisible: isKeyboardVisible,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            uiCtrl.isObscure.value ? Iconsax.eye : Iconsax.eye_slash,
                                            color: const Color(0xFF667eea),
                                          ),
                                          onPressed: uiCtrl.isObscureActive,
                                        ),
                                        validator: (v) {
                                          if (v != passwordController.text) {
                                            return 'Les mots de passe ne correspondent pas';
                                          }
                                          return null;
                                        },
                                      )),
                                      
                                      SizedBox(height: isKeyboardVisible ? 12 : (isMobile ? 15 : 30)),
                                      
                                      // Bouton de création de compte
                                      Obx(() {
                                        return AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          width: double.infinity,
                                          height: isKeyboardVisible ? 42 : (isMobile ? 45 : 50),
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
                                            onPressed: authCtrl.loading.value ? null : () async {
                                              if (_formKey.currentState!.validate()) {
                                                await authCtrl.signup(
                                                  firstnameController.text.trim(),
                                                  nameController.text.trim(),
                                                  emailController.text.trim(),
                                                  passwordController.text,
                                                );
                                                _formKey.currentState!.reset();
                                                firstnameController.clear();
                                                nameController.clear();
                                                emailController.clear();
                                                passwordController.clear();
                                                confirmPasswordController.clear();
                                                if (authCtrl.adminUser.value != null) {
                                                  Get.to(() => const ProductsPage());
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
                                              authCtrl.loading.value ? 'Chargement...' : 'Créer un compte',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: isKeyboardVisible ? 13 : (isMobile ? 14 : 16),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                      
                                      SizedBox(height: isKeyboardVisible ? 8 : (isMobile ? 12 : 20)),
                                      
                                      // Lien de connexion
                                      GestureDetector(
                                        onTap: () {
                                          _formKey.currentState?.reset();
                                          firstnameController.clear();
                                          nameController.clear();
                                          emailController.clear();
                                          passwordController.clear();
                                          confirmPasswordController.clear();
                                          uiCtrl.isObscure.value = true;
                                          Get.to(() => const LoginView());
                                        },
                                        child: AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 300),
                                          style: TextStyle(
                                            color: const Color(0xFF667eea),
                                            fontSize: isKeyboardVisible ? 11 : (isMobile ? 12 : 14),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          child: const Text(
                                            'Vous avez déjà un compte? Connectez-vous',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // Espacement final minimal
                        SizedBox(height: isKeyboardVisible ? 5 : 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Méthode pour calculer la hauteur du logo
  double _getLogoHeight(BuildContext context, bool isKeyboardVisible, bool isMobile, bool isDesktop, Size size) {
    if (isKeyboardVisible) {
      return isMobile ? 40 : 50;
    }
    return isMobile ? 60 : 80;
  }

  // Méthode pour calculer la largeur du logo
  double _getLogoWidth(BuildContext context, bool isKeyboardVisible, bool isMobile, bool isDesktop, Size size) {
    if (isKeyboardVisible) {
      return isDesktop ? size.width / 6 : size.width / 3;
    }
    return isDesktop ? size.width / 4.5 : size.width / 2;
  }

  // Méthode pour construire les champs de texte avec animation
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required bool isMobile,
    required bool isKeyboardVisible,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF667eea)),
          suffixIcon: suffixIcon,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: isKeyboardVisible ? (isMobile ? 10 : 12) : (isMobile ? 12 : 16),
          ),
        ),
        validator: validator,
      ),
    );
  }

  // Méthode pour créer des espacements adaptatifs
  Widget _buildSpacer(bool isMobile, bool isKeyboardVisible) {
    return SizedBox(
      height: isKeyboardVisible ? (isMobile ? 8 : 12) : (isMobile ? 12 : 20),
    );
  }
}
