import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ConsentItem extends StatelessWidget {
  const ConsentItem({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Palette.primary,
            height: 24,
            width: 24,
          ),
          Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Palette.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 0.08,
                  letterSpacing: -0.45,
                ),
              ),
              Text(description)
            ],
          )
        ],
      ),
    );
  }
}
