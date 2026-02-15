import 'package:flutter/material.dart';

class IconBox extends StatelessWidget {
  final IconData icon;
  final double height;
  final double? width;
  final double? iconSize;
  final void Function()? onTap;

  const IconBox({
    super.key,
    required this.icon,
    required this.height,
    this.width,
    this.iconSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 240, 242, 245),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        splashColor: Colors.amber.withAlpha(60),
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: width ?? height,
          height: height,
          child: Icon(icon, size: iconSize ?? height / 2),
        ),
      ),
    );
  }
}
