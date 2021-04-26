import 'package:perudo/models/json_models.dart';
import 'package:uuid/uuid.dart';

class Player {
  String? id;
  bool ready;
  List<int>? diceValues = [];
  String name;
  final bool isAdmin;

  Player(this.isAdmin, [this.id, this.diceValues, this.ready = false, this.name = ""]) {
    if (this.id == null) this.id = getNewId();

    if (this.diceValues == null) {
      diceValues = [];
    }
  }

  PlayerDTO toDTO() {
    return PlayerDTO(id!, ready, diceValues!, name, isAdmin);
  }

  static String getNewId() {
    var uuid = Uuid();
    return uuid.v4();
  }
}
