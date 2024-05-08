// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:eautokuca_desktop/providers/autodijelovi_provider.dart';
import 'package:eautokuca_desktop/providers/car_provider.dart';
import 'package:eautokuca_desktop/providers/korisnici_provider.dart';
import 'package:eautokuca_desktop/providers/oprema_provider.dart';
import 'package:eautokuca_desktop/providers/rezervacija_provider.dart';
import 'package:eautokuca_desktop/screens/lista_automobila.dart';
import 'package:eautokuca_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CarProvider()),
      ChangeNotifierProvider(create: (_) => KorisniciProvider()),
      ChangeNotifierProvider(create: (_) => OpremaProvider()),
      ChangeNotifierProvider(create: (_) => AutodijeloviProvider()),
      ChangeNotifierProvider(create: (_) => RezervacijaProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: LoginPage(),
    );
  }
}

class MyAppBar extends StatelessWidget {
  final String title;
  MyAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;

  void _incrementCounter() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('You have pushed button $_count times'),
      ElevatedButton(
        onPressed: _incrementCounter,
        child: Text('Click here'),
      )
    ]);
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
      appBar: AppBar(
        title: Text('Log in'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
          child: Card(
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/profile.png",
                    height: 100,
                    width: 100,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Username",
                      labelStyle: TextStyle(color: Colors.yellow),
                      prefixIcon: Icon(Icons.email, color: Colors.yellow),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow)),
                    ),
                    controller: _usernameController,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.yellow),
                      prefixIcon: Icon(Icons.password, color: Colors.yellow),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow)),
                    ),
                    controller: _passwordController,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      var username = _usernameController.text;
                      var password = _passwordController.text;

                      Authorization.username = username;
                      Authorization.password = password;

                      try {
                        await _carProvider.getAll();

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ListaAutomobila(),
                        ));
                      } on Exception catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                    title: Text("Error"),
                                    content: Text(e.toString()),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Ok"))
                                    ]));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        minimumSize: Size(200, 50),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
