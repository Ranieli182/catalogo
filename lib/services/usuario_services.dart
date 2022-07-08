import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart';
import '../schemas/usuario.dart';

class UsuarioService {
  final Configuration _config =
  Configuration([Usuario.schema], readOnly: false, inMemory: false);
  Realm? _realm;
  UsuarioService() {
    openRealm();
  }
  openRealm() {
    _realm = Realm(_config);
  }
  closeRealm() {
    if (!_realm!.isClosed) {
      _realm!.close();
    }
  }
  RealmResults<Usuario> getUsuarios() {
    return _realm!.all<Usuario>();
  }

  RealmResults<Usuario> getUsuario(String user) {
    return _realm!.all<Usuario>().query("user == '"+ user+ "'");
  }


  bool addUsuario(String user, String senha) {
    try {
      _realm!.write(() {
        _realm!.add<Usuario>(Usuario(user, senha));
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  bool deleteUsuario(Usuario usuario) {
    try {
      _realm!.write(() {
        _realm!.delete(usuario);
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }
}