// ignore_for_file:  must_be_immutable,  use_super_parameters, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, unused_local_variable, unused_field

import 'package:eautokuca_mobile/models/car.dart';
import 'package:eautokuca_mobile/models/oprema.dart';
import 'package:eautokuca_mobile/providers/automobilFavorit_provider.dart';
import 'package:eautokuca_mobile/providers/car_provider.dart';
import 'package:eautokuca_mobile/providers/korisnici_provider.dart';
import 'package:eautokuca_mobile/providers/oprema_provider.dart';
import 'package:eautokuca_mobile/providers/rezervacija_provider.dart';
import 'package:eautokuca_mobile/screens/favoriti_screen.dart';
import 'package:eautokuca_mobile/screens/lista_automobila.dart';
import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:eautokuca_mobile/utils/utils.dart';
import 'package:eautokuca_mobile/widgets/master_screen.dart';
import 'package:eautokuca_mobile/widgets/rezervacija_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class CarDetailsScreen extends StatefulWidget {
  Car? car;
  CarDetailsScreen({Key? key, this.car}) : super(key: key);

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formKey1 = GlobalKey<FormBuilderState>();
  late CarProvider _carProvider;
  late OpremaProvider _opremaProvider;
  late RezervacijaProvider _rezervacijaProvider;
  late AutomobilFavoritProvider _automobilFavoritProvider;
  late KorisniciProvider _korisniciProvider;
  Map<String, dynamic> _initialValue = {};
  late Oprema? opremaAutomobila;
  bool isLoading = true;
  bool favorit = false;
  int? korisnikId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialValue = {
      "motor": widget.car?.motor,
      "mjenjac": widget.car?.mjenjac,
      "boja": widget.car?.boja,
      "cijena": widget.car?.cijena.toString(),
      "godinaProizvodnje": widget.car?.godinaProizvodnje.toString(),
      "predjeniKilometri": widget.car?.predjeniKilometri.toString(),
      "brojSasije": widget.car?.brojSasije,
      "snagaMotora": widget.car?.snagaMotora,
      "brojVrata": widget.car?.brojVrata.toString(),
      "model": widget.car?.model,
      "marka": widget.car?.marka,
      "status": widget.car?.status,
      "slika": widget.car?.slike
    };
    _carProvider = context.read<CarProvider>();
    _opremaProvider = context.read<OpremaProvider>();
    _rezervacijaProvider = context.read<RezervacijaProvider>();
    _automobilFavoritProvider = context.read<AutomobilFavoritProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();

    getData();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _carProvider = context.read<CarProvider>();
    _opremaProvider = context.read<OpremaProvider>();
    _rezervacijaProvider = context.read<RezervacijaProvider>();
    _automobilFavoritProvider = context.read<AutomobilFavoritProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "${widget.car?.marka} ${widget.car?.model}",
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  favorit ? _ukloniFavorita(context) : _dodajFavorita(context),
                  _buildFirstForm(),
                  isLoading ? _buildNoDataField() : _buildOprema(),
                  _buildButton(),
                  SizedBox(
                    width: 100,
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
    );
  }

  MaterialButton _ukloniFavorita(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        await _automobilFavoritProvider.ukloniFavorita(
            widget.car!.automobilId!, korisnikId!);
        MyDialogs.showSuccess(context, "Uspješno uklonjen favorit.", () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (builder) => FavoritiScreen()));
        });
        setState(() {});
      },
      child: Text("Ukloni"),
    );
  }

  MaterialButton _dodajFavorita(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        await _automobilFavoritProvider.insert(
            {"automobilId": widget.car?.automobilId, "korisnikId": korisnikId});

        MyDialogs.showSuccess(context, "Uspješno dodan favorit.", () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (builder) => ListaAutomobila()));
        });
        setState(() {});
      },
      child: Text("Dodaj u fav"),
    );
  }

  Padding _buildButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(15),
        hoverColor: Colors.blue,
        color: Colors.yellow[700],
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return RezervisiTermin();
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Rezerviši termin",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildNoDataField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
            padding: EdgeInsets.only(left: 50, right: 50, top: 30, bottom: 30),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
                color: Colors.blueGrey[50]),
            child: Column(
              children: [
                Icon(Icons.info),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Nema podataka o dodatnoj opremi za ovaj automobil ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
      ),
    );
  }

  FormBuilder _buildFirstForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blueGrey[50],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImage(),
                        SizedBox(height: 10),
                        Text(
                          'Detalji ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTextField('Marka', 'marka'),
                                  _buildTextField('Model', 'model'),
                                  _buildTextField('Transmisija', 'mjenjac'),
                                  _buildTextField('Vrsta goriva', 'motor'),
                                  _buildTextField('Godina proizvodnje',
                                      'godinaProizvodnje'),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildTextField('Broj šasije', 'brojSasije'),
                                  _buildTextField(
                                      'Snaga motora', 'snagaMotora'),
                                  _buildTextField('Broj vrata', 'brojVrata'),
                                  _buildTextField('Boja', 'boja'),
                                  _buildTextField('Cijena', 'cijena'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FormBuilder _buildOprema() {
    return FormBuilder(
        key: _formKey1,
        initialValue: _initialValue,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blueGrey[50]),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Text(
                                'Dodatna oprema',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildInputsOprema(),
                            ],
                          ),
                        )))
              ],
            )));
  }

  Widget _buildInputsOprema() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.blueGrey[50],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(children: [
                  _buildOpremaTile("Zračni jastuci",
                      opremaAutomobila?.zracniJastuci ?? false),
                  SizedBox(height: 5),
                  _buildOpremaTile(
                      "Bluetooth", opremaAutomobila?.bluetooth ?? false),
                  SizedBox(height: 5),
                  _buildOpremaTile("Xenon", opremaAutomobila?.xenon ?? false),
                  SizedBox(height: 5),
                  _buildOpremaTile("Alarm", opremaAutomobila?.alarm ?? false),
                  SizedBox(height: 5),
                  _buildOpremaTile("Daljinsko ključanje",
                      opremaAutomobila?.daljinskoKljucanje ?? false),
                  SizedBox(height: 5),
                  _buildOpremaTile(
                      "Navigacija", opremaAutomobila?.navigacija ?? false),
                ]),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildOpremaTile(
                        "Servo volan", opremaAutomobila?.servoVolan ?? false),
                    SizedBox(height: 5),
                    _buildOpremaTile(
                        "Auto pilot", opremaAutomobila?.autoPilot ?? false),
                    SizedBox(height: 5),
                    _buildOpremaTile(
                        "Tempomat", opremaAutomobila?.tempomat ?? false),
                    SizedBox(height: 5),
                    _buildOpremaTile("Parking senzori",
                        opremaAutomobila?.parkingSenzori ?? false),
                    SizedBox(height: 5),
                    _buildOpremaTile("Grijanje sjedišta",
                        opremaAutomobila?.grijanjeSjedista ?? false),
                    SizedBox(height: 5),
                    _buildOpremaTile("Grijanje volana",
                        opremaAutomobila?.grijanjeVolana ?? false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildOpremaTile(String title, bool value) {
    return ListTile(
      title: Text(title),
      leading: value
          ? Icon(Icons.check_circle, color: Colors.green)
          : Icon(Icons.cancel, color: Colors.red),
    );
  }

  Widget _buildTextField(String label, String initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800]),
          ),
          TextFormField(
            initialValue: _initialValue[initialValue],
            readOnly: true,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Column(
      children: [
        widget.car?.slike != null && widget.car?.slike != ""
            ? Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                height: 300,
                child: imageFromBase64String(widget.car!.slike!),
              )
            : Text("no imgg")
      ],
    );
  }

  Future<void> getData() async {
    try {
      var userID = await _korisniciProvider.getKorisnikID();
      setState(() {
        korisnikId = userID;
      });
      var data =
          await _opremaProvider.getOpremuZaAutomobil(widget.car!.automobilId!);

      var jelFavorit = await _automobilFavoritProvider.isFavorit(
          widget.car!.automobilId!, korisnikId!);

      setState(() {
        opremaAutomobila = data;
        favorit = jelFavorit;
        isLoading = false;
      });
    } catch (e) {
      opremaAutomobila = null;
      isLoading = false;
    }
  }
}
