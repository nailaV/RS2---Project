// ignore_for_file: must_be_immutable, prefer_const_constructors, camel_case_types, unused_element, unused_import, prefer_const_literals_to_create_immutables, deprecated_member_use

//import 'dart:ffi';

import 'dart:math';

import 'package:eautokuca_mobile/main.dart';
import 'package:eautokuca_mobile/screens/car_details_screen.dart';
import 'package:eautokuca_mobile/screens/favoriti_screen.dart';
import 'package:eautokuca_mobile/screens/korisnicki_profil_screen.dart';
import 'package:eautokuca_mobile/screens/kosarica_screen.dart';
import 'package:eautokuca_mobile/screens/lista_automobila.dart';
import 'package:eautokuca_mobile/screens/recenzije_screen.dart';
import 'package:eautokuca_mobile/screens/rezervisani_termini_screen.dart';
import 'package:eautokuca_mobile/screens/shop_main_screen.dart';
import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:eautokuca_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  MasterScreenWidget({this.child, this.title, Key? key}) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  int currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    if (currentIndex == 0) {
      Navigator.of(context).pop();
    } else if (currentIndex == 1) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (builder) => ListaAutomobila()));
    } else if (currentIndex == 2) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (builder) => ShopMainScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Authorization.username = "";
                  Authorization.password = "";
                  MyDialogs.showQuestion(
                      context, "Da li ste sigurni da se želite odjaviti?", () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (builder) => LoginPage()));
                  });
                },
                icon: Icon(Icons.logout))
          ],
          title: Text(
            widget.title ?? "",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.yellow[700]),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: _drawerItems(),
      ),
      body: widget.child!,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Nazad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Početna',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

class _drawerItems extends StatelessWidget {
  void _openMap() async {
    const url =
        'https://www.google.com/maps/dir//44.0251186,18.2668996/@44.025069,18.2665992,20z/data=!4m2!4m1!3e0?entry=ttu';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  const _drawerItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDrawerHeader(context),
        ListTile(
          title: Text(
            "TERMINI",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RezervisaniTermini(),
            ));
          },
        ),
        SizedBox(
          height: 12,
        ),
        ListTile(
          title: Text(
            "SHOP",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ShopMainScreen(),
            ));
          },
        ),
        SizedBox(
          height: 12,
        ),
        ListTile(
          title: Text(
            "KORISNIČKI PROFIL",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const KorisnickiProfil(),
            ));
          },
        ),
        SizedBox(
          height: 12,
        ),
        ListTile(
          title: Text(
            "FAVORITI",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const FavoritiScreen(),
            ));
          },
        ),
        SizedBox(
          height: 12,
        ),
        ListTile(
          title: Text(
            "KOŠARICA",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const KosaricaScreen(),
            ));
          },
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RecenzijeScreen(),
                ));
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.question_answer_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Sviđa ti se aplikacija? ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Klikni da ostaviš recenziju! ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  DrawerHeader _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(color: Colors.yellow[700]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.car_rental_rounded),
              Text(
                "LenaAuto",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on_outlined),
              Text(
                "Sarajevo",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListaAutomobila()));
                  },
                  icon: Icon(
                    Icons.home,
                    color: Colors.black,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const KorisnickiProfil()));
                  },
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ShopMainScreen()));
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
