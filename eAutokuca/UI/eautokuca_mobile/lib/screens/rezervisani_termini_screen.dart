// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:eautokuca_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:eautokuca_mobile/models/rezervacija.dart';
import 'package:eautokuca_mobile/providers/rezervacija_provider.dart';
import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:eautokuca_mobile/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class RezervisaniTermini extends StatefulWidget {
  const RezervisaniTermini({Key? key}) : super(key: key);

  @override
  State<RezervisaniTermini> createState() => _RezervisaniTerminiState();
}

class _RezervisaniTerminiState extends State<RezervisaniTermini> {
  late RezervacijaProvider _rezervacijaProvider;
  late List<Rezervacija>? rezervacijaData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _rezervacijaProvider = context.read<RezervacijaProvider>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Rezervisani termini",
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: rezervacijaData!.isNotEmpty
                      ? Column(
                          children: rezervacijaData!
                              .map((Rezervacija e) => buildTestDriveBox(e))
                              .toList())
                      : _buildNoDataField(),
                ),
              ));
  }

  Container buildTestDriveBox(Rezervacija object) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow),
            borderRadius: BorderRadius.circular(30),
            color: Colors.blueGrey[50]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month),
                    Text("Datum"),
                  ],
                ),
                Text(
                  object.datum,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      fontSize: 15),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time_outlined),
                    Text("Vrijeme"),
                  ],
                ),
                Text(
                  object.vrijeme,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      fontSize: 15),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.car_crash_outlined),
                    Text("Automobil"),
                  ],
                ),
                Text(
                  object.auto,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      fontSize: 15),
                )
              ],
            ),
          ],
        ));
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
                  "Nemate prethodno rezervisanih termina",
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
      var data = await _rezervacijaProvider
          .getRezervacijeZaUsera(Authorization.username!);
      setState(() {
        rezervacijaData = data;
        isLoading = false;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
