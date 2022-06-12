// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:consuming_api/views/Login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/caroussel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dropdownValue = 'Entrega a domicilio';
  String dropdownValue2 = 'Calle 10 9';
  var images = [
    {"image": "assets/images/1.png", "name": "Servicios"},
    {"image": "assets/images/2.png", "name": "Cuidados"},
    {"image": "assets/images/3.png", "name": "Veterinarios"},
    {"image": "assets/images/4.png", "name": "Médicos"},
  ];

  var images_desc = [
    "assets/images/1.png",
    "assets/images/2.png",
    "assets/images/3.png",
  ];

  var gridImages = [
    "assets/images/B1.png",
    "assets/images/B2.png",
    "assets/images/B3.png",
    "assets/images/B4.png",
    "assets/images/B1.png",
    "assets/images/B2.png",
    "assets/images/B3.png",
    "assets/images/B4.png",
  ];

  Timer? timer;
  // late List<dynamic> dataResponse;
  // int viewPort = 2;
  int pageInitial = 0;
  late PageController _pControler = PageController(initialPage: 0);

  final List<CarousselImage> _carousselImages = [];

  Future<List<CarousselImage>> postCaroussel() async {
    final response = await http.post(
        Uri.parse('http://desarrollovan-tis.dedyn.io:4030/GetImagesCarousel'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idChannel": "1"}));
    List<CarousselImage> datos = [];
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body)['dtoImageCarousels'];
      for (var jsonData in jsonResponse) {
        datos.add(CarousselImage.fromJson(jsonData));
        print('JsonData -> ' + jsonData.toString());
      }
    } else {
      print('Error -> ' + response.statusCode.toString());
    }
    return datos;
  }

  @override
  void initState() {
    postCaroussel().then((value) {
      setState(() {
        _carousselImages.addAll(value);
      });
    });
    _pControler = PageController(viewportFraction: 1, initialPage: 0);
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (pageInitial == _carousselImages.length) {
        pageInitial = 0;
      } else {
        pageInitial++;
      }
      _pControler.animateToPage(pageInitial,
          duration: const Duration(milliseconds: 600), curve: Curves.easeIn);
    });

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    _pControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tienda',
            ),
            Image.asset(
              'assets/images/2.png',
              width: 60,
              height: 60,
              // color: Colors.white,
            ),
          ],
        ),
        backgroundColor: const Color(0xff4f1581),
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: SafeArea(
        child: Container(
          // color: Colors.grey[200],
          height: double.infinity,
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Hola Juan,',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Image.asset("assets/images/2.png",
                            width: 60, height: 60),
                        //
                        // _comboBox()
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/images/2.png",
                                width: 40, height: 50),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                const Text('Entregar ahora'),
                                _comboBox2(),
                              ],
                            )
                          ],
                        ),
                        _comboBox()
                      ],
                    )
                  ],
                ),
              ),
              _scrollHoriontal(),
              _sliderImage(),
              // Expanded(child: _pageChanged()),

              _gridImages(context)
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff4f1581),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: 'Logout',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Login()));
          }
        },
      ),
    );
  }

  Container _comboBox2() {
    return Container(
      width: 90,
      height: 30,
      alignment: AlignmentDirectional.center,
      // color: Colors.grey[200],
      child: DropdownButton<String>(
        // alignment: AlignmentDirectional.centerEnd,
        value: dropdownValue2,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 0,
        style: const TextStyle(color: Colors.black54),
        underline: Container(
          height: 0,
          color: Colors.black54,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue2 = newValue!;
          });
        },
        items: <String>[
          'Calle 10 9',
          'Calle 10 8',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Container _comboBox() {
    return Container(
      width: 150,
      height: 35,
      alignment: AlignmentDirectional.center,
      color: Colors.grey[200],
      child: DropdownButton<String>(
        // alignment: AlignmentDirectional.centerEnd,
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 0,
        style: const TextStyle(color: Colors.black54),
        underline: Container(
          height: 0,
          color: Colors.black54,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: <String>[
          'Entrega a domicilio',
          'Recoger en tienda',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Expanded _scrollHoriontal() {
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: ListView.builder(
                itemCount: images.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Container(
                      width: 170,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xff4f1581)),
                        image: DecorationImage(
                            image:
                                AssetImage(images[index]['image'].toString()),
                            fit: BoxFit.fill),
                        // shape: BoxShape.rectangle
                      ),
                      child: Text(
                        images[index]['name'].toString(),
                      ),
                    )),
          )
        ],
      ),
    );
  }

  Expanded _gridImages(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: GridView.count(
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 2,
            children: List.generate(gridImages.length, (index) {
              return Container(
                // decoration: BoxDecoration(
                //     // border: Border.all(
                //     //     // color: const Color(0xff4f1581),
                //     //     ),
                //     ),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                            child: Material(
                              type: MaterialType.transparency,
                              child: Container(
                                height: 350,
                                // width: 330,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(gridImages[index]),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Travel',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "lorem ipsum dore asde asdh name sdt jhas khuus",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: Card(
                    color: Colors.white,
                    child: Center(
                      child: Image.asset(gridImages[index]),
                    ),
                  ),
                ),
              );
            }),
          )),
    );
  }

  SizedBox _sliderImage() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: _pageChanged(),
            flex: 1,
          ),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _carousselImages.length,
                  (index) => _animatedContainer(index: index),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PageView _pageChanged() {
    return PageView.builder(
      controller: _pControler,
      pageSnapping: true,
      onPageChanged: (value) {
        setState(() {
          pageInitial = value % _carousselImages.length;
        });
      },
      itemCount: _carousselImages.length,
      itemBuilder: (context, index) => ContainerBoarding(
        // url: dataResponse[index]['url']!,
        // nombre: dataResponse[index]['nombre']!,
        image: _carousselImages[index].url,
        text: _carousselImages[index].nombre,
        // image: boardingData[index]['image']!,
        // text: boardingData[index]['text']!,
      ),
    );
  }

  AnimatedContainer _animatedContainer({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInCubic,
      height: 4,
      width: pageInitial == index ? 20 : 12,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
          color: pageInitial == index ? Colors.redAccent : Colors.grey),
    );
  }
}

class ContainerBoarding extends StatelessWidget {
  // final String url;
  // final String nombre;
  final String image;
  final String text;
  // const ContainerBoarding({Key? key, required this.url, required this.nombre})
  //     : super(key: key);
  const ContainerBoarding({Key? key, required this.image, required this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Container(
        // decoration:
        //     BoxDecoration(border: Border.all(color: const Color(0xff4f1581))),
        Column(
          children: [
            // Image.network(url),
            // Text(
            //   nombre,
            //   style: const TextStyle(fontSize: 25),
            // ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Image.network(image),
                  Text(
                    text,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
        // ),
      ],
    );
  }
}
