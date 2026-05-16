import 'package:http/http.dart' as http;
import 'package:superhero_compare/models/heroes_dto.dart';
import 'package:superhero_compare/config/api_conf.dart';
import 'package:flutter/foundation.dart';
class RemoteService {
  var client = http.Client();

  Future<http.Response> get(String endpoint) async {
      final uri = Uri.parse(
        "${ApiConf.baseUrl}/${ApiConf.apiKey}/$endpoint"
      );
      return await client.get(uri);
  }

 Future<List<Heroes>?> getAllHeroes() async {
  List<Heroes> heroes = [];
  
  for (var i = 1; i < 3; i++) { 
    var response = await get("$i");
    debugPrint("Body herói $i: ${response.body}"); 
    if (response.statusCode == 200) {
      var hero = heroesFromJson(response.body);
      debugPrint("Nome: ${hero.name}, Imagem: ${hero.heroImage.url}");
      heroes.add(hero);
    }
  }
  return heroes;
}
}

void main() async {
  var service = RemoteService();

  var heroes =
      await service.getAllHeroes();

  print(heroes);
}