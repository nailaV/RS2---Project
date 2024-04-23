// ignore_for_file: unused_field, unused_element, prefer_const_constructors, unnecessary_import, prefer_final_fields

import 'package:eautokuca_desktop/providers/car_provider.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';

class FilterData extends StatefulWidget {
  const FilterData({super.key});

  @override
  State<FilterData> createState() => _FilterDataState();
}

class _FilterDataState extends State<FilterData> {
  late CarProvider _carProvider;
  bool isLoading = true;
  List<String> _listaMarki = [];
  List<String> _listaModela = [];
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carProvider = context.read<CarProvider>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              alignment: Alignment.bottomCenter,
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
                          children: [
                            Container(
                              width: 300,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white60),
                              child: Column(
                                children: [
                                  const Text("Marka",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  const SizedBox(height: 5),
                                  FormBuilderDropdown(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        contentPadding:
                                            const EdgeInsets.all(15)),
                                    focusColor: Colors.grey[300],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    name: 'marka',
                                    initialValue: "Sve marke",
                                    items: List.generate(
                                        _listaMarki.length,
                                        (index) => DropdownMenuItem(
                                              value: _listaMarki[index],
                                              child: Text(_listaMarki[index]),
                                            )),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 300,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white60),
                              child: Column(
                                children: [
                                  const Text("Motor",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  const SizedBox(height: 5),
                                  FormBuilderDropdown(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          contentPadding:
                                              const EdgeInsets.all(15)),
                                      focusColor: Colors.grey[300],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black),
                                      name: 'motor',
                                      initialValue: "Svi",
                                      items: const [
                                        DropdownMenuItem(
                                          value: "Svi",
                                          child: Text("Svi motori"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Benzin",
                                          child: Text("Benzin"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Dizel",
                                          child: Text("Dizel"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Plin",
                                          child: Text("Plin"),
                                        ),
                                      ])
                                ],
                              ),
                            ),
                            Container(
                              width: 300,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white60),
                              child: Column(
                                children: [
                                  const Text("Boja",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  const SizedBox(height: 5),
                                  FormBuilderDropdown(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          contentPadding:
                                              const EdgeInsets.all(15)),
                                      focusColor: Colors.grey[300],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black),
                                      name: 'boja',
                                      items: const [
                                        DropdownMenuItem(
                                          value: "Sve",
                                          child: Text("Sve boje"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Crna",
                                          child: Text("Crna"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Bijela",
                                          child: Text("Bijela"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Crvena",
                                          child: Text("Crvena"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Zelena",
                                          child: Text("Zelena"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Plava",
                                          child: Text("Plava"),
                                        ),
                                      ])
                                ],
                              ),
                            ),
                            Container(
                              width: 300,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white60),
                              child: Column(
                                children: [
                                  const Text("Transmisija",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  const SizedBox(height: 5),
                                  FormBuilderDropdown(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          contentPadding:
                                              const EdgeInsets.all(15)),
                                      focusColor: Colors.grey[300],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black),
                                      name: 'mjenjac',
                                      items: const [
                                        DropdownMenuItem(
                                          value: "Svi",
                                          child: Text("Sve transmisije"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Automatik",
                                          child: Text("Automatik"),
                                        ),
                                        DropdownMenuItem(
                                          value: "Manuelni",
                                          child: Text("Manuelni"),
                                        ),
                                      ])
                                ],
                              ),
                            ),
                            buildNumericField(context, 'godinaProizvodnje',
                                'Godina proizvodnje od:'),
                            buildNumericField(context, 'predjeniKilometri',
                                'Pređeni kilometri od:'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildSearchButton(context)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  SizedBox buildSearchButton(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 42,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.yellow[700],
        padding: const EdgeInsets.all(15),
        onPressed: () {
          if (_formKey.currentState != null) {
            if (_formKey.currentState!.saveAndValidate()) {
              Navigator.of(context).pop(_formKey.currentState!.value);
            }
          }
        },
        child: const Text(
          "Filtriraj",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Container buildNumericField(BuildContext context, String name, String title) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), color: Colors.white60),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            child: FormBuilderTextField(
              cursorColor: Colors.grey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // validator: FormBuilderValidators.compose([
              //   FormBuilderValidators.integer(context,
              //       errorText: 'Samo cijeli brojevi su dozvoljeni'),
              //   (value) {
              //     if (value != null && value.contains(" ")) {
              //       return 'Prazno polje nije dozvoljeno';
              //     } else {
              //       return null;
              //     }
              //   }
              // ]),
              name: name,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getData() async {
    try {
      _listaMarki = await _carProvider.getSveMarke();
      _listaModela = await _carProvider.getSveModele();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
