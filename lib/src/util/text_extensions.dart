import 'package:flutter/material.dart';

extension TextExtension on Text {
  Text get bold => Text(data!, style: style?.copyWith(fontWeight: FontWeight.bold));
  Text get italic => Text(data!, style: style?.copyWith(fontStyle: FontStyle.italic));

  Text withColor(Color color) => Text(data!, style: style?.copyWith(color: color));
  Text sizeOf(double size) => Text(data!, style: style?.copyWith(fontSize: size));
}
