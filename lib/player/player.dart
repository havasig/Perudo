class Player {
  static int nextId = 0;
  late int id;
  bool ready = false;
  List<int> diceValues = [];
  String name = "asd";
  final bool isAdmin;

  static int getNewId() {
    nextId++;
    return nextId;
  }

  Player(this.isAdmin) {
    this.id = getNewId();
  }
}
