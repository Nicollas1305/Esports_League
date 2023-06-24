class Team {
  int id;
  String name;
  String logo;
  int leagueId;

  Team(
      {required this.id,
      required this.name,
      required this.logo,
      required this.leagueId});

  int get teamLeague => leagueId;

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      leagueId: json['leagueId'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'leagueId': leagueId,
    };
  }
}
