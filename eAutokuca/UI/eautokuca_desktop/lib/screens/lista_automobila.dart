// ignore_for_file: avoid_unnecessary_containers, unused_field, prefer_const_constructors

import 'package:eautokuca_desktop/providers/car_provider.dart';
//import 'package:eautokuca_desktop/screens/car_details_screen.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class ListaAutomobila extends StatefulWidget {
  const ListaAutomobila({super.key});

  @override
  State<ListaAutomobila> createState() => _ListaAutomobilaState();
}

class _ListaAutomobilaState extends State<ListaAutomobila> {
  late CarProvider _carProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _carProvider = context.read<CarProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "CAR LIST",
        child: Container(
            child: Column(
          children: [
            Text('All cars listed'),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  print("click");
                  var data = await _carProvider.get();
                  print("${data['result'][0]['marka']}");
                },
                child: Text('See details'))
          ],
        )));
  }
}
