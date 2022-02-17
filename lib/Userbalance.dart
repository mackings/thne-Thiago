import 'dart:convert';


import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:thiago_exchange/withdraw.dart';

import 'package:firebase/firestore.dart';

class Userbalance extends StatefulWidget {
  const Userbalance({Key? key}) : super(key: key);

  @override
  _UserbalanceState createState() => _UserbalanceState();
}

class _UserbalanceState extends State<Userbalance> {
  TextEditingController admincontroller = TextEditingController();
  TextEditingController Amountcontroller = TextEditingController();

  final balanceurl = ("https://sandbox.wallets.africa/wallet/balance");
  final secret = ('hfucj5jatq8h');
  String bearer = ('uvjqzm5xl6bw');

  dynamic alldata;
  String? walletBalance;

  Future getuserbalance() async {
    var response = await http.post(
      Uri.parse(balanceurl),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $bearer",
      },
      body: jsonEncode(
        {
          "phoneNumber": admincontroller.text,
          "secretKey": 'hfucj5jatq8h',
          "currency": "NGN",
        },
      ),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      setState(() {
        walletBalance = '${data['walletBalance']}';
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  SavebalancetoHivedb() async {
    await Hive.openBox('user');

    var box = Hive.box('user');
    box.put('walletBalance', walletBalance);
    print(box.get('walletBalance'));
    //print(prefs.getString('walletBalance' + 'From SharedPreferences'));
  }


  Sendwithreq(){
    FirebaseFirestore.instance.collection('withdraw').add({
      'wallet ID': admincontroller.text,
      'amount': Amountcontroller.text,
      'status': 'pending',
    });


  }

  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserbalance();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.deepPurpleAccent,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                CarouselSlider(
                  carouselController: _controller,
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2,
                    viewportFraction: 0.9,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                  ),
                  items: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: AssetImage('assets/eth.jpg'),
                              fit: BoxFit.cover)),
                    ),

//image2
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: AssetImage('assets/bitcoin.png'),
                              fit: BoxFit.cover)),
                    ),

                    //img3

                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: AssetImage('assets/cry1.png'),
                              fit: BoxFit.cover)),
                    ),

                    //im4

                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: AssetImage('assets/cry2.png'),
                              fit: BoxFit.cover)),
                    ),

                    //img5

                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: AssetImage('assets/cry4.png'),
                              fit: BoxFit.cover)),
                    ),

                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: AssetImage('assets/cry5.jpg'),
                              fit: BoxFit.cover)),
                    ),
                  ],
                ),

                //  Text( 'Wallet Balance',
                //  style: GoogleFonts.lato(
                //  textStyle: const TextStyle(
                //    fontSize: 20,
                //   color: Colors.white,
                //   fontWeight: FontWeight.bold,
                //    ),
                //  ),
                //  ),
                const SizedBox(
                  height: 30,
                ),

                Container(
                    height: MediaQuery.of(context).size.height - 600,
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        '$walletBalance NGN' == null
                            ? 'Loading...'
                            : '$walletBalance NGN',
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),

                const SizedBox(
                  height: 30,
                ),

                Container(
                  height: MediaQuery.of(context).size.height / 12,
                  width: MediaQuery.of(context).size.width - 25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: admincontroller,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 15) {
                            return 'Please enter your Wallet Address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " Enter Wallet Address",
                          hintStyle: GoogleFonts.montserrat(
                            color: Colors.black,
                          ),
                          suffixIcon: Icon(
                            Icons.qr_code,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        getuserbalance();
                      },
                      child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'View Balance',
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        // reqwithdraw();
                        SavebalancetoHivedb();
                      },

                      child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Save Balance',
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),

                      //child: ,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>Withdraw()));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height - 620,
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        ' Withdraw Balance',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
