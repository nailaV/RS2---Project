// ignore_for_file: must_be_immutable, prefer_const_constructors, camel_case_types

//import 'dart:ffi';

import 'package:eautokuca_desktop/screens/korisnici_screen.dart';
import 'package:eautokuca_desktop/screens/lista_automobila.dart';
import 'package:eautokuca_desktop/screens/rezervacije_screen.dart';
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text("User Name",
              style: TextStyle(
                color: Colors.black,
              )),
          accountEmail: Text("user@example.com",
              style: TextStyle(
                color: Colors.black,
              )),
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          decoration: BoxDecoration(
            color: Colors.yellow[700],
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
          // onTap: () {
          //   Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => const MyApp(),
          //   ));
          // },
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
