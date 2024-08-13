import 'package:flutter/material.dart';

class ColorOption extends StatelessWidget {
  final Color color;
  final Function onTap;
  final bool selected;

  const ColorOption(
      {Key? key,
      required this.color,
      required this.onTap,
      required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                  color: selected ? Colors.white : Colors.transparent,
                  spreadRadius: 5,
                  blurRadius: 5)
            ],
            border: Border.all(
                color: selected ? Colors.white : Colors.transparent, width: 2)),
      ),
    );
  }
}
