import 'package:esports_league/model/Team.dart';

class Championship {
  int id;
  String name;
  String date;
  List<Team> teams;

  Championship({
    required this.id,
    required this.name,
    required this.date,
    required this.teams,
  });

  factory Championship.fromJson(Map<String, dynamic> json) {
    return Championship(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      teams: List<Team>.from(
          json['teams'].map((teamJson) => Team.fromJson(teamJson))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'teams': teams.map((team) => team.toJson()).toList(),
    };
  }
}
