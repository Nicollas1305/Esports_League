import 'package:esports_league/components/drawer.dart';
import 'package:esports_league/data/database_helper.dart';
import 'package:esports_league/data/dummy_data.dart';
import 'package:esports_league/model/Championship.dart';
import 'package:esports_league/view/new_camp_screen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DatabaseHelper databaseHelper;
  List<Championship> championships = [];

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper.instance;
  }

  Future<List<Championship>>? getChampionshipsFromDatabase() async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('championships');

    if (maps.isEmpty) {
      return null!; // Retorna null caso não haja campeonatos no banco de dados
    }

    return List<Championship>.from(
      maps.map((championship) => Championship.fromJson(championship)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Esports League"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<List<Championship>>(
        future: getChampionshipsFromDatabase(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Championship>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Column(
              children: [
                Text("AQUI ERRO"),
                Text('Error: ${snapshot.error}'),
              ],
            );
          } else if (snapshot.hasData) {
            final List<Championship> championships = snapshot.data!;
            if (championships.isEmpty) {
              // Exibir a imagem quando não houver campeonatos
              return Column(
                children: [
                  Text('Sem campeonatos cadastrados!'),
                  Image.asset('assets/images/no_data_image.png'),
                ],
              );
            } else {
              // Exibir o widget com a lista de campeonatos
              return ListView.builder(
                itemCount: championships.length,
                itemBuilder: (context, index) {
                  final Championship championship = championships[index];
                  return ListTile(
                    title: Text(championship.name),
                    subtitle: Text(championship.date.toString()),
                    // Resto do código para exibir as informações do campeonato
                  );
                },
              );
            }
          } else {
            // Caso não haja dados e também não ocorra erro, exibir uma mensagem de "Nenhum dado encontrado"
            return Column(
              children: [
                Text('Sem campeonatos cadastrados!'),
                Image.asset('assets/images/no_data_image.png'),
              ],
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
        child: Icon(Icons.add),
      ),
    );
  }
}
