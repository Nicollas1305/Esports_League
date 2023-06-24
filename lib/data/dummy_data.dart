import 'package:esports_league/model/League.dart';
import 'package:esports_league/model/Team.dart';

List<League> leagues = [
  League(id: 1, name: 'La Liga', logo: 'liga_espanola.png'),
  League(id: 2, name: 'Brasileirão', logo: 'brasileirao.png'),
  League(id: 3, name: 'Premier League', logo: 'premier_league.png'),
  League(id: 4, name: 'A League', logo: 'a_League.png'),
  League(id: 5, name: 'Eredivisie', logo: 'eredivisie.png'),
];

List<Team> dummyTeams = [
  Team(id: 1, name: 'Real Madrid', logo: 'real_madrid.png', leagueId: 1),
  Team(id: 2, name: 'Barcelona', logo: 'barcelona.png', leagueId: 1),
  Team(id: 3, name: 'Flamengo', logo: 'flamengo.png', leagueId: 2),
  Team(id: 4, name: 'Palmeiras', logo: 'palmeiras.png', leagueId: 2),
  Team(id: 5, name: 'Manchester United', logo: 'manchester.png', leagueId: 3),
  Team(id: 6, name: 'Liverpool', logo: 'liverpool.png', leagueId: 3),
  Team(id: 7, name: 'Sydney FC', logo: 'sydney.png', leagueId: 4),
  Team(id: 8, name: 'Melbourne Victory', logo: 'melbourne.png', leagueId: 4),
  Team(id: 9, name: 'Ajax', logo: 'ajax_amsterdam.png', leagueId: 5),
  Team(id: 10, name: 'PSV Eindhoven', logo: 'psv_eindhoven.png', leagueId: 5),
];
