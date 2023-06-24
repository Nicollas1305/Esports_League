import 'package:esports_league/data/database_helper.dart';
import 'package:esports_league/data/dummy_data.dart';
import 'package:esports_league/model/League.dart';
import 'package:esports_league/model/Team.dart';
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
  League? selectedLeague;
  Team? selectedTeam;
  String? selectedLeagueId;

  late DatabaseHelper databaseHelper;

  List<int> quantidadeJogadoresOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int selectedQuantidadeJogadores = 2;
  List<Team> selectedTeams = [];

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
    if (selectedTeams.length >= selectedQuantidadeJogadores) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text(
              'Limite máximo de ${selectedQuantidadeJogadores} times atingido.'),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Adicionar time'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selecione a liga:'),
                    DropdownButton<League>(
                      value: selectedLeague,
                      items: leagues.map((league) {
                        return DropdownMenuItem<League>(
                          value: league,
                          child: Row(
                            children: [
                              Image.asset('assets/images/${league.logo}'),
                              SizedBox(width: 10),
                              Text(league.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLeague = value!;
                          selectedTeam = null;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Text('Selecione o time:'),
                    DropdownButton<Team>(
                      value: selectedTeam,
                      onChanged: (value) {
                        setState(() {
                          selectedTeam = value!;
                        });
                      },
                      items: dummyTeams
                          .where((team) => team.leagueId == selectedLeague?.id)
                          .map((team) {
                        return DropdownMenuItem<Team>(
                          value: team,
                          child: Row(
                            children: [
                              Image.asset('assets/images/${team.logo}'),
                              SizedBox(width: 10),
                              Text(team.name),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  if (selectedTeam != null) {
                    // Verifica se o time já existe na lista
                    if (selectedTeams.contains(selectedTeam)) {
                      // Time já existe na lista
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Erro'),
                          content: Text(
                              'Esse time já está na lista. Selecione outro!'),
                          actions: [
                            FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Verifica se o número máximo de times foi atingido
                      if (selectedTeams.length >= selectedQuantidadeJogadores) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Erro'),
                            content: Text(
                                'Limite máximo de ${selectedQuantidadeJogadores} times atingido.'),
                            actions: [
                              FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      setState(() {
                        selectedTeams.add(selectedTeam!);
                      });
                      print(selectedTeams);
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text('Adicionar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    selectedLeague;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Campeonato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
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
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedTeams.length,
                  itemBuilder: (context, index) {
                    Team team = selectedTeams[index];
                    return Card(
                      child: ListTile(
                        leading: Image.asset('assets/images/${team.logo}'),
                        title: Text(team.name),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
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
                      selectedQuantidadeJogadores > 0) {
                    if (selectedTeams.length < selectedQuantidadeJogadores) {
                      String timesWord =
                          selectedQuantidadeJogadores - selectedTeams.length ==
                                  1
                              ? 'time'
                              : 'times';
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Erro'),
                          content: Text(
                              'Adicione mais ${selectedQuantidadeJogadores - selectedTeams.length} ${timesWord}'),
                          actions: [
                            FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Realize as ações necessárias

                      // Criar o campeonato utilizando os valores selecionados
                      /*databaseHelper.createCampeonato(
                          selectedQuantidadeJogadores,
                          selectedLeague,
                          selectedTeams);*/
                      Navigator.pop(context);
                    }
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
      ),
    );
  }
}
