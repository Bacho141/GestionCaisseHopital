import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:migo/controller/auth_controller.dart';
import 'package:migo/controller/simple_ui_controller.dart';
import 'package:migo/view/auth/login.dart';
import 'package:migo/widgets/buttons.dart';
import 'package:migo/view/servicemedical/servicemedical_page.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Instanciation des controllers GetX
    final SimpleUIController uiCtrl = Get.put(SimpleUIController());
    final AuthController authCtrl = Get.put(AuthController());
    

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    'assets/migo_logo.png',
                    width: size.width * 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Let’s create an account 😀',
                  style: TextStyle(fontSize: size.height * 0.03),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.user),
                          hintText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter your name';
                          } else if (v.length < 4) {
                            return 'At least 4 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.sms),
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter your email';
                          } else if (!GetUtils.isEmail(v)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password
                      Obx(() => TextFormField(
                            controller: passwordController,
                            obscureText: uiCtrl.isObscure.value,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Iconsax.lock),
                              suffixIcon: IconButton(
                                icon: Icon(uiCtrl.isObscure.value
                                    ? Iconsax.eye
                                    : Iconsax.eye_slash),
                                onPressed: uiCtrl.isObscureActive,
                              ),
                              hintText: 'Password',
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please enter a password';
                              } else if (v.length < 6) {
                                return 'At least 6 characters';
                              }
                              return null;
                            },
                          )),
                      const SizedBox(height: 16),

                      // Confirm Password
                      Obx(() => TextFormField(
                            controller: confirmPasswordController,
                            obscureText: uiCtrl.isObscure.value,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Iconsax.lock),
                              suffixIcon: IconButton(
                                icon: Icon(uiCtrl.isObscure.value
                                    ? Iconsax.eye
                                    : Iconsax.eye_slash),
                                onPressed: uiCtrl.isObscureActive,
                              ),
                              hintText: 'Confirm Password',
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            validator: (v) {
                              if (v != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          )),
                      const SizedBox(height: 24),

                      // Sign Up Button
                      Obx(() {
                        return PrimaryButton(
                          buttonTitle: authCtrl.loading.value
                              ? 'Loading...'
                              : 'Sign Up',
                          onPressed: authCtrl.loading.value
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    await authCtrl.signup(
                                      nameController.text.trim(),
                                      emailController.text.trim(),
                                      passwordController.text,
                                    );
                                    _formKey.currentState!.reset();
                                    emailController.clear();
                                    passwordController.clear();
                                    confirmPasswordController.clear();
                                    if (authCtrl.adminUser.value != null) {
                                      Get.to(() => const ProductsPage());
                                    }
                                  }
                                },
                        );
                      }),
                      const SizedBox(height: 16),

                      // Navigate to Login
                      GestureDetector(
                        onTap: () {
                          _formKey.currentState?.reset();
                          nameController.clear();
                          emailController.clear();
                          passwordController.clear();
                          confirmPasswordController.clear();
                          uiCtrl.isObscure.value = true;
                          Get.to(() => const LoginView());
                        },
                        child: Text(
                          'Already have an account? Log in',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
