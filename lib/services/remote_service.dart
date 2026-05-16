import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:superhero_compare/models/heroes_dto.dart';
import 'package:superhero_compare/config/api_conf.dart';

class RemoteService {
  static final http.Client _client = http.Client();

  Future<http.Response> get(String endpoint) async {
    final uri = Uri.parse(
      "${ApiConf.baseUrl}/${ApiConf.apiKey}/$endpoint",
    );
    return await _client.get(uri);
  }

  Future<List<Heroes>> getHeroesByRange(int from, int to) async {
    final futures = List.generate(
      to - from,
      (i) => getHeroById((from + i).toString()),
    );

    final results = await Future.wait(futures);

    return results
        .whereType<Heroes>()
        .where((h) => h.response == "success")
        .toList();
  }

  Future<Heroes?> getHeroById(String id) async {
    try {
      var response = await get(id);
      if (response.statusCode == 200) {
        final hero = heroesFromJson(response.body);
        return hero.response == "success" ? hero : null;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<List<Heroes>> searchByName(String name) async {
    try {
      var response = await get("search/$name");
      if (response.statusCode == 200) {
        final result = HeroSearchResult.fromJson(jsonDecode(response.body));
        return result.results;
      }
    } catch (e) {
      return [];
    }
    return [];
  }
}