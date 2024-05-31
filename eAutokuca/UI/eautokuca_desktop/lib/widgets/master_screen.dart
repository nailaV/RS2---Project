// ignore_for_file: must_be_immutable, prefer_const_constructors, camel_case_types, unused_element, unused_import, prefer_const_literals_to_create_immutables

import 'dart:isolate';
import 'dart:math';

import 'package:eautokuca_desktop/main.dart';
import 'package:eautokuca_desktop/models/korisnici.dart';
import 'package:eautokuca_desktop/providers/korisnici_provider.dart';
import 'package:eautokuca_desktop/providers/recenzije_provider.dart';
import 'package:eautokuca_desktop/screens/autodijelovi_main_screen.dart';
import 'package:eautokuca_desktop/screens/finansije_screen.dart';
import 'package:eautokuca_desktop/screens/korisnici_screen.dart';
import 'package:eautokuca_desktop/screens/korisnicki_profil_screen.dart';
import 'package:eautokuca_desktop/screens/lista_automobila.dart';
import 'package:eautokuca_desktop/screens/recenzije_screen.dart';
import 'package:eautokuca_desktop/screens/report_screen.dart';
import 'package:eautokuca_desktop/screens/rezervacije_screen.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/utils/utils.dart';
import 'package:eautokuca_desktop/widgets/promjena_passworda_popup.dart';
import 'package:eautokuca_desktop/widgets/novi_automobil_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  MasterScreenWidget({this.child, this.title, Key? key}) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  double prosjecnaOcjena = 0.0;
  late RecenzijeProvider _recenzijeProvider;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _recenzijeProvider = context.read<RecenzijeProvider>();
    getData();
  }

  Future<void> getData() async {
    try {
      var data = await _recenzijeProvider.getAverage();
      setState(() {
        prosjecnaOcjena = data;
        isLoading = true;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
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
        child: _drawerItems(prosjecnaOcjena: prosjecnaOcjena),
      ),
      body: widget.child!,
    );
  }
}

class _drawerItems extends StatelessWidget {
  final double prosjecnaOcjena;

  const _drawerItems({
    Key? key,
    required this.prosjecnaOcjena,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                            builder: (context) => const ListaAutomobila()));
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
                            builder: (context) => AutodijeloviScreen()));
                      },
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                      )),
                ],
              ),
            ],
          ),
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
            "SHOP",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AutodijeloviScreen(),
            ));
          },
        ),
        SizedBox(
          height: 12,
        ),
        ListTile(
          title: Text(
            "IZVJEŠTAJ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ReportScreen(),
            ));
          },
        ),
        SizedBox(
          height: 12,
        ),
        // ListTile(
        //   title: Text(
        //     "FINANSIJE",
        //     style: TextStyle(
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.yellow[700],
        //     ),
        //   ),
        //   onTap: () {
        //     Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => const FinansijeScreen(),
        //     ));
        //   },
        // ),
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
                        Icons.star,
                        color: Colors.yellow[700],
                        size: 30,
                      ),
                      Text(
                        "Prosječna ocjena $prosjecnaOcjena",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[700],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Klikni za više detalja!",
                    style: TextStyle(
                      fontSize: 12,
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
}
