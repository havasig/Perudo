class Player {
  static int nextId = 0;
  late int id;
  int dice = 0;
  bool ready = false;
  List<int>? diceValues = [];
  String name = "";
  final bool isAdmin;

  static int getNewId() {
    nextId++;
    return nextId;
  }

  Player(this.isAdmin) {
    this.id = getNewId();
  }
}
