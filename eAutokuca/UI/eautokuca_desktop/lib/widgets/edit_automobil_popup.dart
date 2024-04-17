// ignore_for_file: must_be_immutable, prefer_const_constructors, use_build_context_synchronously

import 'package:eautokuca_desktop/providers/car_provider.dart';
import 'package:eautokuca_desktop/screens/lista_automobila.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../models/car.dart';

class EditAutomobil extends StatefulWidget {
  Car car;
  EditAutomobil({super.key, required this.car});

  @override
  State<EditAutomobil> createState() => _EditAutomobilState();
}

class _EditAutomobilState extends State<EditAutomobil> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late CarProvider _carProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carProvider = context.read<CarProvider>();
    _initialValue = {
      "motor": widget.car.motor,
      "mjenjac": widget.car.mjenjac,
      "boja": widget.car.boja,
      "cijena": widget.car.cijena.toString(),
      "godinaProizvodnje": widget.car.godinaProizvodnje.toString(),
      "predjeniKilometri": widget.car.predjeniKilometri.toString(),
      "brojSasije": widget.car.brojSasije,
      "snagaMotora": widget.car.snagaMotora,
      "brojVrata": widget.car.brojVrata.toString(),
      "model": widget.car.model,
      "marka": widget.car.marka,
      "status": widget.car.status,
      "slike": widget.car.slike
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
        _formKey.currentState?.saveAndValidate();
        try {
          await _carProvider.update(
              widget.car.automobilId!, _formKey.currentState?.value);
          MyDialogs.showSuccess(context, "Uspješno sačuvane promjene.", () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (builder) => const ListaAutomobila()));
          });
        } catch (e) {
          MyDialogs.showError(context, e.toString());
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
            //autovalidateMode: AutovalidateMode.onUserInteraction,
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
            //autovalidateMode: AutovalidateMode.onUserInteraction,
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
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            name: 'status',
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Status',
                labelStyle: TextStyle(fontSize: 14)),
          ),
        ),
      ],
    );
  }
}
