// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:eautokuca_mobile/models/korisnici.dart';
import 'package:eautokuca_mobile/providers/korisnici_provider.dart';

import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:eautokuca_mobile/utils/utils.dart';
import 'package:eautokuca_mobile/widgets/master_screen.dart';
import 'package:eautokuca_mobile/widgets/pomjena_slike_popup.dart';
import 'package:eautokuca_mobile/widgets/promjena_passworda_popup.dart';
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
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "KORISNIČKI PROFIL",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [_buildForm()],
              ),
            ),
    );
  }

  Widget _buildForm() {
    return Container(
      height: 600,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.blueGrey[50],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: _buildFields(),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: _buildContactInfo(),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: _buildButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Informacije",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timeline),
              SizedBox(width: 5),
              Text(
                korisnikInfo?.registrationDate ?? '',
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
    );
  }

  Widget _buildFields() {
    return Column(
      children: [
        SizedBox(width: 10),
        korisnikInfo?.slika != null && korisnikInfo?.slika != ""
            ? Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(base64Decode(korisnikInfo!.slika!)),
                  ),
                ),
              )
            : Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child:
                    Icon(Icons.account_circle, size: 80, color: Colors.white),
              ),
        SizedBox(height: 16),
        Text(
          "${korisnikInfo?.ime ?? ''} ${korisnikInfo?.prezime ?? ''}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          korisnikInfo?.username ?? "",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return PromjenaSlike(
                    korisnikId: korisnikInfo!.korisnikId!,
                  );
                });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[700],
          ),
          icon: Icon(Icons.camera_alt),
          label: korisnikInfo?.slika != null && korisnikInfo?.slika != ""
              ? Text("Promijeni sliku")
              : Text("Dodaj sliku"),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return PromjenaPassworda(
                    korisnikId: korisnikInfo!.korisnikId!,
                  );
                });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[700],
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
