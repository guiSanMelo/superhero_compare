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
  bool _keyboardWasVisible = false;

  Timer? _debounce;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final RemoteService _service = RemoteService();

  @override
  void initState() {
    super.initState();
    _loadMore();

    _scrollController.addListener(() {
      if (!_scrollController.position.hasContentDimensions) return;

      final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
      if (keyboardVisible || _keyboardWasVisible) {
        _keyboardWasVisible = keyboardVisible;
        return;
      }

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
    _searchFocusNode.dispose();
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
      backgroundColor: const Color(0xFFF7F1E1),
      appBar: const CustomAppBar(title: "HeroCompare", showBackButton: false),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de busca + botão comparação
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 1.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 0,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                        hintText: "Buscar Herói...",
                        hintStyle: const TextStyle(color: Colors.black38),
                        suffixIcon: _isSearching
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.black54,
                                ),
                                onPressed: () => _searchController.clear(),
                              )
                            : const Icon(
                                Icons.search,
                                color: Colors.black54,
                              ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                GestureDetector(
                  onTap: () => _toggleModoComparacao(!modoComparacao),
                  child: Tooltip(
                    message: 'Modo comparação',
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: modoComparacao ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 0,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.compare_arrows,
                        color: modoComparacao ? Colors.white : Colors.black,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Toggle modo duelo
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                const Text(
                  'Modo Duelo',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: modoComparacao,
                  onChanged: _toggleModoComparacao,
                  activeColor: Colors.black,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),

          // Banner de seleção
          if (modoComparacao)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      heroisSelecionados.isEmpty
                          ? 'Selecione 2 heróis para comparar'
                          : heroisSelecionados.length == 1
                              ? 'Selecione mais 1 herói'
                              : '${heroisSelecionados[0].name} vs ${heroisSelecionados[1].name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (heroisSelecionados.length == 2)
                    GestureDetector(
                      onTap: _abrirComparacao,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Comparar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Título da lista
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              _isSearching ? 'Resultados' : 'Heróis Populares',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),

          // Lista
          Expanded(
            child: _isSearchLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : displayList.isEmpty && _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      )
                    : displayList.isEmpty && _isSearching
                        ? const Center(
                            child: Text(
                              'Nenhum herói encontrado',
                              style: TextStyle(color: Colors.black54),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: displayList.length +
                                (!_isSearching && _hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == displayList.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }

                              final hero = displayList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: HeroCard(
                                  hero: hero,
                                  modoComparacao: modoComparacao,
                                  selecionado: heroisSelecionados.any(
                                    (h) => h.id == hero.id,
                                  ),
                                  onToggleSelecao: () =>
                                      _toggleSelecaoHeroi(hero),
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