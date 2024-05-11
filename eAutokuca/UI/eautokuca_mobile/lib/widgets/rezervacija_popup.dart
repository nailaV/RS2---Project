// ignore_for_file: unused_field

import 'package:eautokuca_mobile/providers/rezervacija_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class RezervisiTermin extends StatefulWidget {
  const RezervisiTermin({super.key});

  @override
  State<RezervisiTermin> createState() => _RezervisiTerminState();
}

class _RezervisiTerminState extends State<RezervisiTermin> {
  late RezervacijaProvider _rezervacijaProvider;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rezervacijaProvider = context.read<RezervacijaProvider>();
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
          decoration: InputDecoration(
              labelText: "Trenutna šifra",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
              suffixIcon: MaterialButton(
                onPressed: () {
                  setState(() {});
                },
              )),
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
              // try {
              //   await _korisniciProvider.promjenaPassworda(
              //       widget.korisnikId, _formKey.currentState!.value);
              //   MyDialogs.showSuccess(context,
              //       "Uspješno promijenjena šifra. Molimo da se ponovo logirate.",
              //       () {
              //     Authorization.username = "";
              //     Authorization.password = "";
              //     Navigator.of(context).push(
              //         MaterialPageRoute(builder: (builder) => LoginPage()));
              //   });
              // } catch (e) {
              //   MyDialogs.showError(context, e.toString());
              // }
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
