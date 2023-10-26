import 'package:flutter/material.dart';
import 'drawer_item.dart';
import 'login.dart';
import 'people.dart';
import 'envoi.dart';
import 'data.dart';
import 'suivis.dart';
import 'stage.dart';
import 'emploi.dart';
import 'service.dart';
import 'delet.dart';
import 'FormPage.dart';
import 'autre.dart';

class NavigationDrawe extends StatelessWidget {
  const NavigationDrawe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color(0xffb3eed8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 80, 24, 0),
          child: Column(
            children: [
              headerWidget(),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                thickness: 1,
                height: 10,
                color: Color.fromARGB(255, 75, 74, 75),
              ),
              DrawerItem(
                name: 'Principale',
                icon: Icons.home,
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le tiroir
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            AllEmails()), // Navigue vers la nouvelle page
                  );
                },
              ),
              DrawerItem(
                name: 'Offre de stage',
                icon: Icons.wb_incandescent,
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le tiroir
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            EmailListstage()), // Navigue vers la nouvelle page
                  );
                },
              ),
              DrawerItem(
                name: 'Offre de travail',
                icon: Icons.work,
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le tiroir
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            EmailListemploi()), // Navigue vers la nouvelle page
                  );
                },
              ),
              DrawerItem(
                name: 'Offre des services',
                icon: Icons.timeline_outlined,
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le tiroir
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            EmailListservice()), // Navigue vers la nouvelle page
                  );
                },
              ),
              DrawerItem(
                name: 'Autre',
                icon: Icons.mail,
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le tiroir
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            EmailListautre()), // Navigue vers la nouvelle page
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                thickness: 1,
                height: 10,
                color: Color.fromARGB(255, 75, 74, 75),
              ),
              DrawerItem(
                name: 'Message suivis',
                icon: Icons.star,
                //account_box_rounded
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le tiroir
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            EmailListSuivis()), // Navigue vers la nouvelle page
                  );
                },
              ),
              DrawerItem(
                name: 'Nouveau message',
                icon: Icons.create,
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le tiroir
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            EmailSender()), // Navigue vers la nouvelle page
                  );
                },
              ),
              DrawerItem(
                name: 'Message Envoyés',
                icon: Icons.send,
                //account_box_rounded
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le tiroir
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            EmailListScreen()), // Navigue vers la nouvelle page
                  );
                },
              ),
              DrawerItem(
                name: 'Corbeille',
                icon: Icons.delete,
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le tiroir
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            EmailListdelet()), // Navigue vers la nouvelle page
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                thickness: 1,
                height: 10,
                color: Color.fromARGB(255, 75, 74, 75),
              ),
              DrawerItem(
                  name: 'Paramètre',
                  icon: Icons.settings,
                  onPressed: () => onItemPressed(context, index: 4)),
              DrawerItem(
                name: 'Se déconnecter',
                icon: Icons.logout,
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le tiroir
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            FormPage()), // Navigue vers la nouvelle page
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onItemPressed(BuildContext context, {required int index}) {
    Navigator.pop(context);

    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const People()));
        break;
    }
  }

  Widget headerWidget() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tema Concept',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 46, 45, 46))),
            SizedBox(
              height: 10,
            ),
            Text('tema@email.com',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 46, 45, 46)))
          ],
        )
      ],
    );
  }
}
