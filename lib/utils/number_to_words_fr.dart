class NumberToWordsFR {
  static String convert(int number) {
    if (number == 0) return "zéro";
    return _convertRecursive(number).trim();
  }

  static String _convertRecursive(int n) {
    if (n >= 1000000) {
      return '${_convertRecursive(n ~/ 1000000)} million${n % 1000000 != 0 ? ' ' : ''}${_convertRecursive(n % 1000000)}';
    } else if (n >= 1000) {
      return '${_convertRecursive(n ~/ 1000)} mille${n % 1000 != 0 ? ' ' : ''}${_convertRecursive(n % 1000)}';
    } else if (n >= 100) {
      return '${_convertBelow1000(n ~/ 100)} cent${n % 100 != 0 ? ' ' : ''}${_convertRecursive(n % 100)}';
    } else {
      return _convertBelow100(n);
    }
  }

  static String _convertBelow1000(int n) {
    if (n == 1) return '';
    return _convertBelow100(n);
  }

  static String _convertBelow100(int n) {
    const units = [
      '', 'un', 'deux', 'trois', 'quatre', 'cinq', 'six', 'sept', 'huit', 'neuf',
      'dix', 'onze', 'douze', 'treize', 'quatorze', 'quinze', 'seize', 'dix-sept',
      'dix-huit', 'dix-neuf'
    ];
    const tens = [
      '', 'dix', 'vingt', 'trente', 'quarante', 'cinquante', 'soixante',
      'soixante', 'quatre-vingt', 'quatre-vingt'
    ];

    if (n < 20) return units[n];
    if (n == 80) return 'quatre-vingts'; // Cas spécial

    int t = n ~/ 10;
    int u = n % 10;

    String result = tens[t];
    if (t == 7 || t == 9) { // Gestion de 70-79 et 90-99
      result = tens[t];
      t = (t == 7) ? 6 : 8; // "soixante-dix" ou "quatre-vingt-dix"
      u += 10;
      result = '$result-${units[u]}';
    } else if (u == 1 && t != 8) {
      result = '$result et un';
    } else if (u != 0) {
      result = '$result-${units[u]}';
    }

    return result;
  }
}