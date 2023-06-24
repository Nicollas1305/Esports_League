import 'package:esports_league/data/database_helper.dart';
import 'package:esports_league/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class NewCampeonatoScreen extends StatefulWidget {
  final List<Team> teams;
  final List<League> leagues;

  NewCampeonatoScreen({required this.teams, required this.leagues});

  @override
  _NewCampeonatoScreenState createState() => _NewCampeonatoScreenState();
}

class _NewCampeonatoScreenState extends State<NewCampeonatoScreen> {
  String? selectedLeague;
  String? selectedTeam;
  String? selectedLeagueId;

  late DatabaseHelper databaseHelper;

  List<int> quantidadeJogadoresOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int selectedQuantidadeJogadores = 1;

  Future<List<String>> getAssetImages(String directory) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/$directory');
    if (await imagesDir.exists()) {
      final imageFiles = await imagesDir.list().toList();
      return imageFiles
          .where((file) => file is File && file.path.endsWith('.png'))
          .map((file) => file.path)
          .toList();
    }
    return [];
  }

  void _showAddTeamDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar time'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Selecione a liga:'),
              DropdownButton<String>(
                value: selectedLeague,
                items: leagues.map((league) {
                  return DropdownMenuItem<String>(
                    value: league.name,
                    child: Row(
                      children: [
                        FutureBuilder<List<String>>(
                          future: getAssetImages('assets/images'),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final imagePaths = snapshot.data!;
                              final leagueImagePath = imagePaths.firstWhere(
                                  (path) => path.contains(league.name));
                              return Image.asset(
                                leagueImagePath,
                                width: 24,
                                height: 24,
                              );
                            }
                            return Container();
                          },
                        ),
                        SizedBox(width: 10),
                        Text(league.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLeague = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Text('Selecione o time:'),
              DropdownButton<String>(
                value: selectedTeam,
                onChanged: (value) {
                  setState(() {
                    selectedTeam = value;
                  });
                },
                items: dummyTeams
                    .where((team) => team.leagueId == selectedLeagueId)
                    .map((team) {
                  return DropdownMenuItem<String>(
                    value: team.name,
                    child: Row(
                      children: [
                        Image.asset(team
                            .logo), // Substitua pela lógica adequada para exibir o logo do time
                        SizedBox(width: 10),
                        Text(team.name),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            FlatButton(
              onPressed: () {
                // Adicionar a lógica para salvar o time selecionado no banco de dados
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    DatabaseHelper databaseHelper = DatabaseHelper.namedConstructor();
    selectedLeague;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Campeonato'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<int>(
              value: selectedQuantidadeJogadores,
              items: quantidadeJogadoresOptions.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  selectedQuantidadeJogadores = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Quantidade de Jogadores',
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: RaisedButton(
                onPressed: () {
                  _showAddTeamDialog();
                },
                child: Text('Adicionar time'),
              ),
            ),
            SizedBox(height: 16),
            RaisedButton(
              onPressed: () {
                if (selectedLeague != null &&
                    selectedTeam != null &&
                    selectedQuantidadeJogadores > 0) {
                  // Realize as ações necessárias

                  // Criar o campeonato utilizando os valores selecionados
                  databaseHelper.createCampeonato(selectedQuantidadeJogadores,
                      selectedLeague, selectedTeam);
                  Navigator.pop(context);
                } else {
                  // Exibir mensagem de erro se a liga, o time ou a quantidade de jogadores não forem selecionados corretamente
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Erro'),
                      content: Text('Preencha todos os campos corretamente.'),
                      actions: [
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Criar Campeonato'),
            ),
          ],
        ),
      ),
    );
  }
}
