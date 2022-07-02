import 'package:flutter/material.dart';

class Specialty {
  Text name;
  Icon icon;
  Color? color;
  String? description;
  bool? selected;
  Function(bool)? onSelected;

  Specialty({
    required this.name,
    required this.icon,
    this.selected,
    this.color,
    this.onSelected,
    this.description,
  });
}
