import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
//import 'dart:convert';
import 'dart:async';
import 'envoi.dart';
import 'naviigation_drawer.dart';


class EmailSender extends StatefulWidget {
  @override
  _EmailSenderState createState() => _EmailSenderState();
}

class _EmailSenderState extends State<EmailSender> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
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

  Future sendData() async {
    try {
      var url =
          Uri.http("192.168.0.183", '/TEMACONCEPT/send.php', {'q': '{http}'});
      var response = await http.post(url, body: {
        "recipients": _toController.text,
        "subject": _subjectController.text,
        "body": _bodyController.text,
        "date": DateTime.now(),
        //"sendpar": emailv,
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

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
      sendData();
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
    // Récupérer les arguments

    return Scaffold(
      appBar: AppBar(
        title: Text('Send Email'),
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
                decoration: InputDecoration(labelText: 'Recipient'),
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
                decoration: InputDecoration(labelText: 'Subject'),
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
                decoration: InputDecoration(labelText: 'Message Body'),
                maxLines: 5,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a message.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await pickFile();
                },
                child: Text('Sélectionner un fichier'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (filePath != null) {
                      sendEmail(
                          filePath!); // Utilisez l'opérateur ! pour indiquer que filePath ne sera pas nul
                    } else {
                      _showSnackbar('Please select a file first.');
                    }
                  }
                },
                child: Text('Send'),
              ),
            ],
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
