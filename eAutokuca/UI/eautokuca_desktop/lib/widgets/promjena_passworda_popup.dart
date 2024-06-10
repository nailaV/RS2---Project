// ignore_for_file: must_be_immutable, unused_import, prefer_const_constructors

import 'dart:convert';

import 'package:eautokuca_desktop/main.dart';
import 'package:eautokuca_desktop/models/korisnici.dart';
import 'package:eautokuca_desktop/providers/korisnici_provider.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class PromjenaPassworda extends StatefulWidget {
  int korisnikId;
  PromjenaPassworda({super.key, required this.korisnikId});

  @override
  State<PromjenaPassworda> createState() => _KorisnickiProfilState();
}

class _KorisnickiProfilState extends State<PromjenaPassworda> {
  late KorisniciProvider _korisniciProvider;
  Korisnici? korisnikInfo;
  bool _obscurePass1 = true;
  bool _obscurePass2 = true;
  bool _obscurePass3 = true;

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _buildDialog());
  }

  Widget _buildDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      alignment: Alignment.center,
      backgroundColor: Colors.grey[300],
      child: SingleChildScrollView(
        child: Container(
          width: 700,
          padding: const EdgeInsets.all(20),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        splashRadius: 27,
                        color: Colors.blueGrey,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 25,
                          color: Colors.black,
                        ))
                  ],
                ),
                const Divider(
                  thickness: 0.3,
                  color: Colors.blueGrey,
                  height: 25,
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [_buildInputs()],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildInputs() {
    return Column(
      children: [
        FormBuilderTextField(
          name: "stariPassword",
          obscureText: _obscurePass1,
          decoration: InputDecoration(
              labelText: "Trenutna šifra",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePass1 = !_obscurePass1;
                    });
                  },
                  icon: Icon(_obscurePass1
                      ? Icons.visibility_off
                      : Icons.visibility))),
          validator:
              FormBuilderValidators.required(errorText: 'Polje je obavezno'),
        ),
        SizedBox(
          height: 10,
        ),
        FormBuilderTextField(
          name: "noviPassword",
          obscureText: _obscurePass2,
          decoration: InputDecoration(
              labelText: "Nova šifra",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePass2 = !_obscurePass2;
                    });
                  },
                  icon: Icon(_obscurePass2
                      ? Icons.visibility_off
                      : Icons.visibility))),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'Polje je obavezno'),
            FormBuilderValidators.minLength(8,
                errorText: 'Minimalna dužina je 8 karaktera'),
            FormBuilderValidators.match(
                r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$',
                errorText:
                    'Mora sadržavati slova, brojeve i specijalne karaktere.'),
          ]),
        ),
        SizedBox(
          height: 10,
        ),
        FormBuilderTextField(
          name: "noviPasswordProvjera",
          obscureText: _obscurePass3,
          decoration: InputDecoration(
              labelText: "Potvrda nove šifre",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePass3 = !_obscurePass3;
                    });
                  },
                  icon: Icon(_obscurePass3
                      ? Icons.visibility_off
                      : Icons.visibility))),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Polje je obavezno';
            }
            if (val != _formKey.currentState?.fields['noviPassword']?.value) {
              return 'Šifre se ne podudaraju';
            }
            return null;
          },
        ),
        SizedBox(
          height: 10,
        ),
        _buildButton()
      ],
    );
  }

  Center _buildButton() {
    return Center(
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(15),
        color: Colors.yellow[700],
        onPressed: () async {
          if (_formKey.currentState != null) {
            if (_formKey.currentState!.saveAndValidate()) {
              try {
                await _korisniciProvider.promjenaPassworda(
                    widget.korisnikId, _formKey.currentState!.value);
                MyDialogs.showSuccess(context,
                    "Uspješno promijenjena šifra. Molimo da se ponovo logirate.",
                    () {
                  Authorization.username = "";
                  Authorization.password = "";
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (builder) => const MyApp()));
                });
              } catch (e) {
                MyDialogs.showError(context, e.toString());
              }
            }
          }
        },
        child: Text(
          "Promijeni šifru",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
