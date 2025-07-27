import 'package:aktaiyos_web_app/common/app_path.dart';
import 'package:aktaiyos_web_app/widgets/dropdown.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.onClickLogo,
    required this.onSelectCategory,
    required this.isTabletOrDesktop,
    required this.index,
  });

  final Function() onClickLogo;
  final Function(int index) onSelectCategory;
  final bool isTabletOrDesktop;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2f2f2f).withOpacity(0.7),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onClickLogo,
            child: const SizedBox(
              width: 50,
              height: 50,
              child: CircleAvatar(backgroundImage: AssetImage(AppPath.logo)),
            ),
          ),
          const SizedBox(width: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFFe1b44b)),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
