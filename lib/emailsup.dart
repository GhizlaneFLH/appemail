import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'menuadmin.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Email {
  final String email;

  Email(this.email);
}

class EmailListsupp extends StatefulWidget {
  @override
  _EmailListScreenState createState() => _EmailListScreenState();
}

class _EmailListScreenState extends State<EmailListsupp> {
  List<Email> emailList = [];
  TextEditingController _emailController =
      TextEditingController(); // Déclarer ici

  Future<void> fetchEmails() async {
    var url = 'http://192.168.0.183/TEMACONCEPT/supfetch.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> emailJsonList = json.decode(response.body);
      setState(() {
        emailList = emailJsonList
            .map((emailJson) => Email(
                  emailJson['email'],
                ))
            .toList();
      });
    } else {
      throw Exception('Failed to fetch emails');
    }
  }

  void _showEmailContent(BuildContext context, Email email) {
    TextEditingController emailController =
        TextEditingController(text: email.email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier l\'e-mail'),
          content: TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Nouvel e-mail',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
            TextButton(
              onPressed: () async {
                String newEmail = emailController.text;
                print(email.email);
                try {
                  var url = Uri.http("192.168.0.183",
                      '/TEMACONCEPT/update_email.php', {'q': '{http}'});
                  var response = await http.post(url, body: {
                    "old_email": email.email,
                    "new_email": newEmail,
                  });

                  if (response.statusCode == 200) {
                    print('E-mail mis à jour avec succès');
                    Fluttertoast.showToast(
                      msg: 'E-mail mis à jour avec succès',
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  } else {
                    print('Erreur lors de la mise à jour de l\'e-mail');
                    Fluttertoast.showToast(
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      msg: 'Erreur lors de la mise à jour de l\'e-mail',
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }
                } catch (e) {
                  print('Erreur');
                }
                Navigator.of(context).pop();
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchEmails();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF9AD3BD, <int, Color>{
          50: Color(0xFFFFEBEE),
          100: Color(0xFFCCE5D8),
          200: Color(0xFF9AD3BD),
          300: Color(0xFF8FD9CB),
          400: Color(0xFF95D5BC),
          500: Color(0xFF759F8D),
          600: Color(0xFF81DEB7),
          700: Color(0xFFA0E0C0),
          800: Color(0xFF74B099),
          900: Color(0xFF2B9478),
        }),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Email'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Ajouter un e-mail'),
                      content: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Nouvel e-mail',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () async {
                            String newEmail = _emailController.text;
                            try {
                              var url = Uri.http("192.168.0.183",
                                  '/TEMACONCEPT/add.php', {'q': '{http}'});
                              var response = await http.post(url, body: {
                                "email": newEmail.toString(),
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
                                setState(() {
                                  emailList.add(Email(
                                      newEmail)); // Ajouter le nouvel e-mail à la liste
                                });
                                Fluttertoast.showToast(
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  msg: 'E-mail ajouté avec succès',
                                  toastLength: Toast.LENGTH_SHORT,
                                );
                              }
                            } catch (e) {
                              print("object");
                            }
                            Navigator.of(context)
                                .pop(); // Fermer la boîte de dialogue
                          },
                          child: Text('Ajouter'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        drawer: Navigation(),
        body: ListView.builder(
          itemCount: emailList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          emailList[index].email,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              try {
                                var url = Uri.http(
                                    "192.168.0.183",
                                    '/TEMACONCEPT/mark_deletuser.php',
                                    {'q': '{http}'});
                                var response = await http.post(url, body: {
                                  "email": emailList[index].email,
                                });

                                if (response.statusCode == 200) {
                                  print('- Email deleted');
                                  Fluttertoast.showToast(
                                    msg: '- Email deleted',
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                  setState(() {
                                    emailList.removeAt(index);
                                  });
                                } else {
                                  print('Erreur lors de la mise à jour ');
                                  Fluttertoast.showToast(
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    msg: 'Erreur lors de la mise à jour ',
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                }
                              } catch (e) {
                                print("object");
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showEmailContent(context, emailList[index]);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
