// ignore_for_file: unused_import, use_super_parameters, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_final_fields, unused_element

//ignore_for_file: avoid_unnecessary_containers, unused_field, prefer_const_constructors, sized_box_for_whitespace

//import 'dart:html';

import 'package:eautokuca_desktop/models/car.dart';
import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/providers/car_provider.dart';
import 'package:eautokuca_desktop/screens/car_details_screen.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/utils/utils.dart';
import 'package:eautokuca_desktop/widgets/filter_popup.dart';
//import 'package:eautokuca_desktop/screens/car_details_screen.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:eautokuca_desktop/widgets/novi_automobil_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ListaAutomobila extends StatefulWidget {
  final Car? car;
  const ListaAutomobila({Key? key, this.car}) : super(key: key);

  @override
  State<ListaAutomobila> createState() => _ListaAutomobilaState();
}

class _ListaAutomobilaState extends State<ListaAutomobila>
    with TickerProviderStateMixin {
  late CarProvider _carProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  Map<String, dynamic>? filters;
  SearchResult<Car>? result;
  bool isLoading = true;
  String UcitajAktivne = "Aktivan";
  String Prodan = "";
  List<String> _listaMarki = [];
  TextEditingController _markaModelContorller = TextEditingController();
  String selectedButton = "Aktivan";

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
    _initialValue = {
      "motor": widget.car?.motor,
      "mjenjac": widget.car?.mjenjac,
      "boja": widget.car?.boja,
      "cijena": widget.car?.cijena.toString(),
      "godinaProizvodnje": widget.car?.godinaProizvodnje.toString(),
      "predjeniKilometri": widget.car?.predjeniKilometri.toString(),
      "brojSasije": widget.car?.brojSasije,
      "snagaMotora": widget.car?.snagaMotora,
      "brojVrata": widget.car?.brojVrata.toString(),
      "model": widget.car?.model,
      "marka": widget.car?.marka,
      "status": widget.car?.status,
      "slike": widget.car?.slike
    };
    _carProvider = context.read<CarProvider>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "POČETNA",
        child: Container(
            child: Column(
          children: [
            _buildSeacrh(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedButton = "Aktivan";
                      UcitajAktivne = "Aktivan";
                      Prodan = "";
                      isLoading = true;
                    });
                    getData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedButton == "Aktivan"
                        ? Colors.green
                        : Colors.white,
                    foregroundColor: selectedButton == "Aktivan"
                        ? Colors.white
                        : Colors.green,
                  ),
                  child: Text("Aktivni"),
                ),
                SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedButton = "Neaktivan";
                      UcitajAktivne = "Neaktivan";
                      Prodan = "";
                      isLoading = true;
                    });
                    getData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedButton == "Neaktivan"
                        ? Colors.red
                        : Colors.white,
                    foregroundColor: selectedButton == "Neaktivan"
                        ? Colors.white
                        : Colors.red,
                  ),
                  child: Text("Neaktivni"),
                ),
                SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedButton = "Prodan";
                      Prodan = "Prodan";
                      UcitajAktivne = "";
                      isLoading = true;
                    });
                    getData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedButton == "Prodan" ? Colors.blue : Colors.white,
                    foregroundColor:
                        selectedButton == "Prodan" ? Colors.white : Colors.blue,
                  ),
                  child: Text("Prodani"),
                ),
              ],
            ),
            _buildDataListView(),
            _buildButton()
          ],
        )));
  }

  Future<void> getData() async {
    try {
      var data = await _carProvider.Filtriraj(
          {"AktivniNeaktivni": UcitajAktivne, "Status": Prodan});
      setState(() {
        result = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MaterialButton(
            padding: EdgeInsets.all(15),
            shape: CircleBorder(),
            color: Colors.yellow[700],
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return NoviAutomobil();
                  });
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeacrh() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
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
          SizedBox(width: 10),
          MaterialButton(
            padding: EdgeInsets.all(15),
            shape: CircleBorder(),
            color: Colors.yellow[700],
            onPressed: () async {
              var data = await _carProvider.Filtriraj({
                'FTS': _markaModelContorller.text,
                "AktivniNeaktivni": UcitajAktivne
              });

              setState(() {
                result = data;
              });
            },
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          MaterialButton(
            padding: EdgeInsets.all(15),
            shape: CircleBorder(),
            color: Colors.yellow[700],
            onPressed: () async {
              var rezultat = await showDialog(
                  context: context, builder: (context) => const FilterData());
              if (rezultat != null) {
                filters = Map.from(rezultat);
                filters?["AktivniNeaktivni"] = UcitajAktivne;
                setState(() {
                  isLoading = true;
                });
                fetchPaged(filters);
              }
            },
            child: Icon(
              Icons.tune,
              color: Colors.white,
            ),
          ),
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

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeIn,
          )),
          child: Container(
            alignment: Alignment.bottomCenter,
            child: FilterData(),
          ),
        );
      },
    );
  }

  Future<void> fetchPaged(dynamic request) async {
    try {
      //filters!['Page'] = _currentPage;
      var data = await _carProvider.Filtriraj(request);
      setState(() {
        result = data;
        isLoading = false;
        //clearFilters=true;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
