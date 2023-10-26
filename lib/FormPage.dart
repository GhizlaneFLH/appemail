import 'package:flutter/material.dart';
import 'InputDeco_design.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'AdminPage.dart';
import 'dart:convert';
import 'login.dart';
import 'verification.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  Future register() async {
    try {
      var url = Uri.http(
          "192.168.0.183", '/TEMACONCEPT/register.php', {'q': '{http}'});
      var response = await http.post(url, body: {
        "email": email.text.toString(),
        "name": name.text.toString(),
        "phone": phone.text.toString(),
        "password": password.text.toString(),
        "confirmpassword": confirmpassword.text.toString(),
      });
      var data = json.decode(response.body);
      if (data == "Error") {
        Fluttertoast.showToast(
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          msg: 'User already exit!',
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.green,
          textColor: Colors.white,
          msg: 'Registration Successful',
          toastLength: Toast.LENGTH_SHORT,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Emailverification(emailver: email.text),
          ),
        );
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
                ClipOval(
                  child: Image.asset(
                    'assets/Capture.JPG',
                    width: 100, // Largeur souhaitée de l'image
                    height: 100, // Hauteur souhaitée de l'image
                    // Ajustement de l'image pour couvrir le cercle
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: name,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.person, "Full Name"),
                    validator: (String? value) {
                      // Mettez à jour la signature pour accepter String? au lieu de String
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                  ),
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
                    controller: phone,
                    keyboardType: TextInputType.number,
                    decoration: buildInputDecoration(Icons.phone, "Phone No"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone no';
                      }
                      if (!RegExp(r'^[0-9 ()-]+$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
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
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: confirmpassword,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration:
                        buildInputDecoration(Icons.lock, "Confirm Password"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please re-enter password';
                      }
                      print(password.text);
                      print(confirmpassword.text);

                      if (password.text != confirmpassword.text) {
                        return "Password does not match";
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                          color: Color.fromARGB(179, 31, 30, 30), fontSize: 13),
                    ),
                    const SizedBox(
                        width:
                            5), // Ajoutez un espace entre le texte et le lien
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Formlogin()),
                        );
                      },
                      child: const Text(
                        'Login', // Le texte "Login" est désormais un lien
                        style: TextStyle(
                          color: Color.fromARGB(
                              255, 103, 148, 146), // Couleur du lien
                          fontSize: 13,
                          decoration: TextDecoration
                              .underline, // Pour souligner le lien
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 30, 202, 188),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(
                            color: Color.fromARGB(255, 30, 202, 188), width: 2),
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
                    child: Text("Submit"),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 100,
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 30, 202, 188),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(
                            color: Color.fromARGB(255, 30, 202, 188), width: 2),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AdminPage()), // Remplacez par le nom de votre page d'administration
                      );
                    },
                    child: Text("Admin"),
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
