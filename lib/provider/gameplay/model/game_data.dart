import 'package:card_crawler/data/model/savable_game_data.dart';
import 'package:card_crawler/provider/gameplay/model/game_card.dart';

class GameData {
  GameData({
    List<GameCard>? deck,
    List<GameCard?>? dungeonField,
    this.weapon,
    List<GameCard>? accessories,
    List<GameCard>? graveyard,
    this.pickedCard,
    this.level = 1,
    this.score = 0,
    this.round = 1,
    this.score = 0,
    this.health = 20,
    this.durability = 0,
    this.buff = 0,
    this.tempBuff = 0,
    this.multiplier = 1,
    this.accessoryBuff = 0,
    this.cursedAxeCounter = 0,
    this.cursedAxeDurability = 0,
    this.emperorCounter = 0,
    this.hasHealed = false,
    this.canFlee = true,
  }) {
    this.deck = deck ?? List.empty(growable: true);
    this.dungeonField = dungeonField ?? List.filled(4, null);
    this.graveyard = graveyard ?? List.empty(growable: true);
    this.accessories = accessories ?? List.empty(growable: true);
  }

  List<GameCard> deck = List.empty(growable: true);
  List<GameCard?> dungeonField = List.filled(4, null);
  GameCard? weapon;
  List<GameCard> accessories = List.empty(growable: true);
  List<GameCard> graveyard = List.empty(growable: true);
  GameCard? pickedCard;
  int level;
  int score;
  int round;
  int score;
  int health;
  int durability;
  int buff;
  int tempBuff;
  int multiplier;
  int accessoryBuff;
  int cursedAxeCounter;
  int cursedAxeDurability;
  int emperorCounter;
  bool hasHealed;
  bool canFlee;

  void removeCardFromDungeonField(int index) {
    dungeonField[index] = null;
  }

  bool isDungeonFieldLow() {
    return dungeonField.where((card) => card != null).length <= 1;
  }

  void refillDungeonField() {
    for (int i = 0; i < dungeonField.length; i++) {
      if (dungeonField[i] == null && deck.isNotEmpty) {
        dungeonField[i] = deck.removeLast();
      }
    }
  }

  bool isDungeonFieldEmpty() => dungeonField.every((card) => card == null);

  void reduceHealth(int damage) {
    health = (health <= damage) ? 0 : health - damage;
  }

  SavableGameData toSavableGameData() => SavableGameData(
    deck.map((card) => card.id).toList(),
    dungeonField.map((card) => card?.id).toList(),
    weapon?.id,
    accessories.map((card) => card.id).toList(),
    graveyard.map((card) => card.id).toList(),
    pickedCard?.id,
    level,
    score,
    round,
    score,
    health,
    durability,
    buff,
    tempBuff,
    multiplier,
    accessoryBuff,
    cursedAxeCounter,
    cursedAxeDurability,
    emperorCounter,
    hasHealed,
    canFlee,
  );
}
