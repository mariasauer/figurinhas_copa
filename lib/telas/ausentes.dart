import 'package:flutter/material.dart';
import '../models/figurinha.dart';
import '../services/database_helper.dart';

class Ausentes extends StatefulWidget {
  const Ausentes({super.key});

  @override
  State<Ausentes> createState() => _AusentesState();
}

class _AusentesState extends State<Ausentes> {
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

  // Quando você clicar na figurinha aqui, ela será marcada como colada
  // e vai sumir desta lista automaticamente!
  Future<void> _alternarStatusColada(Figurinha figurinha) async {
    final figurinhaAtualizada = Figurinha(
      id: figurinha.id,
      code: figurinha.code,
      name: figurinha.name,
      type: figurinha.type,
      colada: true, // Força a ser true, pois se está aqui é porque faltava
    );

    await DatabaseHelper.instance.atualizar(figurinhaAtualizada);
    _carregarFigurinhas();
  }

  String? _getBandeiraUrl(String code) {
    final mapaDeBandeiras = {
      'BRA': 'br', 'ARG': 'ar', 'URU': 'uy', 'COL': 'co', 'CHI': 'cl', 
      'PER': 'pe', 'ECU': 'ec', 'PAR': 'py', 'VEN': 've', 'BOL': 'bo',
      'GER': 'de', 'FRA': 'fr', 'ESP': 'es', 'ENG': 'gb-eng', 'POR': 'pt',
      'ITA': 'it', 'NED': 'nl', 'BEL': 'be', 'CRO': 'hr', 'SUI': 'ch',
      'SRB': 'rs', 'DEN': 'dk', 'SWE': 'se', 'POL': 'pl', 'WAL': 'gb-wls',
      'SCO': 'gb-sct', 'IRL': 'ie', 'TUR': 'tr', 'GRE': 'gr', 'CZE': 'cz',
      'AUT': 'at', 'HUN': 'hu', 'ROU': 'ro', 'UKR': 'ua', 'ISL': 'is',
      'NOR': 'no', 'FIN': 'fi', 'BIH': 'ba', 'SVK': 'sk', 'SVN': 'si',
      'USA': 'us', 'MEX': 'mx', 'CAN': 'ca', 'CRC': 'cr', 'PAN': 'pa',
      'HON': 'hn', 'SLV': 'sv', 'JAM': 'jm', 'TRI': 'tt', 'HAI': 'ht',
      'SEN': 'sn', 'CMR': 'cm', 'GHA': 'gh', 'MAR': 'ma', 'TUN': 'tn',
      'NGA': 'ng', 'EGY': 'eg', 'ALG': 'dz', 'CIV': 'ci', 'RSA': 'za',
      'MLI': 'ml', 'BFA': 'bf', 'COD': 'cd',
      'JPN': 'jp', 'KOR': 'kr', 'AUS': 'au', 'KSA': 'sa', 'IRN': 'ir',
      'QAT': 'qa', 'UAE': 'ae', 'CHN': 'cn', 'NZL': 'nz', 'IRQ': 'iq',
      'OMA': 'om', 'SYR': 'sy', 'UZB': 'uz', 'IND': 'in', 'KAZ': 'kz'
    };

    String? isoCode = mapaDeBandeiras[code.toUpperCase()];
    if (isoCode != null) {
      return 'https://flagcdn.com/w320/$isoCode.png';
    }
    return null; 
  }

  Map<String, List<Figurinha>> get _figurinhasAgrupadas {
    Map<String, List<Figurinha>> mapa = {};
    for (var fig in _todasAsFigurinhas) {
      String chaveDoGrupo = fig.code.length >= 3 ? fig.code.substring(0, 3) : fig.code;
      if (chaveDoGrupo == '0' || chaveDoGrupo == '00') chaveDoGrupo = 'FWC';

      if (!mapa.containsKey(chaveDoGrupo)) mapa[chaveDoGrupo] = [];
      mapa[chaveDoGrupo]!.add(fig);
    }
    return mapa;
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) return const Center(child: CircularProgressIndicator());

    final grupos = _figurinhasAgrupadas;
    final chavesDosGrupos = grupos.keys.toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: chavesDosGrupos.length,
        itemBuilder: (context, index) {
          final code = chavesDosGrupos[index];
          final figurinhasDoPais = grupos[code]!;
          
          // O GRANDE TRUQUE: Pegamos a lista com os índices originais, mas filtramos só as que NÃO estão coladas
          final faltantes = figurinhasDoPais.asMap().entries.where((entry) => !entry.value.colada).toList();

          // Se você já colou todas desse país, a lista de faltantes fica vazia, então nós nem desenhamos o país na tela!
          if (faltantes.isEmpty) {
            return const SizedBox.shrink(); 
          }

          final urlBandeira = _getBandeiraUrl(code);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TÍTULO FIXO (SEM SANFONA)
                  Row(
                    children: [
                      if (urlBandeira != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Image.network(urlBandeira, width: 28, height: 20, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Text(code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const Spacer(),
                      Text(
                        'Faltam ${faltantes.length}',
                        style: TextStyle(color: Colors.red[400], fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // OS QUADRADINHOS
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: faltantes.map((entry) {
                      final int indexFigurinha = entry.key; // O índice original mantém o número correto!
                      final Figurinha fig = entry.value;

                      final larguraTela = MediaQuery.of(context).size.width;
                      // Desconta paddings do cartão e margens (um pouco diferente da tela anterior)
                      final larguraCaixa = (larguraTela - 32 - 32 - (8 * 3)) / 4; 
                      
                      String numeroVisual = (indexFigurinha + 1).toString().padLeft(2, '0');
                      bool isShiny = fig.type.toLowerCase() == 'shiny';

                      return SizedBox(
                        width: larguraCaixa,
                        height: larguraCaixa / 0.75,
                        child: GestureDetector(
                          onTap: () => _alternarStatusColada(fig),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isShiny ? Colors.amber[50] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isShiny ? Colors.amber[400]! : Colors.grey[300]!,
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
                                      Icon(Icons.star_rounded, size: 14, color: Colors.amber[600]),
                                      const SizedBox(width: 2),
                                    ],
                                    Text(
                                      '$code $numeroVisual',
                                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black87),
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
                                    style: TextStyle(fontSize: 8, color: Colors.grey[700]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}