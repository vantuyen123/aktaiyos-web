import 'package:aktaiyos_web_app/common/custom_size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  final ValueChanged<int> onItemTapped;

  const CustomDrawer({super.key, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 30),
              Text(
                'Menu',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFe1b44b),
                  fontSize: 24,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Container(color: Colors.grey, width: double.infinity, height: 1),
          Expanded(
            child: ListView(
              children: [
                _buildListTile(context, 'Đồ uống-Drink', 0),
                _buildListTile(context, 'Sashimi & Sushi', 11),
                _buildListTile(context, 'Salad & Soup', 24),
                _buildListTile(context, 'Món khai vị & Món xào', 26),
                _buildListTile(context, 'Bánh xèo Nhật & Món nướng', 36),
                _buildListTile(context, 'Món chiên', 44),
                _buildListTile(context, 'Cơm & Mì', 48),
                _buildListTile(context, 'Món Lẩu', 56),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, int indexImg) {
    return ListTile(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.openSans(
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontSize: menuFontSize(context),
        ),
      ),
      // selected: selectedListImage == indexImg,
      onTap: () {
        onItemTapped(indexImg);
        Navigator.pop(context);
      },
    );
  }
}
