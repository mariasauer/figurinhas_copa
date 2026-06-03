import 'package:flutter/material.dart';
import '../models/figurinha.dart';
import '../utils/constantes.dart';

class FigurinhaCa extends StatelessWidget {
  final Figurinha figurinha;
  final String countryCode;
  final String numeroVisual;
  final int indexFigurinha;
  final double larguraCaixa;
  final VoidCallback onTap;

  const FigurinhaCa({
    super.key,
    required this.figurinha,
    required this.countryCode,
    required this.numeroVisual,
    required this.indexFigurinha,
    required this.larguraCaixa,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isShiny = figurinha.type.toLowerCase() == 'shiny';
    final bool isCoca = figurinha.type.toLowerCase() == 'coca';
    
    late Color corFundo;
    late Color corBorda;
    late Color corTexto;
    late Color corSubtexto;

    if (figurinha.colada) {
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
        corFundo = getCorDoPais(countryCode);
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
        onTap: onTap,
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
                      color: figurinha.colada ? Colors.white : Colors.amber[600]
                    ),
                    const SizedBox(width: 2),
                  ],
                  if (isCoca) ...[
                    Icon(
                      Icons.local_drink_rounded, 
                      size: 14, 
                      color: figurinha.colada ? Colors.white : Colors.red[600]
                    ),
                    const SizedBox(width: 2),
                  ],
                  Text(
                    '$countryCode $numeroVisual',
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
                  figurinha.name,
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
  }
}
