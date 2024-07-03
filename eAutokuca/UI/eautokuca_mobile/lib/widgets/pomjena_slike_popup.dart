// ignore_for_file: unused_field, must_be_immutable, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:eautokuca_mobile/providers/korisnici_provider.dart';
import 'package:eautokuca_mobile/screens/korisnicki_profil_screen.dart';
import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class PromjenaSlike extends StatefulWidget {
  int korisnikId;
  PromjenaSlike({super.key, required this.korisnikId});

  @override
  State<PromjenaSlike> createState() => _PromjenaSlikeState();
}

class _PromjenaSlikeState extends State<PromjenaSlike> {
  late KorisniciProvider _korisniciProvider;
  final _formKey = GlobalKey<FormBuilderState>();
  File? _slika;
  String? _base64slika;
  String hint = "Klik za upload slike";

  @override
  void initState() {
    // TODO: implement initState
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
                FormBuilderField(
                  builder: (field) {
                    return InputDecorator(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "Slika",
                            suffixIcon: const Icon(
                              Icons.upload_file,
                              color: Colors.black,
                            ),
                            errorText: field.errorText),
                        child: ListTile(
                          title: Text(
                            hint,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          onTap: uploadujSliku,
                        ));
                  },
                  name: "slika",
                  validator: (value) {
                    if (_slika == null) {
                      return "Obavezno dodati sliku.";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                _buildButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center _buildButton(BuildContext context) {
    return Center(
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(15),
        color: Colors.yellow[700],
        onPressed: () async {
          if (_formKey.currentState != null) {
            if (_formKey.currentState!.saveAndValidate()) {
              Map<String, dynamic> map = Map.from(_formKey.currentState!.value);
              map["slika"] = _base64slika;
              try {
                await _korisniciProvider.promjenaSlike(widget.korisnikId, map);
                MyDialogs.showSuccess(context, "Uspješno promijenjena slika.",
                    () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop({"OK": "OK"});
                });
              } catch (e) {
                MyDialogs.showError(context, e.toString());
              }
            }
          }
        },
        child: const Text(
          "Promijeni sliku",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> uploadujSliku() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      _slika = File(result.files.single.path!);
      _base64slika = base64Encode(_slika!.readAsBytesSync());
      setState(() {
        hint = result.files.single.name.toString();
      });
    }
  }
}
