import 'package:flutter/material.dart';

class ActivityChip extends ChoiceChip {
  @override
  Widget label;
  @override
  bool selected;
  ActivityChip({required this.label, required this.selected, Key? key})
      : super(label: label, selected: selected);
}
