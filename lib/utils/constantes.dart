import 'package:flutter/material.dart';

/// Mapa com as cores representativas de cada país
const Map<String, Color> coresDosPaises = {
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

/// Retorna a cor do país baseado no código
Color getCorDoPais(String code) {
  return coresDosPaises[code.toUpperCase()] ?? const Color(0xFF1E3A8A);
}

/// Mapa com a correspondência entre códigos de país e ISO codes para bandeiras
const Map<String, String> mapaDeBandeiras = {
  'BRA': 'br', 'ARG': 'ar', 'URU': 'uy', 'COL': 'co', 'CHI': 'cl',
  'PER': 'pe', 'ECU': 'ec', 'PAR': 'py', 'VEN': 've', 'BOL': 'bo',
  'GER': 'de', 'FRA': 'fr', 'ESP': 'es', 'ENG': 'gb-eng', 'POR': 'pt',
  'ITA': 'it', 'NED': 'nl', 'BEL': 'be', 'CRO': 'hr', 'SUI': 'ch',
  'SRB': 'rs', 'DEN': 'dk', 'SWE': 'se', 'POL': 'pl', 'WAL': 'gb-wls',
  'SCO': 'gb-sct', 'IRL': 'ie', 'TUR': 'tr', 'GRE': 'gr', 'CZE': 'cz',
  'AUT': 'at', 'HUN': 'hu', 'ROU': 'ro', 'UKR': 'ua', 'ISL': 'is',
  'NOR': 'no', 'FIN': 'fi', 'BIH': 'ba', 'SVK': 'sk', 'SVN': 'si',
  'USA': 'us', 'MEX': 'mx', 'CAN': 'ca', 'CRC': 'cr', 'CUW': 'cw', 'PAN': 'pa',
  'HON': 'hn', 'SLV': 'sv', 'JAM': 'jm', 'TRI': 'tt', 'HAI': 'ht',
  'SEN': 'sn', 'CMR': 'cm', 'GHA': 'gh', 'MAR': 'ma', 'TUN': 'tn',
  'NGA': 'ng', 'EGY': 'eg', 'ALG': 'dz', 'CIV': 'ci', 'RSA': 'za',
  'MLI': 'ml', 'BFA': 'bf', 'COD': 'cd', 'CPV': 'cv',
  'JPN': 'jp', 'KOR': 'kr', 'AUS': 'au', 'KSA': 'sa', 'IRN': 'ir',
  'QAT': 'qa', 'UAE': 'ae', 'CHN': 'cn', 'NZL': 'nz', 'IRQ': 'iq',
  'OMA': 'om', 'SYR': 'sy', 'UZB': 'uz', 'IND': 'in', 'KAZ': 'kz', 'JOR': 'jo'
};

/// Retorna a URL da bandeira baseado no código do país
String? getBandeiraUrl(String code) {
  String? isoCode = mapaDeBandeiras[code.toUpperCase()];
  if (isoCode != null) {
    return 'https://flagcdn.com/w320/$isoCode.png';
  }
  return null; 
}

/// Calcula o número visual a ser exibido no card da figurinha
String calcularNumeroVisual(String code, int indexFigurinha) {
  String numeroVisual = code.replaceAll(RegExp(r'[A-Za-z]'), '').padLeft(2, '0');
  if (numeroVisual.isEmpty) {
    numeroVisual = code == 'FWC' 
        ? indexFigurinha.toString().padLeft(2, '0') 
        : (indexFigurinha + 1).toString().padLeft(2, '0');
  } else {
    numeroVisual = numeroVisual.padLeft(2, '0');
  }
  return numeroVisual;
}
