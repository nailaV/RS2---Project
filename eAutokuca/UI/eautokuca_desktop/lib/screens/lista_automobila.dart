// ignore_for_file: avoid_unnecessary_containers

import 'package:eautokuca_desktop/screens/car_details_screen.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ListaAutomobila extends StatefulWidget {
  const ListaAutomobila({super.key});

  @override
  State<ListaAutomobila> createState() => _ListaAutomobilaState();
}

class _ListaAutomobilaState extends State<ListaAutomobila> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "CAR LIST",
        child: Container(
            child: Column(
          children: [
            Text('TestTest'),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CarDetailsScreen(),
                  ));
                },
                child: Text('See details'))
          ],
        )));
  }
}
