import 'package:aktaiyos_web_app/common/cloudinary.dart';
import 'package:aktaiyos_web_app/common/image_list.dart';
import 'package:aktaiyos_web_app/pages/widgets/header.dart';
import 'package:aktaiyos_web_app/widgets/drawer.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _keys = [];
  bool isTabletOrDesktop = false;
  List<String> listImage = listImagesDrink;
  final cloudinary = CloudinaryService().cloudinary;

  @override
  void initState() {
    super.initState();
    _keys.addAll(List.generate(listImageAll.length, (index) => GlobalKey()));
  }

  void _onItemTapped(int index) {
    _scrollToIndex(index);
    print('index ${index}, value: ${listImage[index]}');
    // setState(() {
    //   listImage = index;
    // });
  }

  void _scrollToIndex(int index) {
    if (index < _keys.length) {
      Scrollable.ensureVisible(
        _keys[index].currentContext!,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    isTabletOrDesktop = screenWidth > 800;
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      drawer: CustomDrawer(onItemTapped: (int value) {}),
      body: Stack(
        children: <Widget>[
          // SingleChildScrollView(
          //   controller: _scrollController,
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemCount: listImage.length,
          //     itemBuilder: (_, index) {
          //       String item = listImage[index];
          //       print('index ${index}, value: ${listImage[index]}');
          //       return Container(
          //         color: Colors.blue,
          //         child: Image.asset(item, fit: BoxFit.fill, key: _keys[index]),
          //       );
          //     },
          //   ),
          // ),
          CldImageWidget(
            cloudinary: cloudinary,
            publicId: "1",
            fit: BoxFit.scaleDown,
            width: double.infinity,
          ),
          HeaderWidget(
            onClickLogo: () {},
            onSelectCategory: (int id) {},
            isTabletOrDesktop: isTabletOrDesktop,
            index: 0,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
