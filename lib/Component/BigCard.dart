import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../HomePage.dart';

class BigCard extends StatelessWidget {
  final Product product;

  BigCard({required this.product});

  @override
  Widget build(BuildContext context) {
    var heading = product.title;
    var subheading = product.category;
    var cardImage = NetworkImage(product.images[0]);
    var supportingText = product.description;
    var prix = '${product.price.toStringAsFixed(2)}€';

    return Card(
        elevation: 4.0,
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.45,
          width: MediaQuery.of(context).size.width / 4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 150,
                  width: 300,
                  child: Ink.image(
                    image: cardImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10, bottom: 10),
                  child: Text(
                    subheading,
                    style: TextStyle(fontSize: 10),
                  )),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10, bottom: 15),
                  child: Text(
                    heading,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  )),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10),
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, top: 15),
                alignment: Alignment.centerLeft,
                child: Text(supportingText),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(prix,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    IconButton(
                        icon:
                            const Icon(Icons.shopping_cart_checkout, size: 35),
                        onPressed: () {})
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
