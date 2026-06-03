import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class Estatistica extends StatefulWidget {
  const Estatistica({super.key});

  @override
  State<Estatistica> createState() => _EstatisticaState();
}

class _EstatisticaState extends State<Estatistica> {
  Map<String, int> _resumo = {};
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final dados = await DatabaseHelper.instance.obterResumoColecao();
    setState(() {
      _resumo = dados;
      _carregando = false;
    });
  }

  Widget _buildPilula(String texto, IconData icone, Color corTexto, Color corFundo) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 16, color: corTexto),
          const SizedBox(width: 6),
          Text(
            texto,
            style: TextStyle(
              color: corTexto,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    int total = _resumo['total'] ?? 0;
    int coladas = _resumo['coladas'] ?? 0;
    int faltantes = total - coladas; 

    int totalShiny = _resumo['totalShiny'] ?? 0;
    int shinyColadas = _resumo['shinyColadas'] ?? 0;
    int shinyFaltantes = totalShiny - shinyColadas; 

    int totalCoca = _resumo['totalCoca'] ?? 0;
    int cocaColadas = _resumo['cocaColadas'] ?? 0;
    int cocaFaltantes = totalCoca - cocaColadas; 

    double progressoGeralBruto = total > 0 ? coladas / total : 0;
    double progressoShinyBruto = totalShiny > 0 ? shinyColadas / totalShiny : 0;
    double progressoCocaBruto = totalCoca > 0 ? cocaColadas / totalCoca : 0;

    int porcentagemGeralInt = (progressoGeralBruto * 100).toInt();
    int porcentagemShinyInt = (progressoShinyBruto * 100).toInt();
    int porcentagemCocaInt = (progressoCocaBruto * 100).toInt();

    String txtProgressoGeral = coladas > 0 && porcentagemGeralInt == 0 ? '< 1%' : '$porcentagemGeralInt%';
    String txtProgressoShiny = shinyColadas > 0 && porcentagemShinyInt == 0 ? '< 1%' : '$porcentagemShinyInt%';
    String txtProgressoCoca = cocaColadas > 0 && porcentagemCocaInt == 0 ? '< 1%' : '$porcentagemCocaInt%';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _carregarDados,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Meu Progresso',
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),

            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: Colors.grey[200]!, width: 2), 
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: porcentagemGeralInt == 0 ? 0.0 : progressoGeralBruto,
                            strokeWidth: 14,
                            backgroundColor: Colors.blue[50],
                            color: coladas == 0 ? Colors.transparent : Colors.blue[600],
                            strokeCap: StrokeCap.round, 
                          ),
                          Center(
                            child: Text(
                              txtProgressoGeral,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.style_rounded, color: Colors.blue[800], size: 20),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text('Todas as Figurinhas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            children: [
                              _buildPilula('Coladas: $coladas', Icons.check_circle_rounded, Colors.green[800]!, Colors.green[100]!),
                              _buildPilula('Faltam: $faltantes', Icons.remove_circle_outline_rounded, Colors.red[800]!, Colors.red[100]!),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: Colors.grey[200]!, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: porcentagemShinyInt == 0 ? 0.0 : progressoShinyBruto,
                            strokeWidth: 14,
                            backgroundColor: Colors.amber[50],
                            color: shinyColadas == 0 ? Colors.transparent : Colors.amber[500],
                            strokeCap: StrokeCap.round,
                          ),
                          Center(
                            child: Text(
                              txtProgressoShiny,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.auto_awesome_rounded, color: Colors.amber[600], size: 20),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text('Figurinhas Shiny', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            children: [
                              _buildPilula('Coladas: $shinyColadas', Icons.check_circle_rounded, Colors.green[800]!, Colors.green[100]!),
                              _buildPilula('Faltam: $shinyFaltantes', Icons.remove_circle_outline_rounded, Colors.red[800]!, Colors.red[100]!),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (totalCoca > 0)
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Colors.grey[200]!, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: porcentagemCocaInt == 0 ? 0.0 : progressoCocaBruto,
                              strokeWidth: 14,
                              backgroundColor: Colors.red[50],
                              color: cocaColadas == 0 ? Colors.transparent : const Color(0xFFB30000), // Vermelho da Coca
                              strokeCap: StrokeCap.round,
                            ),
                            Center(
                              child: Text(
                                txtProgressoCoca,
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.local_drink_rounded, color: const Color(0xFFB30000), size: 20),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text('Coca-Cola', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              children: [
                                _buildPilula('Coladas: $cocaColadas', Icons.check_circle_rounded, Colors.green[800]!, Colors.green[100]!),
                                _buildPilula('Faltam: $cocaFaltantes', Icons.remove_circle_outline_rounded, Colors.red[800]!, Colors.red[100]!),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}