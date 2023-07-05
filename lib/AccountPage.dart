import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User {
  int id;
  String firstName;
  String lastName;
  String maidenName;
  String phone;
  String email;
  String image;
  Address address; // Ajoutez la propriété address

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.maidenName,
    required this.phone,
    required this.email,
    required this.image,
    required this.address, // Initialisez la propriété address
    // Initialisez les autres propriétés
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      maidenName: json['maidenName'],
      phone: json['phone'],
      email: json['email'],
      image: json['image'],
      address:
          Address.fromJson(json['address']), // Désérialisez l'objet address
      // Assurez-vous de désérialiser les autres propriétés
    );
  }
}

class Address {
  String address;
  String postalCode;
  String city;

  Address({
    required this.address,
    required this.postalCode,
    required this.city,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      postalCode: json['postalCode'],
      city: json['city'],
    );
  }
}

class AccountPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isLoading = true;
  User user = User(
    email: '',
    firstName: '',
    id: 0,
    image: '',
    lastName: '',
    maidenName: '',
    phone: '',
    address: Address(address: '', postalCode: '', city: ''),
  ); // Initialisation d'un objet User vide

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData() async {
    var url = Uri.parse('https://dummyjson.com/user/28');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // La requête a réussi, vous pouvez traiter les données de la réponse ici
      var jsonResponse = json.decode(response.body);
      var userRes = User.fromJson(jsonResponse);

      setState(() {
        user.email = userRes.email;
        user.firstName = userRes.firstName;
        user.id = userRes.id;
        user.image = userRes.image;
        user.lastName = userRes.lastName;
        user.maidenName = userRes.maidenName;
        user.phone = userRes.phone;
        user.address.address = jsonResponse['address']['address'];
        user.address.postalCode = jsonResponse['address']['postalCode'];
        user.address.city = jsonResponse['address']['city'];
      });
      isLoading = false; // Les données ont été chargées avec succès
    } else {
      // La requête a échoué avec une erreur HTTP
      print('Erreur ${response.statusCode}: ${response.reasonPhrase}');
      isLoading = false; // Les données ont été chargées avec succès
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
      final firstNameController = TextEditingController(text: user.firstName);
      final lastNameController = TextEditingController(text: user.lastName);
      final maidenNameController = TextEditingController(text: user.maidenName);
      final phoneController = TextEditingController(text: user.phone);
      final emailController = TextEditingController(text: user.email);
      final addressController =
          TextEditingController(text: user.address.address);
      final cityController = TextEditingController(text: user.address.city);
      final postalCodeController =
          TextEditingController(text: user.address.postalCode);

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 100, top: 20),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text("Mon compte", style: style),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 30),
                    child: Image(
                      image: NetworkImage(user.image),
                      height: 200,
                      width: 150,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        enabled: false,
                        controller: firstNameController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Prénom',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        enabled: false,
                        controller: lastNameController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Nom',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        enabled: false,
                        controller: maidenNameController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Pseudo',
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 70),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          enabled: false,
                          controller: phoneController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Téléphone',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          enabled: false,
                          controller: emailController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        enabled: false,
                        controller: addressController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Adresse',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        enabled: false,
                        controller: postalCodeController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Code Postal',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        enabled: false,
                        controller: cityController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Ville',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      );
    }
  }
}
