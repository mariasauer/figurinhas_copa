import 'package:flutter/material.dart';
import '../models/figurinha.dart';
import '../services/database_helper.dart';
import '../components/figurinha_card.dart';
import '../utils/constantes.dart';

class Todas extends StatefulWidget {
  const Todas({super.key});

  @override
  State<Todas> createState() => _TodasState();
}

class _TodasState extends State<Todas> {
  List<Figurinha> _todasAsFigurinhas = [];
  bool _carregando = true;
  
  String _termoBusca = '';
  String _filtroBusca = 'Ambos'; 
  final TextEditingController _buscaController = TextEditingController();
  final FocusNode _buscaFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _carregarFigurinhas();
    //redesenha a tela quando clico na busca
    _buscaFocusNode.addListener(() {
      setState(() {});
    });
  }

  Future<void> _carregarFigurinhas() async {
    final lista = await DatabaseHelper.instance.listarTodas();
    setState(() {
      _todasAsFigurinhas = lista;
      _carregando = false;
    });
  }

  Future<void> _alternarStatusColada(Figurinha figurinha) async {
    final figurinhaAtualizada = Figurinha(
      id: figurinha.id,
      code: figurinha.code,
      name: figurinha.name,
      type: figurinha.type,
      colada: !figurinha.colada,
    );

    await DatabaseHelper.instance.atualizar(figurinhaAtualizada);
    _carregarFigurinhas();
  }

  List<Figurinha> get _figurinhasFiltradas {
    if (_termoBusca.isEmpty) {
      return _todasAsFigurinhas;
    }
    
    final termo = _termoBusca.toLowerCase();
    
    return _todasAsFigurinhas.where((fig) {
      final nomeBate = fig.name.toLowerCase().contains(termo);
      final codigoBate = fig.code.toLowerCase().contains(termo);
      
      if (_filtroBusca == 'Time') {
        return codigoBate;
      } else if (_filtroBusca == 'Jogador') {
        return nomeBate;
      } else {
        return nomeBate || codigoBate; 
      }
    }).toList();
  }

  Map<String, List<Figurinha>> get _figurinhasAgrupadas {
    Map<String, List<Figurinha>> mapa = {};
    for (var fig in _figurinhasFiltradas) {
      String chaveDoGrupo = fig.code.length >= 3 
          ? fig.code.substring(0, 3) 
          : fig.code;

      if (chaveDoGrupo == '0' || chaveDoGrupo == '00') {
        chaveDoGrupo = 'FWC';
      }

      if (!mapa.containsKey(chaveDoGrupo)) {
        mapa[chaveDoGrupo] = [];
      }
      mapa[chaveDoGrupo]!.add(fig);
    }
    return mapa;
  }

  // Maps e funções de cores/bandeiras foram movidos para constantes.dart

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_todasAsFigurinhas.isEmpty) {
      return const Center(child: Text('Nenhuma figurinha encontrada.'));
    }

    final grupos = _figurinhasAgrupadas;
    final chavesDosGrupos = grupos.keys.toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 8),
            child: TextField(
              controller: _buscaController,
              focusNode: _buscaFocusNode,
              decoration: InputDecoration(
                hintText: 'Buscar jogador ou código...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _termoBusca.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _buscaController.clear();
                        setState(() {
                          _termoBusca = '';
                        });
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : null,
              ),
              onChanged: (valor) {
                setState(() {
                  _termoBusca = valor;
                });
              },
            ),
          ),
          
          // Botões de filtro entre jogador e time
          // Só desenha os botões se estiver pesquisando
          if (_buscaFocusNode.hasFocus || _termoBusca.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Ambos'),
                    selected: _filtroBusca == 'Ambos',
                    showCheckmark: false,
                    onSelected: (bool selecionado) {
                      if (selecionado) setState(() => _filtroBusca = 'Ambos');
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Time'),
                    selected: _filtroBusca == 'Time',
                    showCheckmark: false,
                    onSelected: (bool selecionado) {
                      if (selecionado) setState(() => _filtroBusca = 'Time');
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Jogador'),
                    selected: _filtroBusca == 'Jogador',
                    showCheckmark: false,
                    onSelected: (bool selecionado) {
                      if (selecionado) setState(() => _filtroBusca = 'Jogador');
                    },
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),

          if (chavesDosGrupos.isEmpty)
            const Expanded(
              child: Center(
                child: Text('Nenhum resultado encontrado.'),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: chavesDosGrupos.length,
                itemBuilder: (context, index) {
                  final code = chavesDosGrupos[index];
                  final figurinhasDoPais = grupos[code]!;
                  
                  final coladasNoPais = figurinhasDoPais.where((f) => f.colada).length;
                  final totalNoPais = figurinhasDoPais.length;

                  final urlBandeira = getBandeiraUrl(code);

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    clipBehavior: Clip.antiAlias, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.white, 
                    child: ExpansionTile(
                      key: Key('${code}_${_termoBusca.isNotEmpty}'),
                      shape: const Border(),
                      collapsedShape: const Border(),
                      initiallyExpanded: _termoBusca.isNotEmpty, 
                      title: Row(
                        children: [
                          if (urlBandeira != null) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Image.network(
                                urlBandeira,
                                width: 28, 
                                height: 20, 
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12), 
                          ],
                          Text(
                            code,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          if (coladasNoPais == totalNoPais && totalNoPais > 0) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green,
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        '$coladasNoPais / $totalNoPais coladas',
                        style: TextStyle(
                          color: coladasNoPais == totalNoPais ? Colors.green[700] : Colors.grey[600],
                          fontWeight: coladasNoPais == totalNoPais ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: figurinhasDoPais.asMap().entries.map((entry) {
                              final int indexFigurinha = entry.key;
                              final Figurinha fig = entry.value;

                              final larguraTela = MediaQuery.of(context).size.width;
                              final larguraCaixa = (larguraTela - 24 - (8 * 3)) / 4; 
                              
                              final numeroVisual = calcularNumeroVisual(code, indexFigurinha);

                              return FigurinhaCa(
                                figurinha: fig,
                                countryCode: code,
                                numeroVisual: numeroVisual,
                                indexFigurinha: indexFigurinha,
                                larguraCaixa: larguraCaixa,
                                onTap: () => _alternarStatusColada(fig),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
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