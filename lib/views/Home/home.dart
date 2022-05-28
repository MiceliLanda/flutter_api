import 'dart:async';
import 'package:consuming_api/views/Login/login_view.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var images = [
    "assets/images/B1.png",
    "assets/images/B2.png",
    "assets/images/B3.png",
    "assets/images/B4.png",
    "assets/images/B2.png",
    "assets/images/B1.png",
    "assets/images/B2.png",
    "assets/images/B3.png",
    "assets/images/B4.png",
    "assets/images/B2.png",
    "assets/images/B1.png",
    "assets/images/B2.png"
  ];
  var desc = [
    "lorem ipsum dore asde asdh name sdt jhas khuus",
    "lorem ipsum dore asde asdh name sdt jhas khuus",
    "lorem ipsum dore asde asdh name sdt jhas khuus",
    "lorem ipsum dore asde asdh name sdt jhas khuus",
    "lorem ipsum dore asde asdh name sdt jhas khuus",
    "lorem ipsum dore asde asdh name sdt jhas khuus",
    "lorem ipsum dore asde asdh name sdt jhas khuus",
    "lorem ipsum dore asde asdh name sdt jhas khuus",
    "lorem ipsum dore asde asdh name sdt jhas khuus",
    "lorem ipsum dore asde asdh name sdt jhas khuus",
    "lorem ipsum dore asde asdh name sdt jhas khuus",
    "lorem ipsum dore asde asdh name sdt jhas khuus",
  ];

  var names = [
    "Travel",
    "Travel",
    "Travel",
    "Travel",
    "Travel",
    "Travel",
    "Travel",
    "Travel",
    "Travel",
    "Travel",
    "Travel",
    "Travel",
  ];

  List<Map<String, String>> boardingData = [
    {
      'image': "assets/images/B1.png",
    },
    {
      'image': "assets/images/B2.png",
    },
    {
      'image': "assets/images/B3.png",
    },
    {
      'image': "assets/images/B4.png",
    },
    {
      'image': "assets/images/B5.png",
    }
  ];

  Timer? timer;
  // int viewPort = 2;
  int pageInitial = 0;
  late PageController _pControler = PageController(initialPage: 0);

  @override
  void initState() {
    _pControler = PageController(viewportFraction: 1, initialPage: 0);
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (pageInitial == 4) {
        pageInitial = 0;
      } else {
        pageInitial++;
      }
      _pControler.animateToPage(pageInitial,
          duration: const Duration(milliseconds: 550), curve: Curves.easeIn);
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
              'Home',
            ),
            Image.asset(
              'assets/images/B2.png',
              width: 60,
              height: 60,
            ),
          ],
        ),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        toolbarHeight: 60,
      ),
      body: Container(
        // color: Colors.deepOrange,
        margin: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 230,
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(child: _pageChanged()),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          boardingData.length,
                          (index) => _animatedContainer(index: index),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Expanded(child: _pageChanged()),
            SingleChildScrollView(
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(62, 7, 172, 255)),
                      margin: const EdgeInsets.only(top: 30, bottom: 10),
                      child: ListView.builder(
                          itemCount: 20,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Container(
                                width: 50,
                                margin: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/images/B3.png'),
                                  ),
                                ),
                              )),
                    )
                  ],
                ),
              ),
            ),
            Container(
                height: 260,
                // color: Colors.blueAccent,
                child: GridView.count(
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 3,
                  children: List.generate(12, (index) {
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Container(
                                      height: 320,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.asset(images[index]),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            names[index],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            desc[index],
                                            style: const TextStyle(
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
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Center(
                              child: Image.asset(images[index]),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ))
          ],
        ),
      ),
      // bottomNavigationBar: Row(
      //   children: [
      //     Icon(Icons.verified_user),
      //     Icon(Icons.home),
      //     Icon(Icons.logout)
      //   ],
      // ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlue,
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

  PageView _pageChanged() {
    return PageView.builder(
      controller: _pControler,
      pageSnapping: true,
      onPageChanged: (value) {
        setState(() {
          pageInitial = value % boardingData.length;
        });
      },
      itemCount: boardingData.length,
      itemBuilder: (context, index) => ContainerBoarding(
        image: boardingData[index]['image']!,
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
  final String image;

  const ContainerBoarding({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          image,
          height: 200,
          width: double.infinity,
        ),
      ],
    );
  }
}
