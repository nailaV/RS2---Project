// ignore_for_file: prefer_const_constructors

import 'package:eautokuca_desktop/models/korisnici.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class PosaljiEmail extends StatefulWidget {
  final Korisnici korisnik;

  const PosaljiEmail({super.key, required this.korisnik});

  @override
  State<PosaljiEmail> createState() => _PosaljiEmailState();
}

class _PosaljiEmailState extends State<PosaljiEmail> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            initialValue: _initialValue,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Slanje mail poruke: ${widget.korisnik.ime} ${widget.korisnik.prezime}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                  width: double.infinity,
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
      onPressed: () {
        if (_formKey.currentState?.saveAndValidate() ?? false) {
          final formData = _formKey.currentState?.value;

          print('Sending email with data: $formData');
        }
      },
      child: const Text(
        'Pošalji',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Column buildInputs(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormBuilderTextField(
          cursorColor: Colors.grey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Polje je obavezno."),
            FormBuilderValidators.email(errorText: "Unesite ispravan email."),
          ]),
          name: 'primalac',
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            labelText: 'Primalac',
            labelStyle: TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(height: 20),
        FormBuilderTextField(
          cursorColor: Colors.grey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'Polje je obavezno'),
          ]),
          name: 'predmet',
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.subject),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            labelText: 'Predmet',
            labelStyle: TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(height: 20),
        FormBuilderTextField(
          cursorColor: Colors.grey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Polje je obavezno"),
          ]),
          name: 'poruka',
          maxLines: 5,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.message),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            labelText: 'Poruka',
            labelStyle: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
