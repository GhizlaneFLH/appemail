import 'package:flutter/material.dart';
import 'drawer_item.dart';
import 'people.dart';
import 'adminreponce.dart';
import 'FormPage.dart';
import 'emailsup.dart';

class Navigation extends StatelessWidget {
  const Navigation({Key? key}) : super(key: key);
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
                            EmailLReponce()), // Navigue vers la nouvelle page
                  );
                },
              ),
              DrawerItem(
                name: 'contrôle d' "'" 'accès ',
                icon: Icons.wb_incandescent,
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le tiroir
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            EmailListsupp()), // Navigue vers la nouvelle page
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
            Text('Temaconcept',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 46, 45, 46))),
            SizedBox(
              height: 10,
            ),
            Text('person@email.com',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 46, 45, 46)))
          ],
        )
      ],
    );
  }
}
