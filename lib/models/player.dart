import 'package:perudo/models/json_models.dart';
import 'package:uuid/uuid.dart';

class Player {
  String? id;
  bool ready;
  List<int>? diceValues = [];
  String name;
  int? diceCount;
  final bool isAdmin;

  Player(this.isAdmin, [this.id, this.diceValues, this.ready = false, this.diceCount = 0, this.name = ""]) {
    if (this.id == null) this.id = getNewId();

    if (this.diceValues == null) {
      diceValues = [];
    }
  }

  PlayerDTO toDTO() {
    return PlayerDTO(id!, ready, diceValues!, name, diceCount!, isAdmin);
  }

  static String getNewId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  void looseDice() {
    this.diceCount = diceCount != null ? diceCount! - 1 : null;
  }
}
