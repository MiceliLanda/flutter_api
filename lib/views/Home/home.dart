// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:consuming_api/views/Login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    {
      "image": "assets/images/1.png",
      "name": "Servicios",
      "desc":
          "La Clínica Veterinaria del Bosque proporciona servicios veterinarios integrales de la más alta calidad. Contamos con urgencias veterinarias 24 hrs."
    },
    {
      "image": "assets/images/2.png",
      "name": "Cuidados",
      "desc":
          "Los cuidados veterinarios básicos incluyen control de parásitos, con el fin de que la mascota mantenga su buena salud y no se afecte la salud de nosotros."
    },
    {
      "image": "assets/images/3.png",
      "name": "Veterinarios",
      "desc":
          "Los veterinarios diagnostican y tratan los animales enfermos y heridos. También previenen la enfermedad y la mala salud, ."
    },
    {
      "image": "assets/images/4.png",
      "name": "Médicos",
      "desc":
          "La Clínica Veterinaria del Bosque proporciona servicios veterinarios integrales de la más alta calidad. Contamos con urgencias veterinarias 24 hrs."
    },
  ];

  var images_desc = [
    "assets/images/1.png",
    "assets/images/2.png",
    "assets/images/3.png",
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tienda',
            ),
            SizedBox(
              width: 100,
              // color: Colors.redAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(Icons.shopping_bag_outlined),
                  Icon(Icons.notifications_none),
                  Icon(Icons.supervised_user_circle_rounded),
                  // Image.asset(
                  //   'assets/images/2.png',
                  //   width: 60,
                  //   height: 60,
                  //   // color: Colors.white,
                  // ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xff4f1581),
        elevation: 0,
        toolbarHeight: 45,
      ),
      body: SafeArea(
        child: Container(
          // color: Colors.grey,
          // height: double.infinity,
          margin: const EdgeInsets.only(right: 5, left: 5, bottom: 10, top: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _headItems(),
                Container(
                  margin: const EdgeInsets.all(0),
                  child: _scrollHoriontal(),
                ),
                _searchBar(),
                _sliderImage(),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Container(
                  height: 50,
                  // color: Colors.grey,
                  child: Row(
                    children: [
                      const Text(
                        'Productos cerca  ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        children: [
                          // list view to text with scroll horizontal
                          Container(
                            width: 225,
                            height: 20,
                            alignment: Alignment.center,
                            // color: Colors.red,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                // return Padding(
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ElevatedButton(
                                    onPressed: null,
                                    child: Text(
                                      images[index]['name'].toString(),
                                      // "aaa",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.green,
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                                //   padding: const EdgeInsets.only(right: 8.0),
                                //   child: Text(
                                //     "${images[index]['name']}",
                                //     style: const TextStyle(
                                //         fontSize: 18, color: Colors.purple),
                                //     textAlign: TextAlign.center,
                                //   ),
                                // );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // Expanded(child: _pageChanged()),
                _gridImages(context)
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: _bottomNavigation(context),
    );
  }

  BottomNavigationBar _bottomNavigation(BuildContext context) {
    return BottomNavigationBar(
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
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login()));
        }
      },
    );
  }

  Container _searchBar() {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 35,
            width: 325,
            margin: const EdgeInsets.only(top: 25),
            child: TextField(
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Buscar productos o servicios...',
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          // button circle icon filter
          Container(
            width: 45,
            height: 35,
            margin: const EdgeInsets.only(top: 20),
            child: Center(
              child: MaterialButton(
                onPressed: () {},
                color: Colors.pink,
                // textColor: Colors.white,
                child: const Icon(
                  Icons.format_list_bulleted_outlined,
                  size: 20,
                  textDirection: TextDirection.ltr,
                  color: Colors.white,
                ),
                // padding: EdgeInsets.all(1),
                shape: const CircleBorder(),
              ),
            ),
          )

          // Container(
          //   height: 35,
          //   width: 20,
          //   margin: const EdgeInsets.only(right: 10),
          //   child: const Icon(
          //     Icons.format_list_bulleted_outlined,
          //     color: Colors.purple,
          //   ),
          // ),
        ],
      ),
    );
  }

  Container _headItems() {
    return Container(
      // flex: 1,
      margin: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text.rich(
                TextSpan(
                  text: 'Hola ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'Juan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    TextSpan(
                      text: ',',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset("assets/images/2.png", width: 60, height: 60),
              //
              // _comboBox()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset("assets/images/2.png", width: 40, height: 50),
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
          ),
          const Divider(color: Colors.grey, height: 1),
        ],
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
        style:
            const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
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
        style:
            const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
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

  Column _scrollHoriontal() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          // color: Colors.greenAccent,}
          height: 180,
          child: ListView.builder(
            itemCount: images.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  height: 180,
                  decoration: BoxDecoration(
                    // color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xff4f1581),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(images[index]['image'].toString(),
                          width: 140, height: 120),
                      Text(images[index]['name'].toString(),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Container _gridImages(BuildContext context) {
    return Container(
      // flex: 2,
      height: 150,
      child: GridView.count(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        children: List.generate(images.length, (index) {
          return GestureDetector(
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
                                child: Image.asset(
                                  images[index]['image'].toString(),
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                              // const SizedBox(height: 15),
                              Text(
                                images[index]['name'].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                images[index]['desc'].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
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
              // color: Colors.grey[400],
              color: Colors.white,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side:
                    const BorderSide(color: Color.fromARGB(255, 136, 136, 136)),
              ),
              child: Image.asset(
                images[index]['image'].toString(),
              ),
            ),
          );
        }),
      ),
    );
  }

  SizedBox _sliderImage() {
    return SizedBox(
      // color: Colors.yellowAccent,

      height: 170,
      // color: Colors.red,
      // margin: const EdgeInsets.only(top: 0, left: 5, right: 5, bottom: 0),
      width: 365,
      child: Column(
        children: [
          Expanded(
            child: _pageChanged(),
            flex: 1,
          ),
          const Divider(
            color: Colors.grey,
            height: 1,
          ),
          // Column(
          //   children: <Widget>[
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: List.generate(
          //         _carousselImages.length,
          //         (index) => _animatedContainer(index: index),
          //       ),
          //     ),
          //   ],
          // ),
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
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image(
            image: NetworkImage(image),
          ),
        ),
        // ),
      ],
    );
  }
}
