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
  final String nombreUsuario;

  const Home(this.nombreUsuario, {Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _isPressed = 0;
  int _isPressed2 = 0;
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

  Timer? timer;
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
    List<Products> datos = [];
    final jsonResponse =
        jsonDecode(response.body)['getProducts']['response']['docs'];

    if (response.statusCode == 200) {
      for (var jsonData in jsonResponse) {
        datos.add(Products.fromJson(jsonData));
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
        // print('JsonData -> ' + jsonData.toString());
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
                children: [
                  const Icon(
                    Icons.shopping_bag,
                    color: Colors.white,
                    size: 25,
                  ),
                  const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 25,
                  ),
                  Image.asset(
                    'assets/images/ic_grupo_3038.PNG',
                    width: 25,
                    height: 25,
                    color: Colors.white,
                  ),
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
                  color: Color.fromARGB(255, 213, 213, 213),
                  thickness: 1,
                ),
                _productsList(),
                _gridImages(context),
                const Divider(
                  color: Color.fromARGB(255, 213, 213, 213),
                  thickness: 1,
                ),
                _servicesList(), // Expanded(child: _pageChanged()),
                _gridImages(context)
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width,
        // color: const Color(0xff4f1581),
        child: CustomPaint(
          size: Size(MediaQuery.of(context).size.width, 100),
          painter: _CustomPainter(),
          child: Container(
            margin: const EdgeInsets.only(right: 30, left: 30, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // create iconsBUtton for navigationbar
                Image.asset(
                  'assets/images/ic_trazado_home.PNG',
                  width: 35,
                  height: 35,
                ),
                Image.asset(
                  'assets/images/ic_icon_order.PNG',
                  width: 35,
                  height: 35,
                ),
                Image.asset(
                  'assets/images/ic_grupo_3036.PNG',
                  width: 35,
                  height: 35,
                ),
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
          _staticBox(0),
          const SizedBox(
            width: 20,
          ),
          _staticBox(1),
        ],
      ),
    );
  }

  Container _staticBox(int i) {
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
      child: SizedBox(
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(images[i]['image'].toString(), width: 140, height: 120),
            Text(images[i]['name'].toString(),
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
              Container(
                width: 225,
                height: 20,
                alignment: Alignment.center,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _pets.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(
                            () {
                              print(index);
                              _isPressed = index;
                            },
                          );
                        },
                        child: Text(
                          _pets[index].pet[0].pet,
                          style: TextStyle(
                            fontSize: 15,
                            color: _isPressed == index
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            _isPressed == index ? Colors.green : Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: _isPressed == index
                                  ? const BorderSide(color: Colors.green)
                                  : BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container _servicesList() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 5),

      // color: Colors.grey,
      child: Row(
        children: [
          const Text(
            'Servicios cerca  ',
            style: TextStyle(fontSize: 20),
          ),
          Row(
            children: [
              Container(
                width: 225,
                height: 20,
                alignment: Alignment.center,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _pets.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(
                            () {
                              print(index);
                              _isPressed2 = index;
                            },
                          );
                        },
                        child: Text(
                          _pets[index].pet[0].pet,
                          style: TextStyle(
                            fontSize: 15,
                            color: _isPressed2 == index
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            _isPressed2 == index ? Colors.purple : Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: _isPressed2 == index
                                  ? const BorderSide(color: Colors.purple)
                                  : BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
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
              Text.rich(
                TextSpan(
                  text: 'Hola ',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    /* AQUI VA EL NOMBRE DEL USUARIO LOGEADO */
                    TextSpan(
                      text: widget.nombreUsuario.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const TextSpan(
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
                  Image.asset(
                    "assets/images/ic_icon_grupo_353.PNG",
                    width: 40,
                    height: 50,
                    color: Colors.green,
                  ),
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
          const SizedBox(
            height: 4,
          ),
          const Divider(color: Color.fromARGB(255, 196, 195, 195), height: 2),
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

  Container _gridImages(BuildContext context) {
    return Container(
      // flex: 2,
      height: 200,
      margin: const EdgeInsets.only(top: 0, left: 8),
      // width: 200,

      // color: Colors.amber,
      child: GridView.count(
        mainAxisSpacing: 0,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 1,
        scrollDirection: Axis.horizontal,
        children: List.generate(_productos.length, (index) {
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewProduct(
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
            child: Container(
              margin: const EdgeInsets.only(right: 32),
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(255, 241, 241, 241),
                  width: 1,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(_productos[index].urlImage,
                        width: 100, height: 100),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        _productos[index].name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green),
                      ),
                    ),
                    SizedBox(
                      width: 170,
                      // color: Colors.greenAccent,
                      child: Text(
                        _productos[index].description,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.grey),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
}

class _CustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path = Path();
    path.moveTo(0, size.height * 0.1128000);
    path.quadraticBezierTo(
      size.width * 0.0902041,
      size.height * -0.0123000,
      size.width * 0.1633929,
      size.height * 0.0103000,
    );
    path.cubicTo(
        size.width * 0.2879847,
        size.height * -0.0231000,
        size.width * 0.2751786,
        size.height * 0.2655000,
        size.width * 0.5131633,
        size.height * 0.2771000);
    path.cubicTo(
        size.width * 0.6660204,
        size.height * 0.2665000,
        size.width * 0.6857398,
        size.height * 0.2169000,
        size.width * 0.7969133,
        size.height * 0.0897000);
    path.quadraticBezierTo(
      size.width * 0.8737500,
      size.height * -0.0645000,
      size.width * 0.9985969,
      size.height * 0.0723000,
    );
    path.lineTo(size.width * 0.9985969, size.height * 1.0058000);
    path.lineTo(size.width * -0.0014031, size.height * 1.0058000);
    path.lineTo(0, size.height * 0.1128000);
    path.close();
    canvas.drawPath(path, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
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

class ViewProduct extends StatelessWidget {
  final String name, description, urlImage;
  final double price;
  const ViewProduct(this.name, this.description, this.price, this.urlImage,
      {Key? key})
      : super(key: key);

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
