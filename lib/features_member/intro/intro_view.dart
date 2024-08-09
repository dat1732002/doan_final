import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class TextWithOutline extends StatelessWidget {
  final String text;
  final TextStyle textStyle;

  TextWithOutline({required this.text, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Viền đen
        Text(
          text,
          style: textStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = Colors.black,
          ),
        ),
        // Chữ trắng
        Text(
          text,
          style: textStyle.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class IntroView extends StatefulWidget {
  IntroView({Key? key}) : super(key: key);

  @override
  State<IntroView> createState() => _SlideBannerState();
}

class _SlideBannerState extends State<IntroView> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<String> image = [
    "assets/images/banner_ADIDAS.png",
    "assets/images/banner_CONVERSE.png",
    "assets/images/banner1.png",
    "assets/images/banner_new_balance.png",
    "assets/images/banner_jordan.png",
  ];
  List<String> nike = [
    "assets/banner/nike1.png",
    "assets/banner/nike2.png",
    "assets/banner/nike3.png",
    "assets/banner/nike4.png",
  ];
  List<String> adidas = [
    "assets/banner/adidas1.png",
    "assets/banner/adidas2.png",
    "assets/banner/adidas3.png",
    "assets/banner/adidas4.png",
  ];
  List<String> newBalance = [
    "assets/banner/new_balance1.png",
    "assets/banner/new_balance2.png",
    "assets/banner/new_balance3.png",
  ];
  List<String> puma = [
    "assets/banner/puma1.png",
    "assets/banner/puma2.png",
    "assets/banner/puma3.png",
    "assets/banner/puma4.png",
    "assets/banner/puma5.png",
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              'assets/banner/background_app.png',
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                    child: Row(
                      children: [
                        TextWithOutline(
                          text: 'TD ',
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          'Sneakers',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        ),
                        Image.asset(
                          'assets/images/icon.png',
                          height: 35,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width,
                    height: 175,
                    child: CarouselSlider(
                      items: image
                          .map((item) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(item),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ))
                          .toList(),
                      carouselController: _controller,
                      options: CarouselOptions(
                        height: double.infinity,
                        autoPlay: true,
                        viewportFraction: 1,
                        aspectRatio: 16 / 9,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.black,
                    width: width,
                    child: Row(
                      children: [
                        const Text(
                          ' Nike - ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        const Text(
                          '"Just Do It"',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width,
                    height: 175,
                    padding: EdgeInsets.all(10),
                    child: CarouselSlider(
                      items: nike
                          .map((item) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(item),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ))
                          .toList(),
                      carouselController: _controller,
                      options: CarouselOptions(
                        scrollDirection: Axis.vertical,
                        height: double.infinity,
                        autoPlay: true,
                        viewportFraction: 1,
                        aspectRatio: 16 / 9,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.black,
                    width: width,
                    child: Row(
                      children: [
                        const Text(
                          ' Adidas - ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        const Text(
                          '"Impossible Is Nothing"',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width,
                    height: 175,
                    padding: EdgeInsets.all(10),
                    child: CarouselSlider(
                      items: adidas
                          .map((item) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(item),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ))
                          .toList(),
                      carouselController: _controller,
                      options: CarouselOptions(
                        height: double.infinity,
                        autoPlay: true,
                        viewportFraction: 1,
                        aspectRatio: 16 / 9,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.black,
                    width: width,
                    child: Row(
                      children: [
                        const Text(
                          ' New Balance - ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        const Text(
                          '"Always On The Run"',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width,
                    height: 175,
                    padding: EdgeInsets.all(10),
                    child: CarouselSlider(
                      items: newBalance
                          .map((item) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(item),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ))
                          .toList(),
                      carouselController: _controller,
                      options: CarouselOptions(
                        height: double.infinity,
                        autoPlay: false,
                        viewportFraction: 1,
                        aspectRatio: 16 / 9,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.black,
                    width: width,
                    child: Row(
                      children: [
                        const Text(
                          ' Puma - ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        const Text(
                          '"Forever Faster"',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width,
                    height: 175,
                    padding: EdgeInsets.all(10),
                    child: CarouselSlider(
                      items: puma
                          .map((item) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(item),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ))
                          .toList(),
                      carouselController: _controller,
                      options: CarouselOptions(
                        height: double.infinity,
                        autoPlay: true,
                        viewportFraction: 0.5,
                        aspectRatio: 16 / 9,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black26,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thông tin liên hệ:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                Text(
                                  ' Địa chỉ: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: Text(
                                'Số 94 Trần Duy Hưng, phường Trung Hoà, Thành phố Hà Nội',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                softWrap:
                                    true, // Cho phép text wrap khi cần thiết
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 13,
                                ),
                            Expanded(
                              child: Text(
                                ' SDT: 0987.661.226',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                softWrap: true, // Cho phép text wrap khi cần thiết
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.white,
                              size: 13,
                            ),
                            Expanded(
                              child: Text(
                                ' Email: nguyentiendat@gmail.com',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                ),
                                softWrap: true, // Cho phép text wrap khi cần thiết
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
