class Validators {
  static bool validString(String value) =>
      value != null && value.trim().isNotEmpty;

  static bool validNumber(String value) {
    if (!validString(value)) return false;
    RegExp regex = new RegExp(r"^[0-9]*$");
    return regex.hasMatch(value);
  }

  static bool validEmail(String value) {
    if (!validString(value)) return false;
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(value);
  }
}