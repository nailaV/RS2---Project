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
  TextEditingController _bojaController = new TextEditingController();
  //TextEditingController _passwordController = new TextEditingController();

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
          children: [_buildSeacrh(), _buildDataListView()],
        )));
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
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                var data = await _carProvider
                    .get(filter: {'boja': _bojaController.text});

                setState(() {
                  result = data;
                });
                //print("${data.result[0].mjenjac}");
              },
              child: Text('Pretraga'))
        ],
      ),
    );
  }

  Expanded _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: DataTable(
          columns: const [
            DataColumn(
                label: Expanded(
                    child: Text("ID",
                        style: TextStyle(fontStyle: FontStyle.italic)))),
            DataColumn(
                label: Expanded(
                    child: Text("Mjenjac",
                        style: TextStyle(fontStyle: FontStyle.italic)))),
            DataColumn(
                label: Expanded(
                    child: Text("Motor",
                        style: TextStyle(fontStyle: FontStyle.italic)))),
            DataColumn(
                label: Expanded(
                    child: Text("Boja",
                        style: TextStyle(fontStyle: FontStyle.italic)))),
            DataColumn(
                label: Expanded(
                    child: Text("Cijena",
                        style: TextStyle(fontStyle: FontStyle.italic)))),
            DataColumn(
                label: Expanded(
                    child: Text("Slika",
                        style: TextStyle(fontStyle: FontStyle.italic))))
          ],
          rows: result?.result
                  .map((Car e) => DataRow(
                          onSelectChanged: (s) => {
                                if (s == true)
                                  {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          CarDetailsScreen(car: e),
                                    ))
                                  }
                              },
                          cells: [
                            DataCell(Text(e.automobilId?.toString() ?? "")),
                            DataCell(Text(e.mjenjac ?? "")),
                            DataCell(Text(e.motor ?? "")),
                            DataCell(Text(e.boja ?? "")),
                            DataCell(Text(e.cijena.toString())),
                            DataCell(e.slika != null && e.slika != ""
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    child: imageFromBase64String(e.slika!),
                                  )
                                : Text("No image available."))
                          ]))
                  .toList() ??
              []),
    ));
  }
}
