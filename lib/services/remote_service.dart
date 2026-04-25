import 'package:http/http.dart' as http;
import 'package:superhero_compare/models/heroes_dto.dart';
import 'package:superhero_compare/config/api_conf.dart';

class RemoteService {
  var client = http.Client();

  Future<http.Response> get(String endpoint) async {
      final uri = Uri.parse(
        "${ApiConf.baseUrl}/${ApiConf.apiToken}/$endpoint"
      );
      return await client.get(
        uri,
        headers: {
          'User-Agent':'Mozilla/5.0',
          'Accept': 'application/json'
        }
      );
  }

  Future<List<Heroes>?> getAllHeroes() async {
    List<Heroes> heroes = [];
    
    for (var i = 1; i < 2; i++) {
      var response = await get("$i");
      if (response.statusCode == 200) {
        var hero = heroesFromJson(response.body);
        heroes.add(hero);
      }
    }
    return heroes;

  }

  

}