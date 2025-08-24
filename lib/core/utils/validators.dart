class Validators {
  static String? required(String? v, {String name = 'Field'}) {
    if ((v ?? '').trim().isEmpty) return '$name is required';
    return null;
  }
}
