import 'package:aktaiyos_web_app/common/app_path.dart';
import 'package:aktaiyos_web_app/common/custom_size.dart';
import 'package:aktaiyos_web_app/common/image_list.dart';
import 'package:aktaiyos_web_app/config/firebase_config.dart';
import 'package:aktaiyos_web_app/pages/widgets/header.dart';
import 'package:aktaiyos_web_app/widgets/drawer.dart';
import 'package:flutter/material.dart';

class HomePageWeb extends StatefulWidget {
  const HomePageWeb({super.key});

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  final List<GlobalKey> _keys = [];

  bool isTabletOrDesktop = false;
  final ScrollController _scrollController = ScrollController();

  late Future<Map<String, List<String>>> imagesFuture;

  @override
  void initState() {
    super.initState();
    _keys.addAll(List.generate(imageUrlsWeb.length, (index) => GlobalKey()));
  }

  void _onItemTapped(int index) {
    _scrollToIndex(index);
  }

  void _scrollToIndex(int index) {
    if (index < _keys.length) {
      final context = _keys[index].currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;

    isTabletOrDesktop = screenWidth > 800;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF101010),
        drawer: CustomDrawer(onItemTapped: _onItemTapped),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin(context)),
          decoration: const BoxDecoration(color: Color(0xFF272727)),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: imageUrlsWeb.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      key: _keys[index],
                      imageUrlsWeb[index],
                      filterQuality: FilterQuality.low,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    );
                  },
                ),
              ),
              HeaderWidget(
                onClickLogo: () => _onItemTapped(0),
                onSelectCategory: _onItemTapped,
                isTabletOrDesktop: isTabletOrDesktop,
                index: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
