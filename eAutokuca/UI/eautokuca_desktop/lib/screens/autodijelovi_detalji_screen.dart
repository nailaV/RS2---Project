// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'dart:convert';

import 'package:eautokuca_desktop/models/autodijelovi.dart';
import 'package:eautokuca_desktop/providers/autodijelovi_provider.dart';
import 'package:eautokuca_desktop/screens/autodijelovi_main_screen.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:eautokuca_desktop/widgets/uredi_autodio_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutodijeloviDetalji extends StatefulWidget {
  int autodioId;
  AutodijeloviDetalji({super.key, required this.autodioId});

  @override
  State<AutodijeloviDetalji> createState() => _AutodijeloviDetaljiState();
}

class _AutodijeloviDetaljiState extends State<AutodijeloviDetalji> {
  late AutodijeloviProvider _autodijeloviProvider;
  bool isLoading = true;
  Autodijelovi? autodioInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _autodijeloviProvider = context.read<AutodijeloviProvider>();
    getAutodioData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "PROIZVOD: ${autodioInfo?.autodioId}",
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
              child: Container(
                  child: Column(
                children: [_buildForm()],
              )),
            )),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 200.0, right: 200.0, top: 50.0, bottom: 50.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.blueGrey[50],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => const AutodijeloviScreen()));
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _buildFields(),
              SizedBox(
                height: 10,
                width: 10,
              ),
              SizedBox(height: 50),
              _buildButtons(),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _buildDescription() {
    return Container(
      padding: EdgeInsets.only(left: 7, right: 5, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Color.fromARGB(255, 92, 89, 89))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Opis proizvoda",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            autodioInfo?.opis ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Row _buildFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 20),
        autodioInfo?.slika != null && autodioInfo?.slika != ""
            ? Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(
                      base64Decode(autodioInfo!.slika!),
                    ),
                  ),
                ),
              )
            : Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: Icon(
                  Icons.no_photography_outlined,
                  size: 80,
                  color: Colors.white,
                ),
              ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 7, right: 5, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Color.fromARGB(255, 92, 89, 89))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Naziv"),
                        Text(
                          autodioInfo?.naziv ?? '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Cijena"),
                        Text(
                          "${autodioInfo?.cijena.toString() ?? " "}KM",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Na stanju"),
                        Text(
                          autodioInfo?.kolicinaNaStanju.toString() ?? '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildDescription()
            ],
          ),
        ),
      ],
    );
  }

  Row _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return UrediAutodio(
                      autodijelovi: autodioInfo!,
                    );
                  });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[700],
              foregroundColor: Colors.white,
            ),
            icon: Icon(Icons.edit),
            label: Text("Uredi proizvod")),
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[700],
            foregroundColor: Colors.white,
          ),
          icon: Icon(Icons.replay_outlined),
          label: Text("Promijeni stanje"),
        ),
      ],
    );
  }

  Future<void> getAutodioData() async {
    try {
      var data = await _autodijeloviProvider.getById(widget.autodioId);
      setState(() {
        autodioInfo = data;
        isLoading = false;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
