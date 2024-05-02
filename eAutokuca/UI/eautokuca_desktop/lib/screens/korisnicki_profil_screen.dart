// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors, sized_box_for_whitespace, unnecessary_string_interpolations, avoid_unnecessary_containers

import 'dart:convert';

import 'package:eautokuca_desktop/models/korisnici.dart';
import 'package:eautokuca_desktop/providers/korisnici_provider.dart';
import 'package:eautokuca_desktop/utils/popup_dialogs.dart';
import 'package:eautokuca_desktop/utils/utils.dart';
import 'package:eautokuca_desktop/widgets/promjena_passworda_popup.dart';
import 'package:eautokuca_desktop/widgets/master_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KorisnickiProfil extends StatefulWidget {
  const KorisnickiProfil({super.key});

  @override
  State<KorisnickiProfil> createState() => _KorisnickiProfilState();
}

class _KorisnickiProfilState extends State<KorisnickiProfil> {
  late KorisniciProvider _korisniciProvider;
  Korisnici? korisnikInfo;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "KORISNIČKI PROFIL",
      child: isLoading
          ? const Center()
          : SingleChildScrollView(
              child: Container(
                  child: Column(
              children: [_buildForm()],
            ))),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 300.0, right: 300.0, top: 50.0, bottom: 50.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.blueGrey[50],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            _buildFields(),
            SizedBox(height: 20),
            _buildContactInfo(),
            SizedBox(height: 50),
            _buildButtons(),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Padding _buildContactInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Kontakt informacije",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email),
                SizedBox(width: 5),
                Text(
                  "${korisnikInfo?.email ?? ''}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone),
                SizedBox(width: 5),
                Text(
                  "${korisnikInfo?.telefon ?? ''}",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _buildFields() {
    return Row(children: [
      SizedBox(width: 20),
      korisnikInfo?.slika != null && korisnikInfo?.slika != ""
          ? Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(
                    base64Decode(korisnikInfo!.slika!),
                  ),
                ),
              ),
            )
          : Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Icon(
                Icons.account_circle,
                size: 80,
                color: Colors.white,
              ),
            ),
      SizedBox(width: 20),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ime i prezime"),
          Text(
            "${korisnikInfo?.ime ?? ''} ${korisnikInfo?.prezime ?? ''}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("Username"),
          Text(
            korisnikInfo?.username ?? "",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ]);
  }

  Row _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[700],
            foregroundColor: Colors.white,
          ),
          icon: Icon(Icons.camera_alt),
          label: korisnikInfo?.slika != null && korisnikInfo?.slika != ""
              ? Text("Promijeni sliku")
              : Text("Dodaj sliku"),
        ),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return PromjenaPassworda(
                    korisnikId: korisnikInfo!.korisnikId!,
                  );
                });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[700],
            foregroundColor: Colors.white,
          ),
          icon: Icon(Icons.lock),
          label: Text("Promijeni šifru"),
        ),
      ],
    );
  }

  Future<void> getData() async {
    try {
      var data =
          await _korisniciProvider.getByUseranme(Authorization.username!);
      setState(() {
        korisnikInfo = data;
        isLoading = false;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
