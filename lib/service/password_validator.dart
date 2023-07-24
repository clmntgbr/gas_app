class PasswordValidator {
  static bool validate(String password) {
    if (password.isEmpty || password.length >= 255) {
      return false;
    }
    return true;
  }
}
