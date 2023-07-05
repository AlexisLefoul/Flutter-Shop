import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Basket {
  int id;
  int total;
  int totalQuantity;
  List<InfosProductPanier> products; // Modifier le type en List<Product>

  Basket({
    required this.id,
    required this.total,
    required this.totalQuantity,
    required this.products,
  });

  factory Basket.fromJson(Map<String, dynamic> json) {
    return Basket(
      id: json['id'],
      total: json['total'],
      totalQuantity: json['totalQuantity'],
      products: List<InfosProductPanier>.from(json['products']
          .map((product) => InfosProductPanier.fromJson(product))),
    );
  }
}

class InfosProductPanier {
  int id;
  String title;
  int quantity;
  int total;

  InfosProductPanier(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.total});

  factory InfosProductPanier.fromJson(Map<String, dynamic> json) {
    return InfosProductPanier(
      id: json['id'],
      title: json['title'],
      quantity: json['quantity'],
      total: json['total'],
    );
  }
}

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

class BasketPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  Map<int, Product> productCache = {};

  bool isLoading = true;
  Basket panier = Basket(
    id: 0,
    total: 0,
    totalQuantity: 0,
    products: [],
  );

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData() async {
    var url = Uri.parse('https://dummyjson.com/carts/10');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // La requête a réussi, vous pouvez traiter les données de la réponse ici
      var jsonResponse = json.decode(response.body);
      var panierRes = Basket.fromJson(jsonResponse);

      setState(() {
        panier = panierRes;
      });

      isLoading = false; // Les données ont été chargées avec succès
    } else {
      // La requête a échoué avec une erreur HTTP
      print('Erreur ${response.statusCode}: ${response.reasonPhrase}');
      isLoading = false; // Les données ont été chargées avec succès
    }
  }

  Future<Product> fetchProduct(int productId) async {
    if (productCache.containsKey(productId)) {
      return productCache[productId]!;
    } else {
      var url = Uri.parse('https://dummyjson.com/products/$productId');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var product = Product.fromJson(jsonResponse);
        productCache[productId] =
            product; // Mettre en cache le produit récupéré
        return product;
      } else {
        throw Exception('Failed to fetch product');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: Colors.black,
    );

    fetchData();

    if (isLoading) {
      return Center(
        child:
            CircularProgressIndicator(), // Affichez un indicateur de chargement pendant le chargement des données
      );
    } else {
      String total = panier.total.toString();
      String totalQuantity = panier.totalQuantity.toString();

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 100, top: 20),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text("Mon panier", style: style),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Nb articles : ',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: totalQuantity,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Prix total : ',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: '$total €',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ]),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: panier.products.length,
                itemBuilder: (BuildContext context, int index) {
                  final productId = panier.products[index].id;
                  return FutureBuilder<Product>(
                    future: fetchProduct(productId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final product = snapshot.data!;
                        return CartProduct(
                          product: product,
                          quantity: panier.products[index].quantity,
                          total: panier.products[index].total,
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return CircularProgressIndicator();
                    },
                  );
                },
              ),
            ),
          ),
        ],
      );
    }
  }
}

class CartProduct extends StatelessWidget {
  final Product product;
  final int quantity;
  final int total;

  const CartProduct({
    Key? key,
    required this.product,
    required this.quantity,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              child: Image.network(product.images[0], scale: 6),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                product.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('${product.price}€')),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      tooltip: 'Remove a product',
                      onPressed: () {},
                    ),
                    Text(quantity.toString(), style: TextStyle(fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: 'Add a product',
                      onPressed: () {},
                    ),
                  ],
                )),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('${total.toString()} €',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
