// ignore_for_file:  must_be_immutable,  use_super_parameters, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, unused_local_variable, unused_field, unused_import, prefer_final_fields

import 'package:eautokuca_mobile/models/car.dart';
import 'package:eautokuca_mobile/models/komentari.dart';
import 'package:eautokuca_mobile/models/oprema.dart';
import 'package:eautokuca_mobile/providers/automobilFavorit_provider.dart';
import 'package:eautokuca_mobile/providers/car_provider.dart';
import 'package:eautokuca_mobile/providers/komentari_provider.dart';
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
import 'package:form_builder_validators/form_builder_validators.dart';
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
  late KomentariProvider _komentariProvider;
  late KorisniciProvider _korisniciProvider;
  Map<String, dynamic> _initialValue = {};
  late List<Komentari>? komentariResult = [];
  late Oprema? opremaAutomobila;
  bool isLoading = true;
  bool favorit = false;
  int? korisnikId;
  bool isVisible = false;

  void _toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  TextEditingController _komentarController = TextEditingController();
  bool isFormVisible = false;
  final _formKey2 = GlobalKey<FormBuilderState>();

  void _toggleFormVisibility() {
    setState(() {
      isFormVisible = !isFormVisible;
    });
  }

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
    _komentariProvider = context.read<KomentariProvider>();
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
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildFirstForm(),
                  opremaAutomobila?.alarm == null
                      ? _buildNoDataField()
                      : _buildOprema(),
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

  IconButton _ukloniFavorita(BuildContext context) {
    return IconButton(
      iconSize: 32,
      color: Colors.red,
      icon: Icon(Icons.favorite),
      onPressed: () async {
        await _automobilFavoritProvider.ukloniFavorita(
            widget.car!.automobilId!, korisnikId!);
        MyDialogs.showSuccess(context, "Uspješno uklonjen favorit.", () {
          Navigator.of(context).pop();
          setState(() {
            isLoading = true;
          });
          getData();
        });
        setState(() {});
      },
    );
  }

  IconButton _dodajFavorita(BuildContext context) {
    return IconButton(
      iconSize: 32,
      color: Colors.red,
      icon: Icon(Icons.favorite_border),
      onPressed: () async {
        await _automobilFavoritProvider.insert(
            {"automobilId": widget.car?.automobilId, "korisnikId": korisnikId});

        MyDialogs.showSuccess(context, "Uspješno dodan favorit.", () {
          Navigator.of(context).pop();
          setState(() {
            isLoading = true;
          });
          getData();
        });
        setState(() {});
      },
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
          var result = await showDialog(
              context: context,
              builder: (context) {
                return RezervisiTermin(carId: widget.car!.automobilId!);
              });
          if (result != null) {
            MyDialogs.showSuccess(context, "Rezervacija uspješna!", () {
              Navigator.of(context).pop();
            });
          }
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
                        Column(
                          children: <Widget>[
                            TextButton(
                                onPressed: _toggleVisibility,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isVisible
                                          ? "Sakrij komentare"
                                          : "Vidi komentare",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Icon(
                                      isVisible
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      color: Colors.black,
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: isVisible,
                              child: (komentariResult != null &&
                                      komentariResult!.isNotEmpty)
                                  ? Column(
                                      children: komentariResult!
                                          .map((Komentari k) => buildRes(k))
                                          .toList(),
                                    )
                                  : _buildNoComments(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: _toggleFormVisibility,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    !isFormVisible
                                        ? "Ostavi komentar"
                                        : "Odustani",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Icon(
                                    !isFormVisible ? Icons.add : Icons.close,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                            Visibility(
                                visible: isFormVisible,
                                child: Form(
                                  key: _formKey2,
                                  child: Column(
                                    children: [
                                      FormBuilderTextField(
                                        controller: _komentarController,
                                        decoration: InputDecoration(
                                          labelText: "Unesi komentar...",
                                          border: OutlineInputBorder(),
                                        ),
                                        maxLines: 3,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator:
                                            FormBuilderValidators.required(
                                                errorText:
                                                    "Polje je obavezno."),
                                        name: 'sadrzaj',
                                      ),
                                      SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            try {
                                              var request = {
                                                "automobilId":
                                                    widget.car!.automobilId,
                                                "korisnikId": korisnikId,
                                                "sadrzaj":
                                                    _komentarController.text
                                              };
                                              _komentariProvider
                                                  .dodajKomentar(request);

                                              MyDialogs.showSuccess(
                                                  context, "Dodan komentar",
                                                  () {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                getData();
                                              });
                                            } catch (e) {
                                              MyDialogs.showError(
                                                  context, e.toString());
                                            }
                                          }
                                        },
                                        child: Text(
                                          "Komentariši",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Detalji ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            favorit
                                ? Tooltip(
                                    message: "Ukloni iz favorita.",
                                    child: _ukloniFavorita(context))
                                : Tooltip(
                                    message: "Dodaj u favorite.",
                                    child: _dodajFavorita(context)),
                          ],
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

  Padding _buildNoComments() {
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
                  "Nema komentara.",
                  textAlign: TextAlign.center,
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

  Container buildRes(Komentari object) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildRow(Icons.person, "Korisnik", object.user),
          const SizedBox(height: 10),
          if (object.sadrzaj != null)
            buildRow(Icons.comment_rounded, "Komentar", object.sadrzaj!),
          const SizedBox(height: 10),
          buildRow(Icons.watch_later_outlined, "Datum", object.datum),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _komentariProvider.sakrijKomentar(object.komentarId!);
                MyDialogs.showSuccess(context, "Uspješno obrisan komentar", () {
                  Navigator.of(context).pop();
                  setState(() {
                    isLoading = true;
                  });
                  getData();
                });
              } catch (e) {
                MyDialogs.showError(context, e.toString());
              }
            },
            child: Text("Obriši komentar"),
          )
        ],
      ),
    );
  }

  Row buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.black),
        SizedBox(width: 8),
        Text(
          "$label:",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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

      var jelFavorit = await _automobilFavoritProvider.isFavorit(
          widget.car!.automobilId!, korisnikId!);

      setState(() {
        favorit = jelFavorit;
      });

      var data =
          await _komentariProvider.getKomentareZaAuto(widget.car!.automobilId!);

      var data1 =
          await _opremaProvider.getOpremuZaAutomobil(widget.car!.automobilId!);
      setState(() {
        komentariResult = data;
        opremaAutomobila = data1;
        isLoading = false;
      });
    } catch (e) {
      MyDialogs.showError(context, e.toString());
    }
  }
}
