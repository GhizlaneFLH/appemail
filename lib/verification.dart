import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login.dart';
import 'dart:math';
import 'InputDeco_design.dart';
class Emailverification extends StatefulWidget {
  final String emailver;

  Emailverification({required this.emailver});

  @override
  _EmailSenderState createState() => _EmailSenderState();
}

class _EmailSenderState extends State<Emailverification> {
  late TextEditingController _toController;
  TextEditingController code = TextEditingController();
  String a = '';
  @override
  void initState() {
    super.initState();
    _toController = TextEditingController(text: widget.emailver);

    // Appeler la fonction sendEmail automatiquement lorsque le widget est initialisé
    final recipientEmail = _toController.text.trim();
    final verificationCode = generateRandomCode(6);
    sendEmail(recipientEmail, verificationCode);
  }

  String generateRandomCode(int length) {
    final random = Random();
    const chars = '0123456789';
    a = List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
    return a;
  }

  void sendEmail(String recipientEmail, String verificationCode) async {
    final smtpServer = gmail('flhghizlane@gmail.com', 'roivbcaxljrmfikn');

    final message = Message()
      ..from = Address('flhghizlane@gmail.com', 'Ghizlane Flh')
      ..recipients.add(recipientEmail)
      ..subject = 'Email Verification'
      ..text = 'Your verification code is: $verificationCode';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } catch (e) {
      print('Message not sent. Error: $e');
    }
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
          title: Text('Email Verification'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Un code de verification  est envoye a cette adresse email :',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                child: TextFormField(
                  controller: code,
                  keyboardType: TextInputType.text,
                  decoration:
                        buildInputDecoration(Icons.lock, "Confirm Password"),
                  validator: (String? value) {
                    // Mettez à jour la signature pour accepter String? au lieu de String
                    if (value == null || value.isEmpty) {
                      return 'Please Enter code';
                    }

                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 39, 190, 170),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: BorderSide(
                        color: Color.fromARGB(255, 39, 190, 170), width: 2),
                  ),
                ),
                onPressed: () {
                  if (code.text == a) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Formlogin(),
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(
                      backgroundColor: Colors.orange,
                      textColor: Colors.white,
                      msg: 'User already exit!',
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }
                },
                child: Text('Verification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
