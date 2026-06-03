import 'package:flutter_test/flutter_test.dart';
import 'package:figurinhas_copa/models/figurinha.dart';

void main() {
  group('Testes do Modelo de Figurinha', () {
    
    test('Deve criar uma figurinha faltante corretamente', () {
      // Criamos uma figurinha de teste
      final figurinhaTeste = Figurinha(
        id: 1,
        code: 'BRA',
        name: 'Neymar Jr',
        type: 'normal',
        colada: false,
      );

      // Verificamos se os dados batem com a realidade
      expect(figurinhaTeste.code, 'BRA');
      expect(figurinhaTeste.colada, false);
      expect(figurinhaTeste.type, 'normal');
    });

    test('Deve transformar a figurinha em um Mapa para o Banco de Dados', () {
      final figurinhaTeste = Figurinha(
        id: 2,
        code: 'ARG',
        name: 'Lionel Messi',
        type: 'shiny',
        colada: true,
      );

      final mapa = figurinhaTeste.toMap();

      expect(mapa['code'], 'ARG');
      expect(mapa['colada'], 1); 
      expect(mapa['type'], 'shiny');
    });
  });
}