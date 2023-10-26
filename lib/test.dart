import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: EmailVerificationPage(),
  ));
}

class EmailVerificationPage extends StatelessWidget {
  final _recipientController = TextEditingController();

  String generateRandomCode(int length) {
    final random = Random();
    const chars = '0123456789';
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Enter your email to receive a verification code:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _recipientController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final recipientEmail = _recipientController.text.trim();
                final verificationCode = generateRandomCode(6); // Generate a random 6-digit code

                sendEmail(recipientEmail, verificationCode);

                // You can now display a message to the user indicating that the verification email has been sent.
              },
              child: Text('Send Verification Email'),
            ),
          ],
        ),
      ),
    );
  }
}
