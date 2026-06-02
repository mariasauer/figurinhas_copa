class Figurinha {
  final int? id;
  final String code;
  final String name; 
  final String type;
  final bool colada;

  Figurinha({
    this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.colada,
  });

//salvando no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name, 
      'type': type,
      'colada': colada ? 1 : 0, 
    };
  }

//criando a figurinha a partir do banco de dados
  factory Figurinha.fromMap(Map<String, dynamic> map) {
    return Figurinha(
      id: map['id'],
      code: map['code'].toString(),
      name: map['name'] ?? '', 
      type: map['type'],
      colada: map['colada'] == 1,
    );
  }
}