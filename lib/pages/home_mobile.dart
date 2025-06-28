import 'dart:io';

import 'package:aktaiyos_web_app/common/custom_size.dart';
import 'package:aktaiyos_web_app/config/firebase_config.dart';
import 'package:aktaiyos_web_app/pages/widgets/header.dart';
import 'package:aktaiyos_web_app/widgets/drawer.dart';
import 'package:flutter/material.dart';

class HomePageMobile extends StatefulWidget {
  const HomePageMobile({super.key});

  @override
  State<HomePageMobile> createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  late ScrollController _scrollController;

  final List<GlobalKey> _keys = [];

  bool isTabletOrDesktop = false;
  List<File> cachedImages = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    initData();
  }

  Future<void> initData() async {
    cachedImages = await getCachedImages(listAllImageFirebase ?? []);
    _keys.addAll(List.generate(cachedImages.length, (index) => GlobalKey()));
    setState(() {});
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
    print('1111 $cachedImages');
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF101010),
        drawer: CustomDrawer(onItemTapped: _onItemTapped),
        body: Scrollbar(
          controller: _scrollController,
          thickness: 12.0,
          radius: const Radius.circular(8.0),
          thumbVisibility: true,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin(context)),
            decoration: const BoxDecoration(color: Color(0xFF272727)),
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cachedImages.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        key: _keys[index],
                        child: Image.file(
                          cachedImages[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                ),
                HeaderWidget(
                  onClickLogo: () {},
                  onSelectCategory: _onItemTapped,
                  isTabletOrDesktop: false,
                  index: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
