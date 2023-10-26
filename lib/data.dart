import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'naviigation_drawer.dart';
import 'package:http/http.dart' as http;
import 'sendreponse.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

class AllEmails extends StatefulWidget {
  @override
  _AllEmailsState createState() => _AllEmailsState();
}

class _AllEmailsState extends State<AllEmails> {
  List<Email> emailList = [];
  Future<void> fetchSortedEmails(String sortOrder) async {
    var url = Uri.http("192.168.0.183", '/TEMACONCEPT/tri.php', {
      'q': '{http}',
      'sort_order': sortOrder
    }); // Ajoutez le paramètre de tri

    // Exécutez la requête HTTP pour récupérer les e-mails triés
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // Parsez les données JSON pour obtenir la liste triée d'e-mails
      List<dynamic> jsonList = json.decode(response.body);

      setState(() {
        emailList = jsonList
            .map((emailJson) => Email(
                  emailJson['sender'],
                  emailJson['subject'],
                  emailJson['content'],
                  DateTime.parse(emailJson['date']),
                ))
            .toList();
      });
    } else {
      print(
          'Erreur lors de la récupération des e-mails. Statut : ${response.statusCode}');
      print('Réponse du serveur : ${response.body}');
    }
  }

  Future<void> loadEmails() async {
    String jsonData = await rootBundle.loadString('assets/data.json');
    List<dynamic> jsonList = json.decode(jsonData);
    var url =
        Uri.http("192.168.0.183", '/TEMACONCEPT/all.php', {'q': '{http}'});

    for (var emailJson in jsonList) {
      String sender = emailJson['sender'];
      String subject = emailJson['subject'];
      String content = emailJson['content'];
      DateTime date =
          DateTime.parse(emailJson['date']); // Parse the date string

      var response = await http.post(url, body: {
        "sender": sender,
        "subject": subject,
        "content": content,
        "date": DateFormat('yyyy-MM-dd HH:mm').format(date),
      });

      if (response.statusCode == 200) {
        print('Email sauvegardé avec succès');
      } else {
        print(
            'Erreur lors de la sauvegarde de l\'email. Statut : ${response.statusCode}');
        print('Réponse du serveur : ${response.body}');
      }
    }

    setState(() {
      emailList = jsonList
          .map((emailJson) => Email(
                emailJson['sender'],
                emailJson['subject'],
                emailJson['content'],
                DateTime.parse(emailJson['date']),
              ))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadEmails();
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
          title: Text('Boîte de réception'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: EmailSearchDelegate(
                      emailList), // Utilisez votre propre délégué de recherche
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                // Afficher un menu de tri
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.calendar_today),
                          title: Text('Plus récent'),
                          onTap: () {
                            // Demandez au serveur PHP de trier les e-mails par ordre décroissant
                            fetchSortedEmails('desc');
                            Navigator.pop(context); // Fermer le menu
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.calendar_view_day),
                          title: Text('Plus ancien'),
                          onTap: () {
                            // Demandez au serveur PHP de trier les e-mails par ordre croissant
                            fetchSortedEmails('asc');
                            Navigator.pop(context); // Fermer le menu
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
        drawer: NavigationDrawe(),
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
                          emailList[index].subject,
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
                                    '/TEMACONCEPT/mark_delet.php',
                                    {'q': '{http}'});
                                var response = await http.post(url, body: {
                                  "sender": emailList[index].sender,
                                  "subject": emailList[index].subject,
                                  "content": emailList[index].content,
                                  "date": DateFormat('yyyy-MM-dd HH:mm')
                                      .format(emailList[index].date),
                                });
                                //var data = json.decode(response.body);
                                if (response.statusCode == 200) {
                                  print('- Email deleted');
                                  Fluttertoast.showToast(
                                    msg: '- Email deleted',
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
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
                            icon: Icon(Icons.star),
                            onPressed: () async {
                              try {
                                var url = Uri.http(
                                    "192.168.0.183",
                                    '/TEMACONCEPT/mark_starred.php',
                                    {'q': '{http}'});
                                var response = await http.post(url, body: {
                                  "sender": emailList[index].sender,
                                  "subject": emailList[index].subject,
                                  "content": emailList[index].content,
                                  "date": DateFormat('yyyy-MM-dd HH:mm')
                                      .format(emailList[index].date),
                                });
                                //var data = json.decode(response.body);
                                if (response.statusCode == 200) {
                                  print('succès');
                                  Fluttertoast.showToast(
                                    msg: 'Success ',
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                } else {
                                  print('Erreur ');
                                  Fluttertoast.showToast(
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    msg: 'Error ',
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                }
                              } catch (e) {
                                print("object");
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(emailList[index].sender),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm')
                        .format(emailList[index].date),
                    style: TextStyle(
                      fontSize: 10, // Définissez la taille de police souhaitée
                      color: Colors.grey, // Définissez la couleur du texte
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

  String generateAutomaticResponse() {
    return "Merci pour votre e-mail. Je vais le prendre en considération.";
  }

  void _showEmailContent(BuildContext context, Email email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController responseController =
            TextEditingController(); // Contrôleur pour le champ de texte
        String automaticResponse = generateAutomaticResponse();
        return AlertDialog(
          title: Text(email.subject),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('De : ${email.sender}'),
              SizedBox(height: 8),
              Text(email.content),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  responseController.text =
                      automaticResponse; // Remplir le champ avec la réponse automatique
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, // Couleur de fond du bouton
                  onPrimary: const Color.fromARGB(
                      255, 39, 39, 39), // Couleur du texte du bouton
                  side: BorderSide(
                      color: Color.fromARGB(255, 187, 197, 199),
                      width: 2.0), // Couleur et largeur de la bordure
                ),
                child: Text(automaticResponse),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
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

class EmailSearchDelegate extends SearchDelegate<Email> {
  final List<Email> emailList;

  EmailSearchDelegate(this.emailList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Email('', '', '', DateTime.now()));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implémentez la logique de recherche ici
    final results = emailList
        .where((email) =>
            email.subject.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final email = results[index];
        return ListTile(
          title: Text(email.subject),
          // Affichez d'autres informations sur l'email ici
          onTap: () {
            // Gérez l'action lorsque l'utilisateur sélectionne un résultat
            close(context, email);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions basées sur la recherche actuelle
    final suggestionList = emailList
        .where((email) =>
            email.subject.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final email = suggestionList[index];
        return ListTile(
          title: Text(email.subject),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(email.sender),
              Text(
                DateFormat('yyyy-MM-dd HH:mm').format(emailList[index].date),
                style: TextStyle(
                  fontSize:
                      12, // Définissez la taille de police souhaitée pour la date
                  color: Colors.grey, // Définissez la couleur de la date
                ),
              ),
            ],
          ),
          // Affichez d'autres informations sur l'email ici
          onTap: () {
            // Mettre à jour la recherche avec la suggestion sélectionnée
            query = email.content;
          },
        );
      },
    );
  }
}
