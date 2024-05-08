// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:eautokuca_mobile/models/car.dart';
import 'package:eautokuca_mobile/models/korisnici.dart';
import 'package:eautokuca_mobile/models/search_result.dart';
import 'package:eautokuca_mobile/providers/car_provider.dart';
import 'package:eautokuca_mobile/providers/korisnici_provider.dart';
import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:eautokuca_mobile/utils/utils.dart';
import 'package:eautokuca_mobile/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListaAutomobila extends StatefulWidget {
  const ListaAutomobila({super.key});

  @override
  State<ListaAutomobila> createState() => _ListaAutomobilaState();
}

class _ListaAutomobilaState extends State<ListaAutomobila> {
  late CarProvider _carProvider;
  SearchResult<Car>? carData;
  late KorisniciProvider _korisniciProvider;
  Korisnici? korisnikInfo;
  TextEditingController _markaModelController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKorisniciInfo();
    getSveAutomobile();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Dobrodošli, ${korisnikInfo?.ime ?? ""}",
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSeacrh(),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Popularni brendovi",
                          style: TextStyle(
                              color: Colors.yellow[700],
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    _buildLogoSearch(),
                  ],
                ),
              ));
  }

  Row _buildLogoSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            var data = await _carProvider.getAll(filter: {'Marka': "Audi"});
            setState(() {
              carData = data;
            });
          },
          child: Image.asset(
            width: 100,
            height: 100,
            'assets/images/audiLogo.png',
          ),
        ),
        GestureDetector(
          onTap: () async {
            var data = await _carProvider.getAll(filter: {'Marka': "BMW"});
            setState(() {
              carData = data;
            });
          },
          child: Image.asset(
            width: 100,
            height: 100,
            'assets/images/bmwLogo.png',
          ),
        ),
        GestureDetector(
          onTap: () async {
            var data = await _carProvider.getAll(filter: {'Marka': "Kia"});
            setState(() {
              carData = data;
            });
          },
          child: Image.asset(
            width: 100,
            height: 100,
            'assets/images/kiaLogo.png',
          ),
        ),
      ],
    );
  }

  Widget _buildSeacrh() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          MaterialButton(
            padding: EdgeInsets.all(10),
            shape: CircleBorder(),
            color: Colors.yellow[700],
            onPressed: () async {
              var data = await _carProvider
                  .getAll(filter: {'FTS': _markaModelController.text});
              setState(() {
                carData = data;
              });
            },
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: "Model ili marka",
                labelStyle: TextStyle(color: Colors.yellow),
                prefixIcon: Icon(Icons.search, color: Colors.yellow),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow)),
              ),
              controller: _markaModelController,
            ),
          ),
          MaterialButton(
            padding: EdgeInsets.all(10),
            shape: CircleBorder(),
            color: Colors.yellow[700],
            onPressed: () async {
              // var rezultat = await showDialog(
              //     context: context, builder: (context) => const FilterData());
              // if (rezultat != null) {
              //   filters = Map.from(rezultat);

              //   setState(() {
              //     isLoading = true;
              //   });
              //   fetchPaged(filters);
              // }
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

  Future<void> getKorisniciInfo() async {
    try {
      var data =
          await _korisniciProvider.getByUseranme(Authorization.username!);
      setState(() {
        korisnikInfo = data;
        //isLoading = true;
      });
    } on Exception catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  Future<void> getSveAutomobile() async {
    try {
      var data = await _carProvider.getAll();
      setState(() {
        carData = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
