import 'package:aktaiyos_web_app/common/custom_size.dart';
import 'package:aktaiyos_web_app/common/image_list.dart';
import 'package:aktaiyos_web_app/config/firebase_config.dart';
import 'package:aktaiyos_web_app/pages/widgets/header.dart';
import 'package:aktaiyos_web_app/widgets/drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;

  final List<GlobalKey> _keys = [];

  bool isTabletOrDesktop = false;

  late Future<Map<String, List<String>>> imagesFuture;

  @override
  void initState() {
    super.initState();
    imagesFuture = getAllImages();
    _scrollController = ScrollController();
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
        body: FutureBuilder(
          future: imagesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No images found'));
            } else {
              final Map<String, List<String>> imagesMap = snapshot.data!;

              final List<String> allUrls = [];

              for (final folder in order) {
                final List<String> urls = imagesMap[folder] ?? [];
                allUrls.addAll(urls);
              }
              _keys.addAll(
                List.generate(allUrls.length, (index) => GlobalKey()),
              );
              print('allUrls ${allUrls}');
              return Scrollbar(
                controller: _scrollController,
                thickness: 12.0,
                radius: const Radius.circular(8.0),
                thumbVisibility: true,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: horizontalMargin(context),
                  ),
                  decoration: const BoxDecoration(color: Color(0xFF272727)),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: _scrollController,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: allUrls.length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: allUrls[index],
                              fit: BoxFit.cover,
                              key: _keys[index],
                              cacheKey: allUrls[index],
                              errorWidget: (context, url, error) =>
                                  const Center(
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                            );
                          },
                        ),
                      ),
                      HeaderWidget(
                        onClickLogo: () {},
                        onSelectCategory: _onItemTapped,
                        isTabletOrDesktop: isTabletOrDesktop,
                        index: 0,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
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
