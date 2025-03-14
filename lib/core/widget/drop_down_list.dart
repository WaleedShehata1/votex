// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class DefaultDropdownFormField extends StatelessWidget {
  Object? value;
  Function(Object?)? onChanged;
  List<DropdownMenuItem<Object>>? items;
  String? Function(Object?)? validator;
  double? radius;
  double? fontSize;
  double? height;
  double? iconSize;
  double? width;
  Color colorBorder;
  Color? color;
  Color? fillColor;
  TextStyle? labelStyle;
  String? labelText;
  Widget? icon;

  DefaultDropdownFormField({
    super.key,
    this.onChanged,
    this.items,
    required this.labelText,
    this.labelStyle,
    required this.validator,
    this.radius,
    this.height,
    this.fontSize,
    this.iconSize,
    this.width,
    required this.colorBorder,
    this.color,
    this.fillColor,
    this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      icon: icon ?? const Icon(Icons.expand_more_sharp),
      iconSize: iconSize ?? 20,
      style: TextStyle(
          fontSize: fontSize ?? 14,
          color: Colors.black87,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        counterStyle: const TextStyle(
          fontSize: 13,
          overflow: TextOverflow.ellipsis,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        hintText: labelText,
        hintStyle: TextStyle(
            color: color ?? Colors.black,
            fontSize: fontSize ?? 16,
            fontWeight: FontWeight.w800),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(
            radius ?? 15,
          ),
        ),
        fillColor: fillColor ?? Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            radius ?? 15,
          ),
          borderSide: BorderSide(color: colorBorder, width: 2),
        ),
        errorMaxLines: 1,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 15),
          borderSide: const BorderSide(width: 2.0, color: Colors.red),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 15),
          borderSide: const BorderSide(width: 2.0, color: Colors.red),
        ),
      ),
      value: value,
      borderRadius: BorderRadius.circular(10),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
