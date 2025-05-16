import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Ombre éparpillée
        Container(
          height: 3,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(152, 121, 23, 232),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
        // Trait visible
        const Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Divider(
              color: Colors.grey,
              thickness: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}