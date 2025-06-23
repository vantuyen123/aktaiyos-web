import 'package:aktaiyos_web_app/common/custom_size.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdown extends StatelessWidget {
  final int selectedListImage;
  final ValueChanged<int> onItemTapped;

  const CustomDropdown({
    super.key,
    required this.selectedListImage,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'value': 0, 'label': 'Đồ uống-Drink'},
      {'value': 9, 'label': 'Salad & Soup'},
      {'value': 14, 'label': 'Sashimi & Sushi'},
      {'value': 29, 'label': 'Món khai vị & Món xào'},
      {'value': 37, 'label': 'Bánh xào Nhật & Món nướng'},
      {'value': 45, 'label': 'Món chiên'},
      {'value': 48, 'label': 'Cơm & Mì'},
      {'value': 56, 'label': 'Món Lẩu'},
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
