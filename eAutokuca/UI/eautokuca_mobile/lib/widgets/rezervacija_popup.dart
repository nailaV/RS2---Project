// ignore_for_file: unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:eautokuca_mobile/providers/korisnici_provider.dart';
import 'package:eautokuca_mobile/providers/rezervacija_provider.dart';
import 'package:eautokuca_mobile/screens/rezervisani_termini_screen.dart';
import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:eautokuca_mobile/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RezervisiTermin extends StatefulWidget {
  final int carId;
  const RezervisiTermin({super.key, required this.carId});

  @override
  State<RezervisiTermin> createState() => _RezervisiTerminState();
}

class _RezervisiTerminState extends State<RezervisiTermin> {
  DateTime datum = DateTime.now();
  late RezervacijaProvider _rezervacijaProvider;
  late KorisniciProvider _korisniciProvider;
  bool isLoading = false;
  bool disabledButton = true;
  List<String> lista = [];
  String? termin;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _rezervacijaProvider = context.read<RezervacijaProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow,
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildHeader(context),
                    const Divider(thickness: 1, color: Colors.grey),
                    buildDateTimePickerButton(),
                    const SizedBox(height: 16),
                    termin != null ? buildSelectedTime() : Container(),
                    const SizedBox(height: 16),
                    buildTimeOptions(),
                    const SizedBox(height: 16),
                    buildButton(),
                  ],
                ),
        ),
      ),
    );
  }

  Row buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat.yMMMMd().format(datum),
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close, size: 24, color: Colors.black87))
      ],
    );
  }

  ElevatedButton buildDateTimePickerButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        backgroundColor: Colors.yellow[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () async {
        final DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.utc(2024, 12, 31),
        );
        if (date != null) {
          setState(() {
            datum = date;
            isLoading = true;
            termin = null;
            disabledButton = true;
          });
          getAvailableAppointments();
        } else {
          setState(() {
            disabledButton = true;
            termin = null;
          });
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month,
            color: Colors.white,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Izaberite datum",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildSelectedTime() {
    return Text(
      "Izabrani termin: $termin",
      style: const TextStyle(
          fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
    );
  }

  Widget buildTimeOptions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: lista.isEmpty
          ? Column(
              children: const [
                Icon(Icons.error_outline, size: 32, color: Colors.red),
                SizedBox(height: 8),
                Text(
                  "Nema dostupnih termina ili ste izabrali neradni dan.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ],
            )
          : Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children:
                  lista.map((String time) => buildTimeStamp(time)).toList(),
            ),
    );
  }

  Widget buildButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.yellow[700],
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: disabledButton
          ? null
          : () {
              String datumVrijeme = DateTime(
                datum.year,
                datum.month,
                datum.day,
                int.parse(termin!.split(':')[0]),
                int.parse(termin!.split(':')[1]),
              ).toIso8601String();
              try {
                var request = {
                  "automobilId": widget.carId,
                  "korisnikId": userId,
                  "datum": datumVrijeme
                };
                _rezervacijaProvider.kreirajRezervaciju(request);
                Navigator.of(context).pop({"OK": "OK"});
              } catch (e) {
                MyDialogs.showError(context, e.toString());
              }
            },
      child: const Text("Rezerviši"),
    );
  }

  GestureDetector buildTimeStamp(String time) {
    return GestureDetector(
      onTap: () {
        setState(() {
          termin = time;
          disabledButton = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.yellow[700]),
        child: Text(
          time,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Future<void> getAvailableAppointments() async {
    try {
      var satnice = await _rezervacijaProvider.getSlobodne(widget.carId, datum);
      setState(() {
        lista = satnice;
        isLoading = false;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  Future<void> getUserId() async {
    try {
      var korisnikId = await _korisniciProvider.getKorisnikID();
      setState(() {
        userId = korisnikId;
        isLoading = false;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
