import 'dart:convert';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:house_price/error_handling.dart';
import 'package:house_price/result.dart';
import 'package:house_price/service.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'House Price Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: welcome(),
    );
  }
}

class welcome extends StatelessWidget {
  const welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Lottie.asset('assets/logo.json', height: 350),
        ),
        SizedBox(
          height: 10,
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: const Size(300, 50)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const getData()),
            );
          },
          child: Text("Get Started"),
        )
      ])),
    );
  }
}

class getData extends StatefulWidget {
  const getData({Key? key}) : super(key: key);

  @override
  State<getData> createState() => _getDataState();
}

class _getDataState extends State<getData> {
  final _formkey = GlobalKey<FormState>();
  _getDataState() {
    _selected = _bhk[0];
    _selected_loc = _location[0];
  }
  final _sqftcontroller = TextEditingController();
  final _bathcontroller = TextEditingController();

  var _sqft;
  var _bath;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _sqftcontroller.addListener(_updatestate);
    _bathcontroller.addListener(_updatestate);
  }

  void _updatestate() {
    setState(() {
      _sqft = _sqftcontroller.text;
      _bath = _bathcontroller.text;
    });
  }

  double res = 0.0;

  String? finalres = "";
  void _update() {
    setState(() {
      finalres = rent;
      res = double.parse(finalres!);
      res = res * 82;
    });
  }

  final _bhk = ["1 Bhk", "2 Bhk", "3 Bhk", "More than 3Bhk"];
  String? _selected = " ";
  final _location = [
    "Electronic City",
    "Kanakpura Road",
    "Sarjapur Road",
    "Whitefield",
    "Other location"
  ];
  String? _selected_loc = " ";

  String? rent = " ";

  postdata() async {
    print("hi");
    int bhk1 = 0;
    int bhk2 = 0;
    int bhk3 = 0;
    int bhkother = 0;
    int ec = 0;
    int kr = 0;
    int sr = 0;
    int wf = 0;
    int other_loc = 0;

    if (_selected == "1 Bhk") {
      bhk1 = 1;
    } else if (_selected == "2 Bhk") {
      bhk2 = 1;
    } else if (_selected == "3 Bhk") {
      bhk3 = 1;
    } else if (_selected == "More than 3Bhk") {
      bhkother = 1;
    }
    if (_selected_loc == "Electronic City") {
      ec = 1;
    } else if (_selected_loc == "Kanakpura Road") {
      kr = 1;
    } else if (_selected_loc == "Sarjapur Road") {
      sr = 1;
    } else if (_selected_loc == "Whitefield") {
      wf = 1;
    } else if (_selected_loc == "Other location") {
      other_loc = 1;
    }

    RequestApi requestApi = new RequestApi(
        total_sqft: _sqftcontroller,
        bath: _bathcontroller,
        bhk1: bhk1,
        bhk2: bhk2,
        bhk3: bhk3,
        otherbhk: bhkother,
        ec: ec,
        kr: kr,
        sr: sr,
        wf: wf,
        other_loc: other_loc);
    rent = await requestApi.getRent();

    print(rent);

    _update();
  }

  @override
  Widget build(BuildContext context) {
    getData gd = new getData();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "House Rent Predictor",
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child:
              // ListView(
              // children: [
              // SizedBox(
              // height: 20,
              //),

              SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: ((value) {
                  int val = 0;

                  val = int.parse(value!);

                  //print(val);
                  if (value.isEmpty) {
                    return 'Please enter a value(Between 1200-5000)';
                  } else if (val < 1200 || val > 5000) {
                    return 'Please enter a value(Between 1200-5000)';
                  } else {
                    return null;
                  }
                }),
                controller: _sqftcontroller,
                decoration: InputDecoration(
                    labelText: 'Total SquarFit(between 1200-5000)',
                    prefixIcon: Icon(Icons.line_weight_sharp),
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: ((value) {
                  int val = 0;

                  val = int.parse(value!);

                  //print(val);
                  if (value.isEmpty) {
                    return 'Please enter a value';
                  } else if (val < 1) {
                    return 'Please enter a valid value';
                  } else {
                    return null;
                  }
                }),
                controller: _bathcontroller,
                decoration: InputDecoration(
                    labelText: 'No of Bathrooms',
                    prefixIcon: Icon(Icons.shower),
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                value: _selected,
                items: _bhk.map((e) {
                  return DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selected = val as String;
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.deepPurple,
                ),
                decoration: InputDecoration(
                    labelText: "No of BHK",
                    prefixIcon: Icon(Icons.bedroom_child),
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                value: _selected_loc,
                items: _location.map((e) {
                  return DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selected_loc = val as String;
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.deepPurple,
                ),
                decoration: InputDecoration(
                    labelText: "Select the location",
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              OutlinedButton(
                child: Text(
                  'Predict Rent',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style:
                    OutlinedButton.styleFrom(minimumSize: const Size(400, 50)),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    postdata();
                    /* showDialog(
                      context: context,
                      builder: (context) {
                        return Container(
                          child: AlertDialog(
                              title: Text("Predicted Rent:"),
                              content: Text(
                                  "Rent ₹${res.toStringAsFixed(2).toString()}"
                                  //rent.toString(),
                                  ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("OK")),
                              ]),
                        );
                      },
                    );*/
                  }

                  //_update();
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Predicted Rent:₹${res.toStringAsFixed(2).toString()}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
