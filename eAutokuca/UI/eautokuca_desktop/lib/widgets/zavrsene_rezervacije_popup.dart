// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:eautokuca_desktop/models/rezervacija.dart';
import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/providers/rezervacija_provider.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ZavrseneRezervacije extends StatefulWidget {
  const ZavrseneRezervacije({super.key});

  @override
  State<ZavrseneRezervacije> createState() => _ZavrseneRezervacijeState();
}

class _ZavrseneRezervacijeState extends State<ZavrseneRezervacije> {
  late RezervacijaProvider _rezervacijaProvider;
  SearchResult<Rezervacija>? zavrseneResult;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rezervacijaProvider = context.read<RezervacijaProvider>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[300],
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(15),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: (zavrseneResult != null &&
                          zavrseneResult!.result.isNotEmpty)
                      ? Column(
                          children: zavrseneResult!.result
                              .map((Rezervacija r) => buildRes(r))
                              .toList(),
                        )
                      : _buildNoDataField(),
                ),
              ),
      ),
    );
  }

  Container buildRes(Rezervacija object) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow),
        borderRadius: BorderRadius.circular(30),
        color: Colors.blueGrey[50],
      ),
      child: Column(
        children: [
          buildRow(Icons.calendar_month, "Datum", object.datum),
          const SizedBox(height: 10),
          buildRow(Icons.access_time_outlined, "Vrijeme", object.vrijeme),
          const SizedBox(height: 10),
          buildRow(Icons.car_crash_outlined, "Automobil", object.auto),
          const SizedBox(height: 10),
          buildRow(
              Icons.car_crash_outlined, "Status", object.status.toString()),
        ],
      ),
    );
  }

  Row buildRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon),
            SizedBox(width: 5),
            Text(label),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Padding _buildNoDataField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
            padding: EdgeInsets.only(left: 50, right: 50, top: 30, bottom: 30),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
                color: Colors.blueGrey[50]),
            child: Column(
              children: [
                Icon(Icons.info),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Nema završenih ili otkazanih termina.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
      ),
    );
  }

  Future<void> getData() async {
    try {
      var data = await _rezervacijaProvider.getZavrsene();
      setState(() {
        zavrseneResult = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      setState(() {
        isLoading = false;
      });
      MyDialogs.showError(context, e.toString());
    }
  }
}
