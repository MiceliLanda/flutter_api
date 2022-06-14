// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'package:consuming_api/views/Login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/caroussel.dart';
import '../../models/pet_taxonomia.dart';
import '../../models/products.dart';

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
    }
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
  final List<PetTaxonimia> _pets = [];
  final List<Products> _productos = [];
  final List<CarousselImage> _carousselImages = [];

  Future<List<Products>> _getPets() async {
    final response = await http.post(
        Uri.parse(
            'http://desarrollovan-tis.dedyn.io:4030/GetProductsByIdSeller'),
        body: jsonEncode({"idSeller": "1"}),
        headers: {"Content-Type": "application/json"});
    // print(jsonDecode(response.body)['getProducts']['response']['docs']);
    List<Products> datos = [];
    final jsonResponse =
        jsonDecode(response.body)['getProducts']['response']['docs'];

    if (response.statusCode == 200) {
      for (var jsonData in jsonResponse) {
        datos.add(Products.fromJson(jsonData));
        // print('JsonData -> ' + jsonData.toString());
      }
    } else {
      print('Error -> ' + response.statusCode.toString());
    }
    return datos;
  }

  Future<List<PetTaxonimia>> postTaxonomia() async {
    final response = await http.post(
        Uri.parse('http://desarrollovan-tis.dedyn.io:4030/GetPetTaxonomia'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idChannel": "1"}));
    List<PetTaxonimia> datos = [];
    final jsonResponse = jsonDecode(response.body)['dtoPetTaxonomies'];

    if (response.statusCode == 200) {
      for (var jsonData in jsonResponse) {
        datos.add(PetTaxonimia.fromJson(jsonData));
        print('JsonData -> ' + jsonData.toString());
      }
    } else {
      print('Error -> ' + response.statusCode.toString());
    }
    return datos;
  }

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
    _getPets().then((value) {
      setState(() {
        _productos.addAll(value);
      });
    });
    postTaxonomia().then((value) {
      setState(() {
        _pets.addAll(value);
      });
    });

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
                _addPets(),
                _containerStatic(),
                _searchBar(),
                _sliderImage(),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                _productsList(),
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

  Center _containerStatic() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _staticBox(),
          const SizedBox(
            width: 20,
          ),
          _staticBox(),
        ],
      ),
    );
  }

  Container _staticBox() {
    return Container(
      // margin: const EdgeInsets.only(right: 30),
      // height: 180,
      decoration: BoxDecoration(
        // color: Colors.redAccent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xff4f1581),
          width: 1,
        ),
      ),
      child: Container(
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(images[0]['image'].toString(), width: 140, height: 120),
            Text(images[0]['name'].toString(),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
          ],
        ),
      ),
    );
  }

  Container _addPets() {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mis mascotas',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // button add pet
              Container(
                margin: const EdgeInsets.only(right: 10),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.grey,
                ),
              ),
              const Text('Agregar mascota'),
            ],
          )
        ],
      ),
    );
  }

  Container _productsList() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 5),

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
                  itemCount: _pets.length,
                  itemBuilder: (context, index) {
                    // return Padding(
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: null,
                        child: Text(
                          _pets[index].pet[0].pet,

                          // "aaa",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.green,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.grey),
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
          const Divider(color: Colors.black38, height: 3),
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

  Column _scrollHorizontal() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.greenAccent,
          alignment: Alignment.center,
          height: 180,
          child: ListView.builder(
            itemCount: images.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  // height: 180,
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
      height: 250,
      child: GridView.count(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 1,
        scrollDirection: Axis.horizontal,
        children: List.generate(_productos.length, (index) {
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => viewProduct(
                        _productos[index].name,
                        _productos[index].description,
                        _productos[index].price,
                        _productos[index].urlImage))),
            // onTap: () {
            //   PageView(
            //     children: [
            //       viewProduct(
            //           _productos[index].name,
            //           _productos[index].description,
            //           _productos[index].price,
            //           _productos[index].urlImage),
            //     ],
            //   );

            // showDialog(
            //     context: context,
            //     builder: (context) {
            //       return Center(
            //         child: Material(
            //           type: MaterialType.transparency,
            //           child: Container(
            //             height: 350,
            //             // width: 330,
            //             padding: const EdgeInsets.all(15),
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(10),
            //                 color: Colors.white),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 ClipRRect(
            //                   borderRadius: BorderRadius.circular(10),
            //                   child: Image.network(
            //                     _productos[index].urlImage,
            //                     width: 300,
            //                     height: 250,
            //                   ),
            //                 ),
            //                 // const SizedBox(height: 15),
            //                 Text(
            //                   _productos[index].name.toString(),
            //                   style: const TextStyle(
            //                       fontWeight: FontWeight.bold, fontSize: 18),
            //                 ),
            //                 const SizedBox(
            //                   height: 10,
            //                 ),
            //                 Text(
            //                   _productos[index].description.toString(),
            //                   style: const TextStyle(
            //                       fontWeight: FontWeight.normal,
            //                       fontSize: 15),
            //                 ),
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     const Text(
            //                       "\$",
            //                       style: TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 17),
            //                     ),
            //                     Text(
            //                       (_productos[index].price).toString(),
            //                       style: const TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 17),
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       );
            //     });
            // },
            child: Card(
              // color: Colors.grey[400],
              color: Colors.white,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side:
                    const BorderSide(color: Color.fromARGB(255, 232, 232, 232)),
              ),
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 140,
                      child: Image.network(_productos[index].urlImage),
                    ),
                    Text(
                      _productos[index].name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green),
                    ),
                    Text(
                      _productos[index].description,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          color: Colors.grey),
                    ),
                    Row(
                      children: [
                        const Text(
                          "\$",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        Text(
                          (_productos[index].price).toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ],
                    ),
                  ],
                ),
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
          Divider(
            color: Colors.grey[200],
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

class viewProduct extends StatelessWidget {
  final String name, description, urlImage;
  final double price;
  viewProduct(this.name, this.description, this.price, this.urlImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle producto'),
        backgroundColor: const Color(0xff4f1581),
      ),
      body: Container(
        color: Colors.white,
        // width: double.infinity,
        // height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 350,
              height: 300,
              child: Image.network(urlImage),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              description,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "\$",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  (price).toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
