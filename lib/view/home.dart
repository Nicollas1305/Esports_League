import 'package:esports_league/components/drawer.dart';
import 'package:esports_league/data/database_helper.dart';
import 'package:esports_league/data/dummy_data.dart';
import 'package:esports_league/view/new_camp_screen.dart';
import 'package:flutter/material.dart';
import 'package:esports_league/model/Championship.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper.instance;
    insertFakeChampionship();
  }

  Future<void> insertFakeChampionship() async {
    List<String> teams = ['Team A', 'Team B', 'Team C'];
    List<String> players = ['Nicollas', 'Isaac', 'Kawe'];
    await databaseHelper.createChampionship(
        'Fake Championship', '2023-06-30', teams, players);
    setState(() {}); // Refresh the UI after inserting the fake championship
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esports League'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<List<Championship>>(
        future: databaseHelper.readChampionships(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            List<Championship> championships = snapshot.data!;
            if (championships.isEmpty) {
              // No championships in the database, show the home image
              return Center(
                child: Image.asset('assets/images/home_image.png'),
              );
            } else {
              // Show the list of championships
              return ListView.builder(
                itemCount: championships.length,
                itemBuilder: (context, index) {
                  Championship championship = championships[index];
                  return Card(
                    child: ListTile(
                      title: Text(championship.name),
                      subtitle: Text(championship.date),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Handle tap on the championship to show more information
                      },
                    ),
                  );
                },
              );
            }
          } else {
            return const Center(
              child: Text('Error loading championships'),
            );
          }
        },
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
