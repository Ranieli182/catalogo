import 'package:realm/realm.dart';
part 'usuario.g.dart';

@RealmModel()
class _Usuario {
  @PrimaryKey()
  late  String user;
  late  String senha;
}