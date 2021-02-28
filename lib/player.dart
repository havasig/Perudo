class Player {
  int id;
  String username;
  int dice;
  bool ready = false;
  List<int> diceValues = List();

  Player({this.id, this.username, this.dice});
}
