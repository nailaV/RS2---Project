// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:eautokuca_desktop/models/autodijelovi.dart';
import 'package:eautokuca_desktop/providers/autodijelovi_provider.dart';
import 'package:eautokuca_desktop/screens/autodijelovi_detalji_screen.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class UrediAutodio extends StatefulWidget {
  Autodijelovi autodijelovi;
  UrediAutodio({super.key, required this.autodijelovi});

  @override
  State<UrediAutodio> createState() => _UrediAutodioState();
}

class _UrediAutodioState extends State<UrediAutodio> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AutodijeloviProvider _autodijeloviProvider;
  File? _slika;
  String? _slikaBase64;
  String? message = "Klikni da dodaš sliku";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _autodijeloviProvider = context.read<AutodijeloviProvider>();
    _initialValue = {
      "cijena": widget.autodijelovi.cijena.toString(),
      "naziv": widget.autodijelovi.naziv,
      "kolicinaNaStanju": widget.autodijelovi.kolicinaNaStanju.toString(),
      "status": widget.autodijelovi.status,
      "opis": widget.autodijelovi.opis,
      "slika": widget.autodijelovi.slika
    };
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[300],
      child: Container(
        width: 600,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            initialValue: _initialValue,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 0.3,
                  color: Colors.blueGrey,
                  height: 25,
                ),
                buildInputs(context),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 42,
                  child: buildButtons(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  MaterialButton buildButtons(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.yellow[700],
      onPressed: () async {
        if (_formKey.currentState != null) {
          if (_formKey.currentState!.saveAndValidate()) {
            Map<String, dynamic> map = Map.from(_formKey.currentState!.value);
            map['slika'] = _slikaBase64;
            try {
              await _autodijeloviProvider.update(
                  widget.autodijelovi.autodioId!, map);
              MyDialogs.showSuccess(context, "Uspješno sačuvane promjene.", () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => AutodijeloviDetalji(
                        autodioId: widget.autodijelovi.autodioId!)));
              });
            } catch (e) {
              MyDialogs.showError(context, e.toString());
            }
          }
        }
      },
      child: const Text(
        'Sačuvaj',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Wrap buildInputs(BuildContext context) {
    return Wrap(
      spacing: 15,
      runSpacing: 20,
      children: [
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'naziv',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Naziv',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'cijena',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Cijena',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'kolicinaNaStanju',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Količina',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'status',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Status',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'opis',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Opis',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        FormBuilderField(
          name: 'slikaBase64',
          builder: (field) {
            return SizedBox(
              width: 250,
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    hintText: message,
                    suffixIcon: const Icon(Icons.add),
                    errorText: field.errorText),
                onTap: uploadujSliku,
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> uploadujSliku() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      _slika = File(result.files.single.path!);
      _slikaBase64 = base64Encode(_slika!.readAsBytesSync());
      setState(() {
        message = result.files.single.name.toString();
      });
    }
  }
}
