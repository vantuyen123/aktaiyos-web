import 'dart:ui';

import 'package:aktaiyos_web_app/common/custom_size.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdown extends StatelessWidget {
  final int selectedListImage;
  final ValueChanged<int> onItemTapped;

  const CustomDropdown({
    Key? key,
    required this.selectedListImage,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'value': 0, 'label': 'Drink'},
      {'value': 6, 'label': 'Dessert'},
      {'value': 7, 'label': 'Wine'},
      {'value': 14, 'label': 'Sashimi'},
      {'value': 22, 'label': 'SuShi'},
      {'value': 29, 'label': 'Salad'},
      {'value': 31, 'label': 'Otsumami'},
      {'value': 38, 'label': 'Itame'},
      {'value': 41, 'label': 'Okonomi Yaki'},
      {'value': 42, 'label': 'Grill'},
      {'value': 49, 'label': 'Fried Item'},
      {'value': 52, 'label': 'Hotpot'},
      {'value': 54, 'label': 'Rice'},
      {'value': 59, 'label': 'Noodles'},
      {'value': 63, 'label': 'Soup'},
      {'value': 65, 'label': 'Set Lunch'},
    ];

    return DropdownButton2<int>(
      value: null,
      menuItemStyleData: const MenuItemStyleData(),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 400,
        decoration: BoxDecoration(
          color: const Color(0xFF272727).withOpacity(0.5),
        ),
      ),
      hint: Text(
        'Menu',
        style: GoogleFonts.openSans(
          fontWeight: FontWeight.w400,
          color: const Color(0xFFe1b44b),
          fontSize: menuFontSize(context),
        ),
      ),
      items: menuItems.map((item) {
        return DropdownMenuItem<int>(
          value: item['value'],
          child: Text(
            item['label'],
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w400,
              color: const Color(0xFFe1b44b),
              fontSize: menuFontSize(context),
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onItemTapped(value);
        }
      },
    );
  }
}
