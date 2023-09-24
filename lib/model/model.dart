import 'package:cv/cv.dart';
import 'package:tekartik_notepad_sqflite_app/db/db.dart';
import 'package:tekartik_notepad_sqflite_app/model/model_constant.dart';

class DbNote extends DbRecord {
  final numero = CvField<String>(columnNumero);
  final adresse = CvField<String>(columnAdresse);
  final nom = CvField<String>(columnNom);
  final prenom = CvField<String>(columnPrenom);
  final date = CvField<int>(columnUpdated);

  @override
  List<CvField> get fields => [id, nom, prenom, adresse, numero, date];
}
