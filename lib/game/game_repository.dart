import 'package:perudo/models/bet.dart';
import 'package:perudo/models/game.dart';
import 'package:perudo/http/service.dart';
import 'package:perudo/models/player.dart';

class GameRepository {
  var service = Service();

  Future<Game> getGameDetails() async {
    var response = await service.getGameDetails();
    var currentBet = response.currentBet != null
        ? Bet(
            response.currentBet!.value,
            response.currentBet!.count,
            Player(
              response.currentBet!.player.isAdmin,
              response.currentBet!.player.id,
              response.currentBet!.player.diceValues,
              response.currentBet!.player.ready,
              response.currentBet!.player.name,
            ))
        : null;
    return Game(
      Player(
        response.currentPlayer.isAdmin,
        response.currentPlayer.id,
        response.currentPlayer.diceValues,
        response.currentPlayer.ready,
        response.currentPlayer.name,
      ),
      response.players
          .map((e) => Player(
                e.isAdmin,
                e.id,
                e.diceValues,
                e.ready,
                e.name,
              ))
          .toList(),
      response.id,
      response.startDiceNumber,
      response.turn,
      currentBet,
    );
  }
}
