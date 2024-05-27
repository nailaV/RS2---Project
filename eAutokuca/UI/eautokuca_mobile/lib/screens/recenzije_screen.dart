// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:eautokuca_mobile/models/recenzije.dart';
import 'package:eautokuca_mobile/providers/korisnici_provider.dart';
import 'package:eautokuca_mobile/providers/recenzije_provider.dart';
import 'package:eautokuca_mobile/screens/lista_automobila.dart';
import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:eautokuca_mobile/utils/utils.dart';
import 'package:eautokuca_mobile/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecenzijeScreen extends StatefulWidget {
  const RecenzijeScreen({Key? key}) : super(key: key);

  @override
  State<RecenzijeScreen> createState() => _RecenzijeScreenState();
}

class _RecenzijeScreenState extends State<RecenzijeScreen> {
  int _ocjena = 0;
  int _userId = 0;
  final TextEditingController _sadrzajController = TextEditingController();
  late RecenzijeProvider _recenzijeProvider;
  late KorisniciProvider _korisniciProvider;
  late List<Recenzije>? recenzijaUsera = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _recenzijeProvider = context.read<RecenzijeProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    getData();
    getUserId();
  }

  Widget _buildZvjezdice(int index) {
    return IconButton(
      icon: Icon(
        index < _ocjena ? Icons.star : Icons.star_border,
        color: Colors.yellow[700],
        size: 30,
      ),
      onPressed: () {
        setState(() {
          _ocjena = index + 1;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Recenzije",
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (recenzijaUsera!.isEmpty) _buildDodajRecenziju(context),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: recenzijaUsera!.isNotEmpty
                          ? Column(
                              children: recenzijaUsera!
                                  .map((Recenzije e) => buildRes(e))
                                  .toList(),
                            )
                          : _buildNoDataField(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Container buildRes(Recenzije object) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                "Ocjena",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Text(
                object.ocjena.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
            height: 20,
          ),
          Row(
            children: [
              Icon(Icons.text_snippet, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                "Sadržaj",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            object.sadrzaj!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _ocjena = object.ocjena!;
                  _sadrzajController.text = object.sadrzaj!;
                });
                _showEditReviewDialog(object);
              },
              child: Text('Uredi'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
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
            color: Colors.blueGrey[50],
          ),
          child: Column(
            children: [
              Icon(Icons.info),
              SizedBox(height: 10),
              Text(
                "Nemate prethodno napisanih recenzija",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildDodajRecenziju(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.blueGrey[50],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => _buildZvjezdice(index)),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _sadrzajController,
            decoration: const InputDecoration(
              hintText: 'Napiši recenziju...',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final review = _sadrzajController.text;
              final rating = _ocjena;
              try {
                var request = {
                  "sadrzaj": review,
                  "korisnikId": _userId,
                  "ocjena": rating,
                };
                await _recenzijeProvider.insert(request);
                setState(() {
                  _ocjena = 0;
                  _sadrzajController.clear();
                });
                MyDialogs.showSuccess(context, "Hvala na recenziji!", () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => ListaAutomobila(),
                  ));
                });
              } catch (e) {
                MyDialogs.showError(context, e.toString());
              }
            },
            child: Text(
              'Objavi',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[700],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getUserId() async {
    try {
      var korisnikId = await _korisniciProvider.getKorisnikID();
      setState(() {
        _userId = korisnikId;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  Future<void> getData() async {
    try {
      var data =
          await _recenzijeProvider.getRecenzijeZaUsera(Authorization.username!);
      setState(() {
        recenzijaUsera = data;
        isLoading = false;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }

  void _showEditReviewDialog(Recenzije review) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Uredi recenziju',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => _buildZvjezdice(index)),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _sadrzajController,
                decoration: InputDecoration(
                  hintText: 'Uredi recenziju...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Odustani',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final reviewContent = _sadrzajController.text;
                final rating = _ocjena;
                try {
                  var request = {
                    "sadrzaj": reviewContent,
                    "ocjena": rating,
                  };
                  await _recenzijeProvider.update(review.recenzijeId!, request);
                  setState(() {
                    _ocjena = 0;
                    _sadrzajController.clear();
                  });
                  MyDialogs.showSuccess(context, "Recenzija uređena!", () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) => RecenzijeScreen(),
                    ));
                  });
                  getData();
                } catch (e) {
                  MyDialogs.showError(context, e.toString());
                }
              },
              child: Text(
                'Uredi',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
