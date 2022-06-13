// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'package:consuming_api/models/caroussel.dart';
import 'package:consuming_api/models/products.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/pet_taxonomia.dart';

class Market extends StatefulWidget {
  const Market({Key? key}) : super(key: key);

  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> {
  final List<PetTaxonimia> _pets = [];
  final List<Products> _productos = [];

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
      ),
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // print(snapshot.connectionState);
          // return Center(child: CircularProgressIndicator());
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: _productos.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  textColor: Colors.black,
                  title: Text(_productos[index].name),
                  subtitle: Text(_productos[index].description),
                  leading: Image.network(_productos[index].urlImage),
                  trailing: Text(_productos[index].price.toString()),
                );
              },
            );
          }
        },
      ),
    );
  }
}
