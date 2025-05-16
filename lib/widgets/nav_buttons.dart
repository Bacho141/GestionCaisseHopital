import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  const NavigationButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.tooltipMessage,
    this.isActive = false,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;
  final bool isActive;
  final String tooltipMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        hoverColor: Color.fromARGB(60, 124, 35, 226),
        tooltip: tooltipMessage,
        icon: Icon(
          icon,
          size: 30,
          color: isActive ? const Color(0xFF7717E8) : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }
}
