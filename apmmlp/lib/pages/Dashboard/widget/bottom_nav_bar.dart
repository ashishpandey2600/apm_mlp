import 'package:flutter/material.dart';

BottomNavigationBarItem bottomNavigationBar(
    BuildContext context, IconData iconData, String label) {
  return BottomNavigationBarItem(icon: Icon(iconData), label: label);
}
