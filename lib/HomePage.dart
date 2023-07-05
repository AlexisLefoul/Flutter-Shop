import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Component/BigCard.dart';

class Product {
  int id;
  String title;
  String description;
  double price;
  double discountPercentage;
  double rating;
  int stock;
  String brand;
  String category;
  String thumbnail;
  List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      discountPercentage: json['discountPercentage'].toDouble(),
      rating: json['rating'].toDouble(),
      stock: json['stock'],
      brand: json['brand'],
      category: json['category'],
      thumbnail: json['thumbnail'],
      images: List<String>.from(json['images']),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Appel à fetchData dans initState
  }

  Future<void> fetchData() async {
    var url = Uri.parse('https://dummyjson.com/products');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      List<Product> productList =
          []; // Créez une liste temporaire pour stocker les produits

      if (jsonResponse is List) {
        // Vérifiez si la réponse JSON est un tableau
        for (var productJson in jsonResponse) {
          // Parcourez la liste d'objets JSON et convertissez-les en instances de Product
          Product product = Product.fromJson(productJson);
          productList.add(product);
        }
      } else if (jsonResponse is Map) {
        // Vérifiez si la réponse JSON est un objet contenant une liste de produits
        var productsJson = jsonResponse['products'];

        if (productsJson is List) {
          for (var productJson in productsJson) {
            // Parcourez la liste d'objets JSON et convertissez-les en instances de Product
            Product product = Product.fromJson(productJson);
            productList.add(product);
          }
        }
      }

      setState(() {
        products = productList;
        isLoading = false;
      });
    } else {
      // La requête a échoué avec une erreur HTTP
      print('Erreur ${response.statusCode}: ${response.reasonPhrase}');
      isLoading = false; // Les données ont été chargées avec succès
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child:
            CircularProgressIndicator(), // Affichez un indicateur de chargement pendant le chargement des données
      );
    } else {
      return GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 30,
        mainAxisSpacing: 15,
        padding: const EdgeInsets.all(20),
        children: products.map((product) => BigCard(product: product)).toList(),
      );
    }
  }
}
