// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:migo/controller/simple_ui_controller.dart';
// import 'package:migo/view/auth/login.dart';
// import 'package:migo/view/products/productpage.dart';
// import 'package:migo/view/responsive.dart';
// import 'package:migo/widgets/buttons.dart';

// class Signup extends StatefulWidget {
//   const Signup({Key? key}) : super(key: key);

//   @override
//   State<Signup> createState() => _SignupState();
// }

// class _SignupState extends State<Signup> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController storeIDController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     usernameController.dispose();
//     storeIDController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     SimpleUIController simpleUIController = Get.put(SimpleUIController());
//     return GestureDetector(
//       onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: SingleChildScrollView(
//           child: Responsive(
//             desktop: _buildLargeScreen(size, simpleUIController),
//             mobile: _buildSmallScreen(size, simpleUIController),
//           ),
//         ),
//       ),
//     );
//   }

//   /// For large screens
//   Widget _buildLargeScreen(
//     Size size,
//     SimpleUIController simpleUIController,
//   ) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildMainBody(
//             size,
//             simpleUIController,
//           ),
//         ),
//         Expanded(
//           child: Image.asset(
//             'assets/side_image.png',
//             height: size.height * 1,
//             width: double.infinity,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ],
//     );
//   }

//   /// For Small screens
//   Widget _buildSmallScreen(
//     Size size,
//     SimpleUIController simpleUIController,
//   ) {
//     return Center(
//       child: _buildMainBody(
//         size,
//         simpleUIController,
//       ),
//     );
//   }

//   /// Main Body
//   Widget _buildMainBody(
//     Size size,
//     SimpleUIController simpleUIController,
//   ) {
//     return SafeArea(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(24),
//             child: Image.asset(
//               'assets/migo_logo.png',
//               width: size.width / 2,
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0),
//             child: Text(
//               'Lets create an account😀',
//               style: TextStyle(
//                 fontSize: size.height * 0.030,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: size.height * 0.03,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0, right: 20),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   /// username or Gmail
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       prefixIcon: Icon(Iconsax.user),
//                       hintText: 'Username',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(8)),
//                       ),
//                     ),
//                     controller: usernameController,

//                     // The validator receives the text that the user has entered.
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter username';
//                       } else if (value.length < 4) {
//                         return 'at least enter 4 characters';
//                       } else if (value.length > 13) {
//                         return 'maximum character is 13';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   /// StoreID
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       prefixIcon: Icon(Iconsax.shop),
//                       hintText: 'StoreID',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(8)),
//                       ),
//                     ),
//                     controller: storeIDController,

//                     // The validator receives the text that the user has entered.
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter Store ID';
//                       } else if (value.length < 4) {
//                         return 'at least enter 4 characters';
//                       } else if (value.length > 13) {
//                         return 'maximum character is 13';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   /// password
//                   Obx(
//                     () => TextFormField(
//                       controller: passwordController,
//                       obscureText: simpleUIController.isObscure.value,
//                       decoration: InputDecoration(
//                         prefixIcon: const Icon(Iconsax.lock),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             simpleUIController.isObscure.value
//                                 ? Iconsax.eye
//                                 : Iconsax.eye_slash,
//                           ),
//                           onPressed: () {
//                             simpleUIController.isObscureActive();
//                           },
//                         ),
//                         hintText: 'Password',
//                         border: const OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8)),
//                         ),
//                       ),
//                       // The validator receives the text that the user has entered.
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter some text';
//                         } else if (value.length < 7) {
//                           return 'at least enter 6 characters';
//                         } else if (value.length > 13) {
//                           return 'maximum character is 13';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   /// password
//                   Obx(
//                     () => TextFormField(
//                       controller: confirmPasswordController,
//                       obscureText: simpleUIController.isObscure.value,
//                       decoration: InputDecoration(
//                         prefixIcon: const Icon(Iconsax.lock),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             simpleUIController.isObscure.value
//                                 ? Iconsax.eye
//                                 : Iconsax.eye_slash,
//                           ),
//                           onPressed: () {
//                             simpleUIController.isObscureActive();
//                           },
//                         ),
//                         hintText: 'Confirm Password',
//                         border: const OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8)),
//                         ),
//                       ),
//                       // The validator receives the text that the user has entered.
//                       validator: (value) {
//                         if (value != passwordController.text) {
//                           return 'The password must be same';
//                         }
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter some text';
//                         } else if (value.length < 7) {
//                           return 'at least enter 6 characters';
//                         } else if (value.length > 13) {
//                           return 'maximum character is 13';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   /// Login Button
//                   PrimaryButton(
//                     vertPad: 20,
//                     buttonTitle: "Create Admin account",
//                     onPressed: () {
//                       // Validate returns true if the form is valid, or false otherwise.
//                       if (_formKey.currentState!.validate()) {
//                         // ... Navigate To your Home Page
//                         Get.to(() => const ProductsPage());
//                       }
//                     },
//                   ),
//                   SizedBox(
//                     height: size.height * 0.03,
//                   ),

//                   /// Navigate To Login Screen
//                   GestureDetector(
//                     onTap: () {
//                       usernameController.clear();
//                       passwordController.clear();
//                       confirmPasswordController.clear();
//                       storeIDController.clear();
//                       _formKey.currentState?.reset();
//                       simpleUIController.isObscure.value = true;
//                       Get.to(() => const LoginView());
//                     },
//                     child: RichText(
//                       text: TextSpan(
//                         text: 'Already have an account?',
//                         children: [
//                           TextSpan(
//                               text: " Log in",
//                               style: TextStyle(
//                                   color: Theme.of(context).primaryColor)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:migo/controller/auth_controller.dart';
import 'package:migo/controller/simple_ui_controller.dart';
import 'package:migo/view/auth/login.dart';
import 'package:migo/widgets/buttons.dart';
import 'package:migo/view/products/productpage.dart';

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
                                    if (authCtrl.user.value != null) {
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
