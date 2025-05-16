import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:migo/models/authManager.dart';
import 'package:migo/view/auth/login.dart';
import 'package:migo/view/responsive.dart';

class TopAppBar extends StatefulWidget {
  const TopAppBar({Key? key, required this.pageName}) : super(key: key);

  final String pageName;
  @override
  State<TopAppBar> createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  // AuthenticationManager _authManager = Get.find();

  // Variable pour gérer l'état du hover
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    String? chosenDropdownOption;
    var profileDropdown = DropdownButton(
      hint: _nameAndProfilePicture(
        context,
        "Hayat",
        "./assets/avatar.png",
      ),
      elevation: 8,
      value: chosenDropdownOption,
      icon: const Icon(
        Iconsax.arrow_circle_down,
        color: Color(0xFF7717E8),
      ),
      borderRadius: BorderRadius.circular(15),
      items: [
        DropdownMenuItem(
          value: "Logout",
          child: Row(
            children: const [
              Icon(
                Iconsax.logout,
                size: 20,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Déconnexion",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      onChanged: (value) {
        if (value == "Logout") {
          Get.find<AuthenticationManager>().logOut();
          Get.to(() => const LoginView());
        }
      },
    );

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Couleur de l'ombre
            spreadRadius: 0, // Expansion de l'ombre
            blurRadius: 3, // Flou de l'ombre
            offset: Offset(2, 4), // Décale l'ombre vers le bas (x, y)
          ),
        ],
      ),
      // margin: EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(bottom: 12, right: 16, left: 16),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 112,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              widget.pageName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                // color: Color(0xFFFFFFFF),
                fontSize: Responsive.isMobile(context) ? 24 : 36,
              ),
            ),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  isHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHovered = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isHovered
                      ? const Color.fromARGB(56, 0, 0, 0)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButtonHideUnderline(
                  child: profileDropdown,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nameAndProfilePicture(
      BuildContext context, String username, String imageUrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Visibility(
          visible: !Responsive.isMobile(context),
          child: CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            username,
            style: const TextStyle(
              // color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
