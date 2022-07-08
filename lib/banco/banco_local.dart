import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tblUsuario = "tblUsuario";
final String idUsuario = "idUsuario";
final String userUsuario = "userUsuario";
final String senhaUsuario = "senhaUsuario";

class UsuarioHelper {
  static final UsuarioHelper _instance = UsuarioHelper.interno();

  factory UsuarioHelper() => _instance;

  UsuarioHelper.interno();

  Database _banco;

  Future<Database> get banco async {
    if (_banco != null) {
      return _banco;
    } else {
      _banco = await iniciarBanco();
      return _banco;
    }
  }

  Future<Database> iniciarBanco() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "novousuario.banco");

    return await openDatabase(path, version: 1,
        onCreate: (Database banco, int newerVersion) async {
      await banco.execute(
          "CREATE TABLE $tblUsuario($idUsuario INTEGER PRIMARY KEY, $userUsuario TEXT, $senhaUsuario TEXT)");
    });
  }

  Future<UsuarioClasse> salvarUsuario(UsuarioClasse usuario) async {
    try {
      Database dbUsuario = await banco;
      usuario.id = (await dbUsuario?.insert(tblUsuario, usuario.toMap()));
      return usuario;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<UsuarioClasse> consultarUsuario(String user) async {
    Database dbUsuario = await banco;
    List<Map> retorno = await dbUsuario.query(tblUsuario,
        columns: [userUsuario, senhaUsuario],
        where: "$userUsuario = ?",
        whereArgs: [user]);
    if (retorno.isNotEmpty) {
      return UsuarioClasse.fromMap(retorno.first);
    } else {
      return null;
    }
  }

  Future<int> removerUsuario(int id) async {
    Database dbUsuario = await banco;
    return await dbUsuario
        .delete(tblUsuario, where: "$idUsuario = ?", whereArgs: [id]);
  }

  Future<UsuarioClasse> atualizarUsuario(UsuarioClasse usuario) async {
    try {
    Database dbUsuario = await banco;
    print(usuario);
     await dbUsuario.update(tblUsuario, usuario.toMap(),
        where: "$idUsuario = ?", whereArgs: [usuario.id]);
    return usuario;

    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<List> consultarTodosUsuarios() async {
    Database dbUsuario = await banco;
    List listMap = await dbUsuario.rawQuery("SELECT * FROM $tblUsuario");
    List<UsuarioClasse> listaUsuario = [];
    for (Map m in listMap) {
      listaUsuario.add(UsuarioClasse.fromMap(m));
    }
    return listaUsuario;
  }

  Future<int> quantidadeUsuarios() async {
    Database dbUsuario = await banco;
    return Sqflite.firstIntValue(
        await dbUsuario.rawQuery("SELECT COUNT(*) FROM $tblUsuario"));
  }

  Future fecharBanco() async {
    Database dbUsuario = await banco;
    dbUsuario.close();
  }

  Future<bool> loginUsuario(String user, String senha) async {
    Database dbUsuario = await banco;
    List<Map> retorno = await dbUsuario.query(tblUsuario,
        where: "$userUsuario = ? AND $senhaUsuario = ?",
        whereArgs: [user, senha]);
    if (retorno.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

}

class UsuarioClasse {
  int id;
  String user;
  String senha;

  UsuarioClasse();

  UsuarioClasse.fromMap(Map map) {
    id = map[idUsuario];
    user = map[userUsuario];
    senha = map[senhaUsuario];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      userUsuario: user,
      senhaUsuario: senha,
    };
    if (id != null) {
      map[idUsuario] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Usuario(id: $id, user: $user, senha: $senha)";
  }
}
