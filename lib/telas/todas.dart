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

  @override
  void initState() {
    super.initState();
    _carregarFigurinhas();
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

//pegar a bandeira diretamente da internet
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

// pega uma cor para o país
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


  // Transforma a lista em grupos separados pelo 'code' (ex: BRA, ARG)
  Map<String, List<Figurinha>> get _figurinhasAgrupadas {
    Map<String, List<Figurinha>> mapa = {};
    for (var fig in _todasAsFigurinhas) {
      
      // Proteção contra textos curtos! 
      // Só faz o substring se o code tiver pelo menos 3 caracteres.
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

@override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_todasAsFigurinhas.isEmpty) {
      return const Center(child: Text('Nenhuma figurinha encontrada.'));
    }

    // Pega as siglas (chaves do mapa) para montar a lista principal
    final grupos = _figurinhasAgrupadas;
    final chavesDosGrupos = grupos.keys.toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        itemCount: chavesDosGrupos.length,
        itemBuilder: (context, index) {
          final code = chavesDosGrupos[index];
          final figurinhasDoPais = grupos[code]!;
          
          final coladasNoPais = figurinhasDoPais.where((f) => f.colada).length;
          final totalNoPais = figurinhasDoPais.length;

          // Busca a URL da bandeira uma única vez
          final urlBandeira = _getBandeiraUrl(code);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            clipBehavior: Clip.antiAlias, 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white, // A cor branca voltou para o Card
            
            child: ExpansionTile(
              // Retiramos as cores transparentes para voltar ao padrão normal
              shape: const Border(),
              collapsedShape: const Border(),
              // O título agora é uma linha (Row) contendo a bandeira e a sigla
              title: Row(
                children: [
                  // Se tivermos a URL da bandeira, desenhamos a imagem
                  if (urlBandeira != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2), // Borda levemente arredondada na bandeira
                      child: Image.network(
                        urlBandeira,
                        width: 28, // Largura da bandeira
                        height: 20, // Altura da bandeira
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12), // Um pequeno espaço entre a bandeira e a sigla
                  ],
                  // O texto da sigla (ex: BRA, ARG)
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
                      final larguraCaixa = (larguraTela - 16 - (8 * 3)) / 4; 
                      
                      String numeroVisual = (indexFigurinha + 1).toString().padLeft(2, '0');

                      bool isShiny = fig.type.toLowerCase() == 'shiny';
                      bool isCoca = fig.type.toLowerCase() == 'coca';
                      // --- VARIÁVEIS DE COR BLINDADAS ---
                      Color corFundo;
                      Color corBorda;
                      Color corTexto;
                      Color corSubtexto;

                      if (fig.colada) {
                        if (isShiny) {
                          // Se for Shiny Colada: Dourado de lei
                          corFundo = Colors.amber[500]!;
                          corBorda = Colors.amber[700]!;
                          corTexto = Colors.white;
                          corSubtexto = Colors.amber[50]!;
                        }else if (isCoca) {
                          // COCA-COLA COLADA: Vermelho Escuro Clássico
                          corFundo = const Color(0xFFB30000); // Vermelho Coca-Cola
                          corBorda = const Color(0xFF800000); // Borda vermelha ainda mais escura
                          corTexto = Colors.white;
                          corSubtexto = Colors.white70;
                        } else {
                          // SE FOR NORMAL COLADA: GANHA A COR DO PAÍS!
                          corFundo = _getCorDoPais(code);
                          corBorda = corFundo.withOpacity(0.8);
                          
                          // TRUQUE DE MESTRE: Descobre se a cor do país é clara ou escura 
                          // para decidir se o texto vai ser branco ou preto (evita sumir o texto)
                          bool isEscura = ThemeData.estimateBrightnessForColor(corFundo) == Brightness.dark;
                          corTexto = isEscura ? Colors.white : Colors.black87;
                          corSubtexto = isEscura ? Colors.white70 : Colors.black54;
                        }
                      } else {
                       if (isShiny) {
                          // Faltante Shiny
                          corFundo = Colors.amber[50]!;
                          corBorda = Colors.amber[400]!;
                          corTexto = Colors.black87;
                          corSubtexto = Colors.grey[700]!;
                        } else if (isCoca) {
                          // Faltante Coca-Cola: Cinza mais escuro com borda vermelha
                          corFundo = Colors.grey[400]!; 
                          corBorda = Colors.red[500]!; 
                          corTexto = Colors.black87;
                          corSubtexto = Colors.grey[800]!;
                        } else {
                          // Faltante Normal: Cinza padrão
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
                                        Icons.local_drink_rounded, // Ícone de bebida para a Coca!
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: corSubtexto,
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
    );
  }
}