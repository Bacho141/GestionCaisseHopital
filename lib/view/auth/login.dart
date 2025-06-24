import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:migo/controller/simple_ui_controller.dart';
// import 'package:migo/controller/login_controller.dart';
import 'package:migo/controller/auth_controller.dart';
import 'package:migo/view/home/home_dashboard.dart';
import 'package:migo/view/auth/signup.dart';
import 'package:migo/view/responsive.dart';
import 'package:migo/widgets/buttons.dart';

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

  /// For large screens
  Widget _buildLargeScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildMainBody(
            size,
            simpleUIController,
          ),
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
    return Center(
      child: _buildMainBody(
        size,
        simpleUIController,
      ),
    );
  }

  /// Main Body
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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: size.height * 0.030,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// username or Gmail
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.user),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    controller: usernameController,

                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      } else if (value.length < 4) {
                        return 'at least enter 4 characters';
                      } else if (value.length > 40) {
                        return 'maximum character is 13';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  /// password
                  Obx(
                    () => TextFormField(
                      controller: passwordController,
                      obscureText: simpleUIController.isObscure.value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            simpleUIController.isObscure.value
                                ? Iconsax.eye
                                : Iconsax.eye_slash,
                          ),
                          onPressed: () {
                            simpleUIController.isObscureActive();
                          },
                        ),
                        hintText: 'Password',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else if (value.length < 7) {
                          return 'at least enter 6 characters';
                        } else if (value.length > 17) {
                          return 'maximum character is 17';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final loading = _authController.loading.value;
                    print("LOGINVALID 1: ${loading}");
                    return PrimaryButton(
                      vertPad: 20,
                      // Affiche un indicateur si en cours
                      buttonTitle: loading ? 'Loading...' : 'Login',
                      onPressed: loading
                          ? null
                          : () async {
                            print("LOGINVALID 2: ${loading}");
                              if (_formKey.currentState!.validate()) {
                                await _authController.loginAdmin(
                                    usernameController.text,
                                    passwordController.text);
                                  // print("LOGINVALID : ${_authController.user.value}");
                                _formKey.currentState!.reset();
                                // usernameController.clear();
                                passwordController.clear();
                                // Si authentifié, va vers l'écran principal
                                print("LOGINVALID 3: ${_authController.adminUser}");
                                if (_authController.adminUser.value != null) {
                                  // Get.to(() => const DashboardPage());
                                  Get.offAll(() => const DashboardPage());
                                }
                              }
                            },
                    );
                  }),
                  SizedBox(
                    height: size.height * 0.03,
                  ),

                  /// Navigate To Login Screen
                  GestureDetector(
                    onTap: () {
                      usernameController.clear();
                      passwordController.clear();
                      _formKey.currentState?.reset();
                      simpleUIController.isObscure.value = true;
                      Get.to(() => const Signup());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'New store owner?',
                        children: [
                          TextSpan(
                              text: " Create admin account",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
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
