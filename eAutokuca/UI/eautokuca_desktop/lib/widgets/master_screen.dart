// ignore_for_file: must_be_immutable

//import 'dart:ffi';

import 'package:eautokuca_desktop/main.dart';
import 'package:eautokuca_desktop/screens/car_details_screen.dart';
import 'package:eautokuca_desktop/screens/lista_automobila.dart';
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
        title: Text(widget.title ?? ""),
        backgroundColor: Colors.yellow[700],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("All cars"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ListaAutomobila(),
                ));
              },
            ),
            ListTile(
              title: Text("Car details"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CarDetailsScreen(),
                ));
              },
            ),
            ListTile(
              title: Text("Login"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MyApp(),
                ));
              },
            ),
          ],
        ),
      ),
      body: widget.child!,
    );
  }
}
