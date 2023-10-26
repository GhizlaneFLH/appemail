import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'dart:async';
import 'envoi.dart';
import 'package:file_picker/file_picker.dart';
import 'naviigation_drawer.dart';
import 'dart:io';

class EmailSenderR extends StatefulWidget {
  final String sender;
  final String subject;

  EmailSenderR({required this.sender, required this.subject});

  @override
  _EmailSenderState createState() => _EmailSenderState();
}

class _EmailSenderState extends State<EmailSenderR> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _bodyController = TextEditingController();

  late TextEditingController _toController;
  late TextEditingController _subjectController;
  String? filePath; // Déclarez filePath ici
  @override
  void initState() {
    super.initState();
    _toController = TextEditingController(text: widget.sender);
    _subjectController = TextEditingController(text: widget.subject);
  }

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

  Future sendData() async {
    try {
      var url =
          Uri.http("192.168.0.183", '/TEMACONCEPT/send.php', {'q': '{http}'});
      var response = await http.post(url, body: {
        "recipients": _toController.text,
        "subject": _subjectController.text,
        "body": _bodyController.text,
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
