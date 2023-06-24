import 'package:esports_league/data/dummy_data.dart';
import 'package:esports_league/view/new_camp_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Esports League"),
      ),
      body: Center(
        child: Image.asset('assets/images/home_image.png'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewCampeonatoScreen(
                teams: dummyTeams,
                leagues: leagues,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
