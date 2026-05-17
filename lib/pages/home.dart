import 'dart:async';
import 'package:flutter/material.dart';
import 'package:superhero_compare/models/heroes_dto.dart';
import 'package:superhero_compare/services/remote_service.dart';
import 'package:superhero_compare/shared/hero_card.dart';
import 'package:superhero_compare/shared/app_bar.dart';
import 'package:superhero_compare/pages/comparison_page.dart'; 

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  List<Heroes> heroes = [];
  List<Heroes> searchResults = [];
  List<Heroes> heroisSelecionados = [];
  bool modoComparacao = false;

  int _currentId = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isSearching = false;
  bool _isSearchLoading = false;

  Timer? _debounce;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final RemoteService _service = RemoteService();

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
    final newHeroes = await _service.getHeroesByRange(_currentId, to);

    setState(() {
      _currentId = to;
      if (_currentId >= 731) _hasMore = false;
      heroes.addAll(newHeroes);
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();

    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        searchResults = [];
      });
      return;
    }

    setState(() => _isSearching = true);

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _isSearchLoading = true);
      final results = await _service.searchByName(query);
      setState(() {
        searchResults = results;
        _isSearchLoading = false;
      });
    });
  }

  void _toggleModoComparacao(bool valor) {
    setState(() {
      modoComparacao = valor;
      heroisSelecionados.clear();
    });
  }

  void _toggleSelecaoHeroi(Heroes hero) {
    setState(() {
      final jaSelecionado = heroisSelecionados.any((h) => h.id == hero.id);

      if (jaSelecionado) {
        heroisSelecionados.removeWhere((h) => h.id == hero.id);
      } else if (heroisSelecionados.length < 2) {
        heroisSelecionados.add(hero);
      }
    });
  }

  void _abrirComparacao() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ComparePage(
          heroA: heroisSelecionados[0],
          heroB: heroisSelecionados[1],
        ),
      ),
    ).then((_) {
      setState(() {
        heroisSelecionados.clear();
        modoComparacao = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _isSearching ? searchResults : heroes;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "HeroCompare",
        showBackButton: false,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
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

                const SizedBox(width: 8),

                Tooltip(
                  message: 'Modo comparação',
                  child: GestureDetector(
                    onTap: () => _toggleModoComparacao(!modoComparacao),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: modoComparacao ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.compare_arrows,
                        color: modoComparacao ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ← banner corrigido com botão de confirmar
          if (modoComparacao)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              color: Colors.blue.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      heroisSelecionados.isEmpty
                          ? 'Selecione 2 heróis para comparar'
                          : heroisSelecionados.length == 1
                              ? 'Selecione mais 1 herói'
                              : '${heroisSelecionados[0].name} vs ${heroisSelecionados[1].name}',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (heroisSelecionados.length == 2)
                    ElevatedButton.icon(
                      onPressed: _abrirComparacao,
                      icon: const Icon(Icons.compare_arrows, size: 16),
                      label: const Text('Comparar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        textStyle: const TextStyle(fontWeight: FontWeight.w700),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                ],
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
                            itemCount: displayList.length +
                                (!_isSearching && _hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == displayList.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }

                              final hero = displayList[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: HeroCard(
                                  hero: hero,
                                  modoComparacao: modoComparacao,
                                  selecionado: heroisSelecionados.any((h) => h.id == hero.id),
                                  onToggleSelecao: () => _toggleSelecaoHeroi(hero),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}