class Validators {
  Validators._();

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter username';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter password';
    }

    return null;
  }

  static String? department(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a department';
    }

    return null;
  }
}