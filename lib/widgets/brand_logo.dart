import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size = 48,
    this.padding = 8,
  });

  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Lumen Finance logo',
      image: true,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(padding),
        decoration: const BoxDecoration(
          color: Color(0xFF29423D),
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          'assets/images/lumen_logo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
