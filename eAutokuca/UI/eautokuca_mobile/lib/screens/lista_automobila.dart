// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:eautokuca_mobile/models/car.dart';
import 'package:eautokuca_mobile/models/korisnici.dart';
import 'package:eautokuca_mobile/models/search_result.dart';
import 'package:eautokuca_mobile/providers/car_provider.dart';
import 'package:eautokuca_mobile/providers/korisnici_provider.dart';
import 'package:eautokuca_mobile/screens/car_details_screen.dart';
import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:eautokuca_mobile/utils/utils.dart';
import 'package:eautokuca_mobile/widgets/filter_car_popup.dart';
import 'package:eautokuca_mobile/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ListaAutomobila extends StatefulWidget {
  Car? car;
  ListaAutomobila({Key? key, this.car}) : super(key: key);

  @override
  State<ListaAutomobila> createState() => _ListaAutomobilaState();
}

class _ListaAutomobilaState extends State<ListaAutomobila> {
  late CarProvider _carProvider;
  SearchResult<Car>? carData;
  late KorisniciProvider _korisniciProvider;
  Korisnici? korisnikInfo;
  TextEditingController _markaModelController = TextEditingController();
  Map<String, dynamic>? filters;
  int currentPage = 1;
  int pageSize = 3;

  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carProvider = context.read<CarProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
  }

  @override
  void initState() {
    super.initState();
    _carProvider = context.read<CarProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    getSveAutomobile();
    getKorisniciInfo();
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  _buildLogoSearch(),
                  (carData != null)
                      ? Column(
                          children: carData?.list
                                  .map((Car automobil) =>
                                      buildCarContainer(automobil))
                                  .toList() ??
                              [],
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                  _buildPageing()
                ],
              ),
            ),
    );
  }

  Padding _buildPageing() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          currentPage > 1
              ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage--;
                      isLoading = true;
                    });
                    getSveAutomobile();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    elevation: 3,
                  ),
                  child: Icon(Icons.arrow_back),
                )
              : SizedBox.shrink(),
          SizedBox(width: 10),
          currentPage < (carData!.total ?? 0)
              ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage++;
                      isLoading = true;
                    });
                    getSveAutomobile();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    elevation: 3,
                  ),
                  child: Icon(Icons.arrow_forward))
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  GestureDetector buildCarContainer(Car item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CarDetailsScreen(car: item),
        ));
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blueGrey[50],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey[50],
                  ),
                  height: 200,
                  width: 300,
                  child: item.slike != ""
                      ? SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: imageFromBase64String(item.slike!),
                        )
                      : const Center(
                          child: Icon(
                            Icons.no_photography,
                            size: 35,
                            color: Colors.black87,
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${item.marka ?? ""} ${item.model ?? ""}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.godinaProizvodnje.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item.cijena}KM",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _buildLogoSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            var data = await _carProvider.Filtriraj({'FTS': "Audi"});
            setState(() {
              carData = data;
            });
          },
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset('assets/images/audiLogo.png'),
          ),
        ),
        GestureDetector(
          onTap: () async {
            var data = await _carProvider.Filtriraj({'FTS': "BMW"});
            setState(() {
              carData = data;
            });
          },
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset('assets/images/bmwLogo.png'),
          ),
        ),
        GestureDetector(
          onTap: () async {
            var data = await _carProvider.Filtriraj({'FTS': "Kia"});
            setState(() {
              carData = data;
            });
          },
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset('assets/images/kiaLogo.png'),
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
              var data = await _carProvider.Filtriraj(
                {'FTS': _markaModelController.text},
              );
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
                  borderSide: BorderSide(color: Colors.yellow),
                ),
              ),
              controller: _markaModelController,
            ),
          ),
          MaterialButton(
            padding: EdgeInsets.all(10),
            shape: CircleBorder(),
            color: Colors.yellow[700],
            onPressed: () async {
              var rezultat = await showDialog(
                  context: context, builder: (context) => const FilterData());
              if (rezultat != null) {
                filters = Map.from(rezultat);
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

  Future<void> fetchPaged(dynamic request) async {
    try {
      var data = await _carProvider.Filtriraj(request);
      setState(() {
        carData = data;
        isLoading = false;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  Future<void> getKorisniciInfo() async {
    try {
      var data =
          await _korisniciProvider.getByUseranme(Authorization.username!);
      setState(() {
        korisnikInfo = data;
      });
    } on Exception catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  Future<void> getSveAutomobile() async {
    try {
      var data = await _carProvider.Filtriraj({
        "PageSize": pageSize,
        "Page": currentPage,
        "AktivniNeaktivni": "Aktivan"
      });
      setState(() {
        carData = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
