import 'dart:convert';
import 'dart:io';

import 'package:eautokuca_desktop/providers/korisnici_provider.dart';
import 'package:eautokuca_desktop/screens/korisnici_screen.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class DodajKorisnika extends StatefulWidget {
  const DodajKorisnika({super.key});

  @override
  State<DodajKorisnika> createState() => _DodajKorisnikaState();
}

class _DodajKorisnikaState extends State<DodajKorisnika> {
  late KorisniciProvider _korisniciProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  File? _slika;
  String? _slikaBase64;
  String? message = "Klikni da dodaš sliku";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
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
            map['slikaBase64'] = _slikaBase64;
            try {
              await _korisniciProvider.insert(map);
              MyDialogs.showSuccess(
                  context, "Uspješno registrovan novi korisnik.", () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => const KorisniciScreen()));
              });
            } on Exception catch (e) {
              MyDialogs.showError(context, e.toString());
            }
          }
        }
      },
      child: const Text(
        'Registruj',
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
            name: 'ime',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Ime',
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
            name: 'prezime',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Prezime',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'email',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Email',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'telefon',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Broj telefona',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'username',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Username',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'password',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Šifra',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
        SizedBox(
          width: 230,
          child: FormBuilderTextField(
            cursorColor: Colors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'passwordPotvrda',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Ponoviti šifru',
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
