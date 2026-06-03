import 'package:flutter/material.dart';
import '../models/figurinha.dart';
import '../services/database_helper.dart';

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

  String? _getBandeiraUrl(String code) {
    final mapaDeBandeiras = {
      'BRA': 'br', 'ARG': 'ar', 'URU': 'uy', 'COL': 'co',  
      'ECU': 'ec', 'PAR': 'py', 'VEN': 've', 'BOL': 'bo',
      'GER': 'de', 'FRA': 'fr', 'ESP': 'es', 'ENG': 'gb-eng', 'POR': 'pt',
      'NED': 'nl', 'BEL': 'be', 'CRO': 'hr', 'SUI': 'ch',
      'SRB': 'rs', 'DEN': 'dk', 'SWE': 'se', 'POL': 'pl', 'WAL': 'gb-wls',
      'SCO': 'gb-sct', 'IRL': 'ie', 'TUR': 'tr', 'GRE': 'gr', 'CZE': 'cz',
      'AUT': 'at', 'HUN': 'hu', 'UKR': 'ua',
      'NOR': 'no', 'BIH': 'ba', 'SVK': 'sk', 'SVN': 'si',
      'USA': 'us', 'MEX': 'mx', 'CAN': 'ca', 'CUW': 'cw', 'PAN': 'pa',
      'HON': 'hn', 'SLV': 'sv', 'JAM': 'jm', 'TRI': 'tt', 'HAI': 'ht',
      'SEN': 'sn', 'CMR': 'cm', 'GHA': 'gh', 'MAR': 'ma', 'TUN': 'tn',
      'CPV': 'cv', 'EGY': 'eg', 'ALG': 'dz', 'CIV': 'ci', 'RSA': 'za',
      'MLI': 'ml', 'BFA': 'bf', 'COD': 'cd',
      'JPN': 'jp', 'KOR': 'kr', 'AUS': 'au', 'KSA': 'sa', 'IRN': 'ir',
      'QAT': 'qa', 'UAE': 'ae', 'JOR': 'jo', 'NZL': 'nz', 'IRQ': 'iq',
      'OMA': 'om', 'SYR': 'sy', 'UZB': 'uz'
    };

    String? isoCode = mapaDeBandeiras[code.toUpperCase()];
    if (isoCode != null) {
      return 'https://flagcdn.com/w320/$isoCode.png';
    }
    return null; 
  }

  static const Map<String, Color> _coresDosPaises = {
    'BRA': Color(0xFFFFF93C), 'ARG': Color(0xFF74ACDF), 'URU': Color(0xFF87D3F8),
    'COL': Color(0xFFFCD116), 'EGY': Color(0xFF95174A), 'NOR': Color(0xFF860C0C),
    'ECU': Color(0xFFFFDD00), 'PAR': Color(0xFFD52B1E), 'IRQ': Color(0xFF2E1319),
    'TUR': Color(0xFFA71313), 'GER': Color(0xFF111111), 'FRA': Color(0xFF002395),
    'ESP': Color(0xFFC60B1E), 'POR': Color(0xFFB60A2A), 'ENG': Color(0xFFCE1124),
    'CUW': Color(0xFF004B87), 'NED': Color(0xFFFF4F00), 'BEL': Color(0xFFB70612),
    'CRO': Color(0xFFED1C24), 'SUI': Color(0xFFD52B1E), 'ALG': Color(0xFF4BD894),
    'CIV': Color(0xFFF27A09), 'CZE': Color(0xFF11457E), 'USA': Color(0xFF002868),
    'MEX': Color(0xFF006847), 'CAN': Color(0xFFDA291C), 'SCO': Color(0xFF054CA3),
    'SEN': Color(0xFF00A35B), 'NZL': Color(0xFF171515), 'GHA': Color(0xFFDA121A),
    'MAR': Color(0xFFC1272D), 'TUN': Color(0xFFE41B13), 'AUT': Color(0xFFAC0101),
    'RSA': Color(0xFFE9E509), 'JPN': Color(0xFF003399), 'KOR': Color(0xFFCD113B),
    'AUS': Color(0xFF002B7F), 'KSA': Color(0xFF006C35), 'IRN': Color(0xFF144722),
    'QAT': Color(0xFF8A1538), 'FWC': Color(0xFF4A0E17), 'JOR': Color(0xFF0C0505),
    'COD': Color(0xFF0093F6), 'UZB': Color(0xFF57B9FF),
  };

  Color _getCorDoPais(String code) {
    return _coresDosPaises[code.toUpperCase()] ?? const Color(0xFF1E3A8A);
  }

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

                  final urlBandeira = _getBandeiraUrl(code);

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
                              
                              String numeroVisual = fig.code.replaceAll(RegExp(r'[A-Za-z]'), '').padLeft(2, '0');
                              if (numeroVisual.isEmpty) {
                                numeroVisual = (indexFigurinha + 1).toString().padLeft(2, '0');
                              }

                              bool isShiny = fig.type.toLowerCase() == 'shiny';
                              bool isCoca = fig.type.toLowerCase() == 'coca';
                              Color corFundo;
                              Color corBorda;
                              Color corTexto;
                              Color corSubtexto;

                              if (fig.colada) {
                                if (isShiny) {
                                  corFundo = Colors.amber[500]!;
                                  corBorda = Colors.amber[700]!;
                                  corTexto = Colors.white;
                                  corSubtexto = Colors.amber[50]!;
                                } else if (isCoca) {
                                  corFundo = const Color(0xFFB30000); 
                                  corBorda = const Color(0xFF800000); 
                                  corTexto = Colors.white;
                                  corSubtexto = Colors.white70;
                                } else {
                                  corFundo = _getCorDoPais(code);
                                  corBorda = corFundo.withOpacity(0.8);
                                  
                                  bool isEscura = ThemeData.estimateBrightnessForColor(corFundo) == Brightness.dark;
                                  corTexto = isEscura ? Colors.white : Colors.black87;
                                  corSubtexto = isEscura ? Colors.white70 : Colors.black54;
                                }
                              } else {
                                if (isShiny) {
                                  corFundo = Colors.amber[50]!;
                                  corBorda = Colors.amber[400]!;
                                  corTexto = Colors.black87;
                                  corSubtexto = Colors.grey[700]!;
                                } else if (isCoca) {
                                  corFundo = Colors.grey[400]!; 
                                  corBorda = Colors.red[500]!; 
                                  corTexto = Colors.black87;
                                  corSubtexto = Colors.grey[800]!;
                                } else {
                                  corFundo = Colors.grey[300]!;
                                  corBorda = Colors.grey[400]!;
                                  corTexto = Colors.black87;
                                  corSubtexto = Colors.grey[700]!;
                                }
                              }

                              return SizedBox(
                                width: larguraCaixa,
                                height: larguraCaixa / 0.95,
                                child: GestureDetector(
                                  onTap: () => _alternarStatusColada(fig),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: corFundo,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: corBorda,
                                        width: isShiny ? 2 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (isShiny) ...[
                                              Icon(
                                                Icons.star_rounded, 
                                                size: 14, 
                                                color: fig.colada ? Colors.white : Colors.amber[600]
                                              ),
                                              const SizedBox(width: 2),
                                            ],
                                            if (isCoca) ...[
                                              Icon(
                                                Icons.local_drink_rounded, 
                                                size: 14, 
                                                color: fig.colada ? Colors.white : Colors.red[600]
                                              ),
                                              const SizedBox(width: 2),
                                            ],
                                            Text(
                                              '$code $numeroVisual',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 14,
                                                color: corTexto,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                          child: Text(
                                            fig.name,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: corSubtexto,
                                              height: 1.1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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