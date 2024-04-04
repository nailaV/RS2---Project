// ignore_for_file: unused_import

//ignore_for_file: avoid_unnecessary_containers, unused_field, prefer_const_constructors, sized_box_for_whitespace

//import 'dart:html';

import 'package:eautokuca_desktop/models/car.dart';
import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/providers/car_provider.dart';
import 'package:eautokuca_desktop/screens/car_details_screen.dart';
import 'package:eautokuca_desktop/utils/utils.dart';
//import 'package:eautokuca_desktop/screens/car_details_screen.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ListaAutomobila extends StatefulWidget {
  const ListaAutomobila({super.key});

  @override
  State<ListaAutomobila> createState() => _ListaAutomobilaState();
}

class _ListaAutomobilaState extends State<ListaAutomobila> {
  late CarProvider _carProvider;
  SearchResult<Car>? result;
  bool isLoading = true;
  TextEditingController _bojaController = new TextEditingController();
  TextEditingController _markaModelContorller = new TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _carProvider = context.read<CarProvider>();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carProvider = context.read<CarProvider>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "POČETNA",
        child: Container(
            child: Column(
          children: [_buildSeacrh(), _buildDataListView()],
        )));
  }

  Future<void> getData() async {
    try {
      var data = await _carProvider.get();
      setState(() {
        result = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Text("Error"),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Ok"))
                  ]));
    }
  }

  Widget _buildSeacrh() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Boja",
                labelStyle: TextStyle(color: Colors.yellow),
                prefixIcon: Icon(Icons.search, color: Colors.yellow),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow)),
              ),
              controller: _bojaController,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Model ili marka",
                labelStyle: TextStyle(color: Colors.yellow),
                prefixIcon: Icon(Icons.search, color: Colors.yellow),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow)),
              ),
              controller: _markaModelContorller,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                var data = await _carProvider.get(filter: {
                  'boja': _bojaController.text,
                  'FTS': _markaModelContorller.text
                });

                setState(() {
                  result = data;
                });
              },
              child: Text('Pretraga'))
        ],
      ),
    );
  }

  Expanded _buildDataListView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: result?.result.length ?? 0,
          itemBuilder: (context, index) {
            Car car = result!.result[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CarDetailsScreen(car: car),
                ));
              },
              child: Card(
                elevation: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    car.slike != null && car.slike != ""
                        ? Container(
                            width: double.infinity,
                            height: 150,
                            child: imageFromBase64String(car.slike!),
                          )
                        : Text("No image available."),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${car.marka ?? ""} ${car.model ?? ""}",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                    Text(
                      car.godinaProizvodnje.toString(),
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.black),
                    ),
                    Text(
                      "${car.cijena.toString()} KM",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
