import 'package:shared_preferences/shared_preferences.dart';

class SettingController {
  static final SettingController _instance = SettingController._internal();
  static SettingController get intance => _instance;
  SettingController._internal();

  bool walletUiState = false;
  bool hasAccountBalance = false;
  double accountBalance = -1.0;

  Future<void> init() async {
    await loadWalletUiStatus();
    await loadAccountBalance();
  }

  Future<void> loadWalletUiStatus() async {
    var prefs = await SharedPreferences.getInstance();
    walletUiState = prefs.getBool('walletUiStatus') ?? walletUiState;
  }

  Future<void> saveWalletUiStatus(bool value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walletUiStatus', value);
  }

  Future<void> loadAccountBalance() async {
    var prefs = await SharedPreferences.getInstance();
    accountBalance = prefs.getDouble('accountBalance') ?? -1.0;
    if (accountBalance == -1.0) {
      hasAccountBalance = false;
    } else {
      hasAccountBalance = true;
    }
  }

  Future<void> saveAccountBalance(double value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('accountBalance', value);
  }
}
