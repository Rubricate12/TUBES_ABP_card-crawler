import 'package:card_crawler/provider/gameplay/model/game_data.dart';

import '../../provider/gameplay/constant/game_cards/game_cards.dart';

class SavableGameData {
  SavableGameData(
    this.deck,
    this.dungeonField,
    this.weapon,
    this.accessories,
    this.graveyard,
    this.pickedCard,
    this.level,
    this.score,
    this.round,
    this.health,
    this.durability,
    this.buff,
    this.tempBuff,
    this.multiplier,
    this.accessoryBuff,
    this.cursedAxeCounter,
    this.cursedAxeDurability,
    this.emperorCounter,
    this.hasHealed,
    this.canFlee,
  );

  List<int> deck;
  List<int?> dungeonField;
  int? weapon;
  List<int> accessories;
  List<int> graveyard;
  int? pickedCard;
  int level;
  int score;
  int round;
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

  GameData toGameData() => GameData(
    deck: List.generate(
      deck.length,
      (index) => gameCards.firstWhere((card) => card.id == deck[index]),
    ),
    dungeonField: List.generate(
      dungeonField.length,
      (index) =>
          dungeonField[index] == null
              ? null
              : gameCards.firstWhere((card) => card.id == dungeonField[index]),
      growable: false,
    ),
    weapon:
        weapon == null
            ? null
            : gameCards.firstWhere((card) => card.id == weapon),
    accessories: List.generate(
      accessories.length,
      (index) => gameCards.firstWhere((card) => card.id == accessories[index]),
    ),
    graveyard: List.generate(
      graveyard.length,
      (index) => gameCards.firstWhere((card) => card.id == graveyard[index]),
    ),
    pickedCard:
        pickedCard == null
            ? null
            : gameCards.firstWhere((card) => card.id == pickedCard),
    level: level,
    score: score,
    round: round,
    health: health,
    durability: durability,
    buff: buff,
    tempBuff: tempBuff,
    multiplier: multiplier,
    accessoryBuff: accessoryBuff,
    cursedAxeCounter: cursedAxeCounter,
    cursedAxeDurability: cursedAxeDurability,
    emperorCounter: emperorCounter,
    hasHealed: hasHealed,
    canFlee: canFlee,
  );

  factory SavableGameData.fromJson(Map<String, dynamic> json) =>
      SavableGameData(
        List<int>.from(json['deck']),
        List<int?>.from(json['dungeonField']),
        json['weapon'],
        List<int>.from(json['accessories']),
        List<int>.from(json['graveyard']),
        json['pickedCard'],
        json['level'],
        json['score'],
        json['round'],
        json['health'],
        json['durability'],
        json['buff'],
        json['tempBuff'],
        json['multiplier'],
        json['accessoryBuff'],
        json['cursedAxeCounter'],
        json['cursedAxeDurability'],
        json['emperorCounter'],
        json['hasHealed'],
        json['canFlee'],
      );

  Map<String, dynamic> toJson() => {
    'deck': deck,
    'dungeonField': dungeonField,
    'weapon': weapon,
    'accessories': accessories,
    'graveyard': graveyard,
    'pickedCard': pickedCard,
    'level': level,
    'score': score,
    'round': round,
    'health': health,
    'durability': durability,
    'buff': buff,
    'tempBuff': tempBuff,
    'multiplier': multiplier,
    'accessoryBuff': accessoryBuff,
    'cursedAxeCounter': cursedAxeCounter,
    'cursedAxeDurability': cursedAxeDurability,
    'emperorCounter': emperorCounter,
    'hasHealed': hasHealed,
    'canFlee': canFlee,
  };
}
