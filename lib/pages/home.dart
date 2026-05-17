import 'dart:async';
import 'package:flutter/material.dart';
import 'package:superhero_compare/models/heroes_dto.dart';
import 'package:superhero_compare/services/remote_service.dart';
import 'package:superhero_compare/shared/hero_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  List<Heroes> heroes = [];
  List<Heroes> searchResults = [];

  int _currentId = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isSearching = false;
  bool _isSearchLoading = false;

  Timer? _debounce; // evita chamada a cada letra digitada

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final RemoteService _service = RemoteService(); // instância única

  @override
  void initState() {
    super.initState();
    _loadMore();

    _scrollController.addListener(() {
      final nearBottom = _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300;

      if (nearBottom && !_isLoading && _hasMore && !_isSearching) {
        _loadMore();
      }
    });

    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    const batchSize = 20;
    final to = (_currentId + batchSize).clamp(0, 732);

    // paralelo: 20 requisições ao mesmo tempo
    final newHeroes = await _service.getHeroesByRange(_currentId, to);

    setState(() {
      _currentId = to;
      if (_currentId >= 731) _hasMore = false;
      heroes.addAll(newHeroes);
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel(); // cancela o timer anterior

    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        searchResults = [];
      });
      return;
    }

    setState(() => _isSearching = true);

    // só dispara a busca 500ms após parar de digitar
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _isSearchLoading = true);

      final results = await _service.searchByName(query);

      setState(() {
        searchResults = results;
        _isSearchLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _isSearching ? searchResults : heroes;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesquisar Heróis"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar herói...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
          ),
          Expanded(
            child: _isSearchLoading
                ? const Center(child: CircularProgressIndicator())
                : displayList.isEmpty && _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : displayList.isEmpty && _isSearching
                        ? const Center(child: Text("Nenhum herói encontrado"))
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            itemCount: displayList.length + (!_isSearching && _hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == displayList.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: HeroCard(hero: displayList[index]),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}