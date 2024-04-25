// ignore_for_file: must_be_immutable, prefer_const_constructors, camel_case_types, unused_element, unused_import, prefer_const_literals_to_create_immutables

//import 'dart:ffi';

import 'dart:math';

import 'package:eautokuca_desktop/models/korisnici.dart';
import 'package:eautokuca_desktop/providers/korisnici_provider.dart';
import 'package:eautokuca_desktop/screens/korisnici_screen.dart';
import 'package:eautokuca_desktop/screens/lista_automobila.dart';
import 'package:eautokuca_desktop/screens/rezervacije_screen.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/utils/utils.dart';
import 'package:eautokuca_desktop/widgets/novi_automobil_popup.dart';
import 'package:flutter/material.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  MasterScreenWidget({this.child, this.title, Key? key}) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
    );
  }
}

class _drawerItems extends StatelessWidget {
  const _drawerItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.yellow[700]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.car_rental_rounded),
                  Text(
                    "Autokuća LENA",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                "Sarajevo",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ListaAutomobila()));
                      },
                      icon: Icon(
                        Icons.home,
                        color: Colors.black,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ListaAutomobila()));
                      },
                      icon: Icon(
                        Icons.person,
                        color: Colors.black,
                      )),
                  Icon(Icons.settings, color: Colors.black),
                ],
              ),
            ],
          ),
        ),
        ListTile(
          title: Text(
            "POČETNA",
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Roboto",
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ListaAutomobila(),
            ));
          },
        ),
        SizedBox(
          height: 12,
        ),
        ListTile(
          title: Text(
            "REZERVACIJE",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RezervacijeScreen(),
            ));
          },
        ),
        SizedBox(
          height: 12,
        ),
        ListTile(
          title: Text(
            "NOVI OGLAS",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
            ),
          ),
          onTap: () {
            showDialog(context: context, builder: (context) => NoviAutomobil());
          },
        ),
        SizedBox(
          height: 12,
        ),
        ListTile(
          title: Text(
            "KORISNICI",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const KorisniciScreen(),
            ));
          },
        ),
        SizedBox(
          height: 12,
        ),
        ListTile(
          title: Text(
            "REPORTS",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
            ),
          ),
          // onTap: () {
          //   Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => const MyApp(),
          //   ));
          // },
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
