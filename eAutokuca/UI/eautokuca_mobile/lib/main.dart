// ignore_for_file: must_be_immutable, unnecessary_new, prefer_final_fields, prefer_const_constructors

import 'package:eautokuca_mobile/providers/autodijelovi_provider.dart';
import 'package:eautokuca_mobile/providers/car_provider.dart';
import 'package:eautokuca_mobile/providers/korisnici_provider.dart';
import 'package:eautokuca_mobile/providers/oprema_provider.dart';
import 'package:eautokuca_mobile/providers/rezervacija_provider.dart';
import 'package:eautokuca_mobile/screens/lista_automobila.dart';
import 'package:eautokuca_mobile/utils/popup_dialogs.dart';
import 'package:eautokuca_mobile/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CarProvider()),
      ChangeNotifierProvider(create: (_) => KorisniciProvider()),
      ChangeNotifierProvider(create: (_) => OpremaProvider()),
      ChangeNotifierProvider(create: (_) => RezervacijaProvider()),
      ChangeNotifierProvider(create: (_) => AutodijeloviProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  late CarProvider _carProvider;

  @override
  Widget build(BuildContext context) {
    _carProvider = context.read<CarProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 782,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/pozadina.jpg"),
                      fit: BoxFit.fill)),
              child: Stack(
                children: [
                  Positioned(
                      left: 50,
                      top: 50,
                      width: 300,
                      height: 200,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/loginHelp.png"))),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: _buildCard(context),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildCard(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
      child: Card(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(left: 12, right: 12, top: 50, bottom: 30),
          child: Column(
            children: [
              Text(
                "Prijavi se",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Korisničko ime",
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
                controller: _usernameController,
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Šifra",
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.password, color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
                controller: _passwordController,
              ),
              SizedBox(height: 50),
              Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(0, 0, 0, 1),
                    Color.fromRGBO(89, 89, 84, 1)
                  ]),
                ),
                child: InkWell(
                  onTap: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;

                    Authorization.username = username;
                    Authorization.password = password;

                    try {
                      await _carProvider.getAll();

                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListaAutomobila(),
                      ));
                    } on Exception catch (e) {
                      MyDialogs.showError(context, e.toString());
                    }
                  },
                  child: Center(
                      child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.yellow[700],
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
