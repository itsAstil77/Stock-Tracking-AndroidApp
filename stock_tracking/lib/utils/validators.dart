class Validators {
  static bool validateLogin(String username, String password) {
    return username.isNotEmpty && password.isNotEmpty;
  }
}
