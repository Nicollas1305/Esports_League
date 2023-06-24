class League {
  int id;
  String name;
  String logo;

  League({required this.id, required this.name, required this.logo});

  String get leagueLogo => logo;
}

List<League> leagues = [
  League(id: 1, name: 'La Liga', logo: 'brasileirao_logo.png'),
  League(id: 2, name: 'Brasileirão', logo: 'Liga_espanola_logo.png'),
];

class Team {
  String name;
  String logo;
  int leagueId;

  Team({required this.name, required this.logo, required this.leagueId});

  int get teamLeague => leagueId;
}

List<Team> dummyTeams = [
  Team(
    name: "Real Madrid",
    logo: "real_madrid_logo.png",
    leagueId: 1,
  ),
  Team(
    name: "Barcelona",
    logo: "barcelona_logo.png",
    leagueId: 1,
  ),
  Team(
    name: "Atlético Madrid",
    logo: "atletico_madrid_logo.png",
    leagueId: 1,
  ),
  Team(
    name: "Sevilla",
    logo: "sevilla_logo.png",
    leagueId: 1,
  ),
  Team(
    name: "Valencia",
    logo: "valencia_logo.png",
    leagueId: 1,
  ),
  Team(
    name: "Flamengo",
    logo: "flamengo_logo.png",
    leagueId: 2,
  ),
  Team(
    name: "Palmeiras",
    logo: "palmeiras_logo.png",
    leagueId: 2,
  ),
];
