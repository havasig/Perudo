class Player {
  static int nextId = 0;
  int? id;
  bool ready;
  List<int>? diceValues = [];
  String name;
  final bool isAdmin;

  Player(this.isAdmin,
      [this.id, this.diceValues, this.ready = false, this.name = ""]) {
    if (this.id == null) this.id = getNewId();

    if (this.diceValues == null) {
      diceValues = [];
    }
  }

  static int getNewId() {
    nextId++;
    return nextId;
  }
}
