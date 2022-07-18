import 'package:shared_preferences/shared_preferences.dart';

class SettingController {
  static final SettingController _instance = SettingController._internal();
  static SettingController get intance => _instance;
  SettingController._internal();

  bool walletUiState = false;
  bool hasAccountBalance = false;
  double accountBalance = 0.0;

  Future<void> init() async {
    await loadWalletUiStatus();
  }

  Future<void> loadWalletUiStatus() async {
    var prefs = await SharedPreferences.getInstance();
    walletUiState = prefs.getBool('walletUiStatus') ?? walletUiState;
  }

  Future<void> saveWalletUiStatus(bool value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walletUiStatus', value);
  }
}
