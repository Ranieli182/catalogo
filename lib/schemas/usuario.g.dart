// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'usuario.dart';
// **************************************************************************
// RealmObjectGenerator
// **************************************************************************
class Usuario extends _Usuario with RealmEntity, RealmObject {
  Usuario(
      String? user,
      String? senha,
      ) {
    RealmObject.set(this, 'user', user);
    RealmObject.set(this, 'senha', senha);
  }
  Usuario._();
  @override
  String get user => RealmObject.get<String>(this, 'user') as String;
  @override
  set user(String value) => throw RealmUnsupportedSetError();
  @override
  String get senha => RealmObject.get<String>(this, 'senha') as String;
  @override
  set senha(String value) => throw RealmUnsupportedSetError();
  @override
  Stream<RealmObjectChanges<Usuario>> get changes =>
      RealmObject.getChanges<Usuario>(this);
  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(Usuario._);
    return const SchemaObject(Usuario, [
      SchemaProperty('user', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('senha', RealmPropertyType.string),
    ]);
  }
}