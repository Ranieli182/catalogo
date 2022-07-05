import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tblUsuario = "tblUsuario";
final String idUsuario = "idUsuario";
final String nomeUsuario = "nomeUsuario";
final String senhaUsuario = "senhaUsuario";


class UsuarioHelper {

  static final UsuarioHelper _instance = UsuarioHelper.internal();

  factory UsuarioHelper() => _instance;

  UsuarioHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "usuarionew.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $tblUsuario($idUsuario INTEGER PRIMARY KEY, $nomeUsuario TEXT, $senhaUsuario TEXT)"
      );
    });
  }

  Future<Usuario> saveContact(Usuario usuario) async {
    Database dbUsuario = await db;
    usuario.id = await dbUsuario.insert(tblUsuario, usuario.toMap());
    return usuario;
  }

  Future<Usuario> getContact(int id) async {
    Database dbUsuario = await db;
    List<Map> maps = await dbUsuario.query(tblUsuario,
        columns: [idUsuario, nomeUsuario, senhaUsuario],
        where: "$idUsuario = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return Usuario.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbUsuario = await db;
    return await dbUsuario.delete(tblUsuario, where: "$idUsuario = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Usuario usuario) async {
    Database dbUsuario = await db;
    return await dbUsuario.update(tblUsuario,
        usuario.toMap(),
        where: "$idUsuario = ?",
        whereArgs: [usuario.id]);
  }

  Future<List> getAllContacts() async {
    Database dbUsuario = await db;
    List listMap = await dbUsuario.rawQuery("SELECT * FROM $tblUsuario");
    List<Usuario> listaUsuario = List();
    for(Map m in listMap){
      listaUsuario.add(Usuario.fromMap(m));
    }
    return listaUsuario;
  }

  Future<int> getNumber() async {
    Database dbUsuario = await db;
    return Sqflite.firstIntValue(await dbUsuario.rawQuery("SELECT COUNT(*) FROM $tblUsuario"));
  }

  Future close() async {
    Database dbUsuario = await db;
    dbUsuario.close();
  }

}

class Usuario {

  int id;
  String nome;
  String senha;

  Usuario();

  Usuario.fromMap(Map map){
    id = map[idUsuario];
    nome = map[nomeUsuario];
    senha = map[senhaUsuario];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nomeUsuario: nome,
      senhaUsuario: senha,
    };
    if(id != null){
      map[idUsuario] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Usuario(id: $id, nome: $nome, senha: $senha)";
  }

}