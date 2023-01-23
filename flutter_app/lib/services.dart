import 'package:dio/dio.dart';

class Requests {
  static Future<List<dynamic>> getAllMatches() async {
    final dio = Dio();
    final response = await dio.get('http://localhost:5000/getAllMatches');
    if (response.statusCode != 200) {
      throw Exception('Failed to get matches');
    }
    return response.data;
  }

  static Future<List<dynamic>> getMatchByCountry(String country) async {
    final dio = Dio();
    final response =
        await dio.get('http://localhost:5000/getMatchesByTeam/$country');
    if (response.statusCode != 200) {
      throw Exception('Failed to get matches');
    }
    return response.data;
  }

  static Future<void> postMatch(DateTime date, String homeTeam, String awayTeam,
      int homeTeamScore, int awayTeamScore) async {
    final dio = Dio();
    final response = await dio.post('http://localhost:5000/addMatch', data: {
      'date': date.toIso8601String(),
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeTeamScore': homeTeamScore,
      'awayTeamScore': awayTeamScore,
    });
    return response.data;
  }

  static Future<void> deleteMatch(int id) async {
    final dio = Dio();
    dio.head('http://localhost:5000/deleteMatch/$id',
        options: Options(
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': '*',
            'Access-Control-Allow-Headers':
                'Origin, Content-Type, X-Auth-Token',
          },
        ));
    final response = await dio.post('http://localhost:5000/deleteMatch/$id');
    return response.data;
  }
}
