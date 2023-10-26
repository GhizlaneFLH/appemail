import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'naviigation_drawer.dart';
import 'sendreponse.dart';
import 'package:intl/intl.dart';

class Email {
  final String sender;
  final String subject;
  final String content;
  final DateTime date;
  final String formattedDate; // Add a formatted date string

  Email(this.sender, this.subject, this.content, this.date)
      : formattedDate =
            DateFormat('yyyy-MM-dd HH:mm').format(date); // Format the date
}

class EmailListservice extends StatefulWidget {
  @override
  _EmailListScreenState createState() => _EmailListScreenState();
}

class _EmailListScreenState extends State<EmailListservice> {
  List<Email> emailList = [];

  Future<void> fetchEmails() async {
    var url = 'http://192.168.0.183/TEMACONCEPT/servic.php';
    final response = await http.get(Uri.parse(url)); // Replace with your API endpoint

    if (response.statusCode == 200) {
      final List<dynamic> emailJsonList = json.decode(response.body);
      setState(() {
        emailList = emailJsonList
            .map((emailJson) => Email(
          emailJson['sender'],
          emailJson['subject'],
          emailJson['content'],
           DateTime.parse(emailJson['date']),
        ))
            .toList();
      });
    } else {
      throw Exception('Failed to fetch emails');
    }
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
          title: Text('Offre des services'),
        ),
        drawer: NavigationDrawe(),
        body: ListView.builder(
          itemCount: emailList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(emailList[index].subject),
              subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emailList[index].sender),
          Text(
            DateFormat('yyyy-MM-dd HH:mm').format(emailList[index].date),
            style: TextStyle(
              fontSize: 12, // Définissez la taille de police souhaitée pour la date
              color: Colors.grey, // Définissez la couleur de la date
            ),
          ),
        ],
      ),
              onTap: () {
                _showEmailContent(context, emailList[index]);
              },
            );
          },
        ),
      ),
    );
  }

  void _showEmailContent(BuildContext context, Email email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(email.subject),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('From: ${email.sender}'),
              SizedBox(height: 8),
              Text(email.content),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermez la boîte de dialogue
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmailSenderR(
                    sender: email.sender, // Passer le destinataire
                    subject: 'Re: ${email.subject}', // Préfixer le sujet
                  ),
                ),
              );
            },
            child: Text('Répondre'),
          ),
          ],
        );
      },
    );
  }
}


