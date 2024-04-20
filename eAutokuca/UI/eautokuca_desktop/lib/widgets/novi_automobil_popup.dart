// ignore_for_file: must_be_immutable, prefer_const_constructors, use_build_context_synchronously, unused_field

import 'dart:convert';
import 'dart:io';

import 'package:eautokuca_desktop/providers/car_provider.dart';
import 'package:eautokuca_desktop/screens/lista_automobila.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class NoviAutomobil extends StatefulWidget {
  //Car car;
  const NoviAutomobil({super.key});

  @override
  State<NoviAutomobil> createState() => _NoviAutomobilState();
}

class _NoviAutomobilState extends State<NoviAutomobil> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late CarProvider _carProvider;
  String? _selectedMjenjac;
  File? _slika;
  String? _slikaBase64;
  String? message = "Klikni da dodaš sliku";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carProvider = context.read<CarProvider>();
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
            try {
              await _carProvider.insert(_formKey.currentState?.value);
              MyDialogs.showSuccess(context, "Uspješno dodan novi automobil.",
                  () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => const ListaAutomobila()));
              });
            } on Exception catch (e) {
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
            name: 'model',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Model',
                labelStyle: TextStyle(fontSize: 14)),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: "Polje je obavezno."),
              (value) {
                if (value != null && value.startsWith(" ")) {
                  return "Počnite sa slovima";
                } else {
                  return null;
                }
              }
            ]),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'marka',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Marka',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderDropdown(
            name: 'mjenjac',
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              labelText: 'Transmisija',
              labelStyle: TextStyle(fontSize: 14),
            ),
            initialValue: _selectedMjenjac,
            items: ['Automatik', 'Manuelni']
                .map((mjenjac) => DropdownMenuItem(
                      value: mjenjac,
                      child: Text(mjenjac),
                    ))
                .toList(),
            onChanged: (mjenjac) {
              setState(() {
                _selectedMjenjac = mjenjac.toString();
              });
            },
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'motor',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Motor',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'godinaProizvodnje',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'GodinaProizvodnje',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'predjeniKilometri',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Pređeni kilometri',
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
            name: 'brojSasije',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Broj šasije',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'snagaMotora',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Snaga motora',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'brojVrata',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Broj vrata',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'boja',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Boja',
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
      _slikaBase64 = base64UrlEncode(_slika!.readAsBytesSync());
      setState(() {
        message = result.files.single.name.toString();
      });
    }
  }
}
