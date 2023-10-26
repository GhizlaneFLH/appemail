import 'package:flutter/material.dart';
import 'InputDeco_design.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'data.dart';
import 'dart:convert';
import 'FormPage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:async';
import 'envoi.dart';
import 'naviigation_drawer.dart';

class GlobalVariables {
  static String userEmail = "";
  // Ajoutez d'autres variables globales si nécessaire
}

class Formlogin extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<Formlogin> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  Future register() async {
    try {
      var url =
          Uri.http("192.168.0.183", '/TEMACONCEPT/login.php', {'q': '{http}'});
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
            builder: (context) => AllEmails(),
          ),
        );
        GlobalVariables.userEmail = email.text;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already dont have an account?',
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
                          MaterialPageRoute(builder: (context) => FormPage()),
                        );
                      },
                      child: const Text(
                        'Sing up', // Le texte "Login" est désormais un lien
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
// seeeeeeeeeeeeend

class EmailSender extends StatefulWidget {
  @override
  _EmailSenderState createState() => _EmailSenderState();
}

class _EmailSenderState extends State<EmailSender> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  String userEmail = GlobalVariables.userEmail;
  String? filePath; // Déclarez filePath ici
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // Le fichier a été sélectionné avec succès
      final file = result.files.single;

      // Utilisez le fichier pour l'envoi par e-mail ou effectuez d'autres opérations nécessaires
      print('Nom du fichier : ${file.name}');
      print('Chemin du fichier : ${file.path}');
      setState(() {
        filePath = file
            .path; // Mettez à jour la variable filePath avec le chemin du fichier sélectionné
      });
    }
  }

  void sendEmail(String filePath) async {
    final smtpServer = gmail('flhghizlane@gmail.com', 'roivbcaxljrmfikn');

    final message = Message()
      ..from = Address('flhghizlane@gmail.com', 'flhghizlane@gmail.com')
      ..recipients.add(_toController.text)
      ..subject = _subjectController.text
      ..text = _bodyController.text;

    final file = File(filePath); // Utilisez le chemin du fichier sélectionné
    final attachment = FileAttachment(file);

    message.attachments.add(attachment);

    String localFilePath = filePath;
    String urll = "file:///" + localFilePath.replaceAll(r'\', '/');
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
      try {
        var url =
            Uri.http("192.168.0.183", '/TEMACONCEPT/send.php', {'q': '{http}'});
        var response = await http.post(url, body: {
          "sender": _toController.text,
          "subject": _subjectController.text,
          "content": _bodyController.text,
          "date": DateTime.now().toString(),
          "email": userEmail.toString(),
          "fichier": urll.toString(),
        });
        //var data = json.decode(response.body);
        if (response.statusCode == 200) {
          print('Email sauvegardé avec succès');
        } else {
          print(
              'Erreur lors de la sauvegarde de l\'email. Statut : ${response.statusCode}');
          print('Réponse du serveur : ${response.body}');
        }
      } catch (e) {
        print("object");
      }
      _showSnackbar('Email sent successfully.');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmailListScreen(),
        ),
      );
    } catch (e) {
      print('Error sending email: $e');
      _showSnackbar('Error sending email.');
    }
  }

  void sendEmailS() async {
    final smtpServer = gmail('flhghizlane@gmail.com', 'roivbcaxljrmfikn');

    final message = Message()
      ..from = Address('flhghizlane@gmail.com', 'flhghizlane@gmail.com')
      ..recipients.add(_toController.text)
      ..subject = _subjectController.text
      ..text = _bodyController.text;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
      try {
        var url =
            Uri.http("192.168.0.183", '/TEMACONCEPT/send.php', {'q': '{http}'});
        var response = await http.post(url, body: {
          "sender": _toController.text,
          "subject": _subjectController.text,
          "content": _bodyController.text,
          "date": DateTime.now().toString(),
          "email": userEmail.toString(),
          "fichier": "Aucun",
        });
        //var data = json.decode(response.body);
        if (response.statusCode == 200) {
          print('Email sauvegardé avec succès');
        } else {
          print(
              'Erreur lors de la sauvegarde de l\'email. Statut : ${response.statusCode}');
          print('Réponse du serveur : ${response.body}');
        }
      } catch (e) {
        print("object");
      }
      _showSnackbar('Email sent successfully.');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmailListScreen(),
        ),
      );
    } catch (e) {
      print('Error sending email: $e');
      _showSnackbar('Error sending email.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
          title: Text('Nouveau message'),
        ),
        drawer: NavigationDrawe(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _toController,
                  decoration: InputDecoration(labelText: 'Destinataire'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter an email address.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(labelText: 'Objet'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a subject.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _bodyController,
                  decoration: InputDecoration(labelText: 'Message'),
                  maxLines: 5,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a message.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await pickFile();
                      },
                      icon: Icon(
                          Icons.attach_file), // Utilisez l'icône attach_file
                      label: Text(''),
                    ),
                    SizedBox(width: 8),
                    Text(
                      filePath ?? 'Aucun fichier sélectionné',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (filePath != null) {
                        sendEmail(
                            filePath!); // Utilisez l'opérateur ! pour indiquer que filePath ne sera pas nul
                      } else {
                        sendEmailS();
                      }
                    }
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _toController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
// seeeeeeeeeeeeend reponce
