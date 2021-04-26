import 'package:perudo/models/json_models.dart';
import 'package:perudo/models/player.dart';

class Bet {
  int value;
  int count;
  Player player;

  Bet(this.value, this.count, this.player);

  BetDTO toDTO() {
    return BetDTO(value, count, player.toDTO());
  }
}
