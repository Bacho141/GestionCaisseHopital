import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:migo/controller/simple_ui_controller.dart';
// import 'package:migo/controller/login_controller.dart';
import 'package:migo/controller/auth_controller.dart';
import 'package:migo/view/home/home_dashboard.dart';
import 'package:migo/view/auth/signup.dart';
import 'package:migo/view/responsive.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // final LoginViewModel _viewModel = Get.put(LoginViewModel());
  final AuthController _authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
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
          child: _buildMainBody(size, simpleUIController),
        ),
        Expanded(
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
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
          ),
          child: IntrinsicHeight(
            child: _buildMainBody(size, simpleUIController),
          ),
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

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? size.width * 0.1 : 20.0,
        vertical: isMobile ? 20.0 : 1.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ajustement dynamique basé sur la présence du clavier
          SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom > 0
                  ? 10
                  : (isMobile ? 40 : 60)),

          // Logo et titre
          Center(
            child: Image.asset(
              'assets/migo_logo.png',
              width: isDesktop ? size.width / 6 : size.width / 1.5,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Bienvenue 😊',
            style: TextStyle(
              fontSize: isMobile ? 24 : size.height * 0.035,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Formulaire dans un SizedBox avec ombre
          SizedBox(
            width: isDesktop ? size.width * 0.35 : size.width * 0.9,
            child: Container(
              padding: EdgeInsets.all(isMobile ? 20.0 : 30.0),
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
                    // Email
                    TextFormField(
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Iconsax.sms, color: Color(0xFF667eea)),
                        hintText: 'Email',
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir votre email';
                        } else if (!GetUtils.isEmail(value)) {
                          return 'Entrez un email valide';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: isMobile ? 15 : 20),

                    // Password
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
                              onPressed: () {
                                simpleUIController.isObscureActive();
                              },
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
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir un mot de passe';
                            } else if (value.length < 6) {
                              return 'Au moins 6 caractères';
                            }
                            return null;
                          },
                        )),
                    SizedBox(height: isMobile ? 20 : 30),

                    // Login Button
                    Obx(() {
                      final loading = _authController.loading.value;
                      return Container(
                        width: double.infinity,
                        height: 50,
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
                                    await _authController.loginAdmin(
                                        usernameController.text,
                                        passwordController.text);
                                    _formKey.currentState!.reset();
                                    passwordController.clear();
                                    if (_authController.adminUser.value !=
                                        null) {
                                      Get.offAll(() => const DashboardPage());
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: isMobile ? 15 : 20),

                    // Navigate to Signup
                    GestureDetector(
                      onTap: () {
                        usernameController.clear();
                        passwordController.clear();
                        _formKey.currentState?.reset();
                        simpleUIController.isObscure.value = true;
                        Get.to(() => const Signup());
                      },
                      child: Text(
                        'Nouveau propriétaire? Créer un compte admin',
                        style: TextStyle(
                          color: const Color(0xFF667eea),
                          fontSize: 14,
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
          // Espacement en bas qui s'ajuste selon la présence du clavier
          SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom > 0
                  ? 20
                  : (isMobile ? 20 : 40)),
        ],
      ),
    );
  }
}
