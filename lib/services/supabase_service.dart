import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superhero_compare/models/heroes_dto.dart';

/// Serviço responsável por toda a persistência de dados no Supabase.
/// Gerencia três tabelas: team, favorites e comparison_history.
class SupabaseService {
  // Instância do cliente Supabase, inicializado no main.dart
  final _supabase = Supabase.instance.client;

  // ==================== TIME ====================

  /// Adiciona um herói ao time do usuário.
  /// Salva apenas os powerstats relevantes para comparação,
  /// conforme definido nos requisitos do projeto.
  Future<void> addToTeam(Heroes hero) async {
    await _supabase.from('team').insert({
      'hero_id': hero.id,                              // ID único da API
      'hero_name': hero.name,                          // Nome do herói
      'hero_image': hero.heroImage.url,                // URL da imagem
      'intelligence': hero.powerstats.intelligence,    // Estatística: inteligência
      'strength': hero.powerstats.strength,            // Estatística: força
      'speed': hero.powerstats.speed,                  // Estatística: velocidade
      'durability': hero.powerstats.durability,        // Estatística: durabilidade
      'power': hero.powerstats.power,                  // Estatística: poder
      'combat': hero.powerstats.combat,                // Estatística: combate
    });
  }

  /// Busca todos os heróis salvos no time do usuário,
  /// ordenados do mais recente para o mais antigo.
  Future<List<Map<String, dynamic>>> getTeam() async {
    final response = await _supabase
        .from('team')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Remove um herói específico do time pelo seu ID no banco.
  Future<void> removeFromTeam(String id) async {
    await _supabase.from('team').delete().eq('id', id);
  }

  // ==================== FAVORITOS ====================

  /// Adiciona um herói à lista de favoritos do usuário.
  /// Salva apenas as informações básicas de identificação.
  Future<void> addFavorite(Heroes hero) async {
    await _supabase.from('favorites').insert({
      'hero_id': hero.id,
      'hero_name': hero.name,
      'hero_image': hero.heroImage.url,
    });
  }

  /// Busca todos os heróis favoritados pelo usuário,
  /// ordenados do mais recente para o mais antigo.
  Future<List<Map<String, dynamic>>> getFavorites() async {
    final response = await _supabase
        .from('favorites')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Remove um herói específico dos favoritos pelo seu ID no banco.
  Future<void> removeFavorite(String id) async {
    await _supabase.from('favorites').delete().eq('id', id);
  }

  // ==================== HISTÓRICO DE COMPARAÇÕES ====================

  /// Salva um registro de comparação entre dois heróis.
  /// Útil para histórico e análise de batalhas anteriores.
  Future<void> saveComparison(Heroes hero1, Heroes hero2) async {
    await _supabase.from('comparison_history').insert({
      'hero1_id': hero1.id,
      'hero1_name': hero1.name,
      'hero2_id': hero2.id,
      'hero2_name': hero2.name,
    });
  }

  /// Busca todo o histórico de comparações realizadas,
  /// ordenado da mais recente para a mais antiga.
  Future<List<Map<String, dynamic>>> getComparisonHistory() async {
    final response = await _supabase
        .from('comparison_history')
        .select()
        .order('compared_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
}