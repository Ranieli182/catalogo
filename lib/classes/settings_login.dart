import 'package:catalogo/classes/shared_preferences_settings.dart';

class SettingsLogin{
  SharedPreferencesSettings sharedPreferencesSettings = SharedPreferencesSettings();

  String _usuario;
  String _senha;
  bool _checkSalvarLogin;
  bool _checkOffline;

 SettingsLogin();

  String get usuario => _usuario;
  set usuario(String value) {
    _usuario = value;
  }

  String get senha => _senha;
  set senha(String value){
    _senha = value;
  }

  bool get checkSalvarLogin => _checkSalvarLogin;
  set checkSalvarLogin(bool value) {
    _checkSalvarLogin = value;
  }

  bool get checkOffline => _checkOffline;
  set checkOffline(bool value) {
    _checkOffline = value;
  }


  Future<void> SalvarSettingsLogin() async {
    await sharedPreferencesSettings.getInstance();

    sharedPreferencesSettings.preferences.setBool('_isCheckedSalvarLogin', _checkSalvarLogin);

    sharedPreferencesSettings.preferences.setBool('_isCheckedOffline', _checkOffline);

    sharedPreferencesSettings.preferences.setString('_userController', _usuario);

    sharedPreferencesSettings.preferences.setString('_senhaController', _senha);

  }

  Future<void> BuscarSettingsLogin() async {
    await sharedPreferencesSettings.getInstance();

    if (sharedPreferencesSettings.preferences.containsKey('_userController'))
      _usuario = sharedPreferencesSettings.preferences.getString('_userController');

    if (sharedPreferencesSettings.preferences.containsKey('_senhaController'))
      _senha = sharedPreferencesSettings.preferences.getString('_senhaController');

    if (sharedPreferencesSettings.preferences.containsKey('_isCheckedSalvarLogin'))
      _checkSalvarLogin = sharedPreferencesSettings.preferences.getBool('_isCheckedSalvarLogin');

    if (sharedPreferencesSettings.preferences.containsKey('_isCheckedOffline'))
      _checkOffline = sharedPreferencesSettings.preferences.getBool('_isCheckedOffline');

  }

}
