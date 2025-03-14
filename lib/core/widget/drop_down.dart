// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultDropdown extends StatelessWidget {
  Object? value;
  Function(Object?)? onChanged;
  List<DropdownMenuItem<Object>>? items;
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

  DefaultDropdown({
    super.key,
    this.onChanged,
    this.items,
    required this.labelText,
    this.labelStyle,
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
    return DropdownButton(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 2, vertical: 1),
      icon: icon ?? const Icon(Icons.expand_more_sharp),
      iconSize: iconSize ?? 20,
      menuWidth: 120.w,
      isExpanded: true,
      style: TextStyle(
          fontSize: fontSize ?? 12,
          color: Colors.black87,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w400),
      value: value,
      borderRadius: BorderRadius.circular(10),
      items: items,
      onChanged: onChanged,
    );
  }
}
