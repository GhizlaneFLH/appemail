import 'package:flutter/material.dart';
import 'InputDeco_design.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'adminreponce.dart';
import 'dart:convert';

class AdminPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<AdminPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  Future register() async {
    try {
      var url =
          Uri.http("192.168.0.183", '/TEMACONCEPT/admin.php', {'q': '{http}'});
      var response = await http.post(url, body: {
        "email": email.text.toString(),
        "password": password.text.toString(),
      });
      var data = json.decode(response.body);
      if (data == "Error") {
        Fluttertoast.showToast(
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          msg: 'error',
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.green,
          textColor: Colors.white,
          msg: 'Login Successful',
          toastLength: Toast.LENGTH_SHORT,
        ); // Utilisation de Navigator.pushNamed pour passer des arguments à '/page-de-destination'
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailLReponce(),
          ),
        );

// Utilisation de Navigator.push pour naviguer vers une autre page sans passer d'arguments
      }
    } catch (e) {
      print("object");
    }
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  child: Image.network(
                      "https://protocoderspoint.com/wp-content/uploads/2020/10/PROTO-CODERS-POINT-LOGO-water-mark-.png"),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: email,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.email, "Email"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter an Email';
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return 'Please Enter a valid Email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: password,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.lock, "Password"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter a Password';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 39, 190, 170),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(
                            color: Color.fromARGB(255, 39, 190, 170), width: 2),
                      ),
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        print("successful");
                        register();
                      } else {
                        print("Unsuccessful");
                      }
                    },
                    child: Text("Login"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
