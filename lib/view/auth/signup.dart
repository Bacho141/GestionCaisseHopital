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

class _SignupState extends State<Signup> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstnameController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);
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
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? size.width * 0.25 : 16.0,
                      vertical: 10.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom > 0
                                ? 10
                                : 40),
                        Center(
                          child: Image.asset(
                            'assets/migo_logo.png',
                            width:
                                isDesktop ? size.width / 4.5 : size.width / 2,
                            height: isMobile ? 60 : null,
                          ),
                        ),
                        SizedBox(height: isMobile ? 10 : 15),
                        Text(
                          'Créons un compte 😀',
                          style: TextStyle(
                            fontSize: isMobile ? 20 : size.height * 0.035,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isMobile ? 15 : 20),
                        Center(
                          child: SizedBox(
                            width: isDesktop
                                ? size.width * 0.5
                                : size.width * 0.95,
                            child: Container(
                              padding: EdgeInsets.all(isMobile ? 15.0 : 30.0),
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
                                    TextFormField(
                                      controller: firstnameController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Iconsax.user,
                                            color: Color(0xFF667eea)),
                                        hintText: 'Prénom',
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF667eea),
                                              width: 2),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: isMobile ? 12 : 16),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.isEmpty) {
                                          return 'Veuillez saisir votre Prénom';
                                        } else if (v.length < 4) {
                                          return 'Au moins 4 caractères';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: isMobile ? 12 : 20),
                                    TextFormField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                            Iconsax.user_edit,
                                            color: Color(0xFF667eea)),
                                        hintText: 'Nom',
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF667eea),
                                              width: 2),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: isMobile ? 12 : 16),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.isEmpty) {
                                          return 'Veuillez saisir votre nom';
                                        } else if (v.length < 4) {
                                          return 'Au moins 4 caractères';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: isMobile ? 12 : 20),
                                    TextFormField(
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Iconsax.sms,
                                            color: Color(0xFF667eea)),
                                        hintText: 'Email',
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Color(0xFF667eea),
                                              width: 2),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: isMobile ? 12 : 16),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.isEmpty) {
                                          return 'Veuillez saisir votre email';
                                        } else if (!GetUtils.isEmail(v)) {
                                          return 'Enter un email valide';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: isMobile ? 12 : 20),
                                    Obx(() => TextFormField(
                                          controller: passwordController,
                                          obscureText: uiCtrl.isObscure.value,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(Iconsax.lock,
                                                color: Color(0xFF667eea)),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                uiCtrl.isObscure.value
                                                    ? Iconsax.eye
                                                    : Iconsax.eye_slash,
                                                color: Color(0xFF667eea),
                                              ),
                                              onPressed: uiCtrl.isObscureActive,
                                            ),
                                            hintText: 'Mot de passe',
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF667eea),
                                                  width: 2),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical:
                                                        isMobile ? 12 : 16),
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
                                    SizedBox(height: isMobile ? 12 : 20),
                                    Obx(() => TextFormField(
                                          controller: confirmPasswordController,
                                          obscureText: uiCtrl.isObscure.value,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(Iconsax.lock,
                                                color: Color(0xFF667eea)),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                uiCtrl.isObscure.value
                                                    ? Iconsax.eye
                                                    : Iconsax.eye_slash,
                                                color: Color(0xFF667eea),
                                              ),
                                              onPressed: uiCtrl.isObscureActive,
                                            ),
                                            hintText:
                                                'Confirmer le mot de passe',
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF667eea),
                                                  width: 2),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical:
                                                        isMobile ? 12 : 16),
                                          ),
                                          validator: (v) {
                                            if (v != passwordController.text) {
                                              return 'Les mots de passe ne correspondent pas';
                                            }
                                            return null;
                                          },
                                        )),
                                    SizedBox(height: isMobile ? 15 : 30),
                                    Obx(() {
                                      return Container(
                                        width: double.infinity,
                                        height: isMobile ? 45 : 50,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF667eea),
                                              Color(0xFF764ba2)
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF667eea)
                                                  .withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          onPressed: authCtrl.loading.value
                                              ? null
                                              : () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    await authCtrl.signup(
                                                      firstnameController.text
                                                          .trim(),
                                                      nameController.text
                                                          .trim(),
                                                      emailController.text
                                                          .trim(),
                                                      passwordController.text,
                                                    );
                                                    _formKey.currentState!
                                                        .reset();
                                                    firstnameController.clear();
                                                    nameController.clear();
                                                    emailController.clear();
                                                    passwordController.clear();
                                                    confirmPasswordController
                                                        .clear();
                                                    if (authCtrl
                                                            .adminUser.value !=
                                                        null) {
                                                      Get.to(() =>
                                                          const ProductsPage());
                                                    }
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            authCtrl.loading.value
                                                ? 'Chargement...'
                                                : 'Créer un compte',
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
                                      child: Text(
                                        'Vous avez déjà un compte? Connectez-vous',
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
                        SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom > 0
                                ? 20
                                : 40),
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
}
