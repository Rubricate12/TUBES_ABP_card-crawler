import '../../model/game_data.dart';
import 'effect.dart';

class TemporalDew extends OnPicked {
  TemporalDew()
    : super(
        'Temporal Dew',
        'Aside from healing, this potion will restore your durability, and allows you to heal and flee again this turn',
      );

  @override
  void trigger(GameData data) {
    if (data.weapon != null) {
      data.durability = 20;
    }
    data.canFlee = true;
  }
}

class TitansShroom extends OnPicked {
  TitansShroom()
    : super(
        'Titan\'s Shrooms',
        'This Mushroom will increase your weapon\'s strength by 3 points',
      );

  @override
  void trigger(GameData data) {
    if (data.weapon != null) {
      data.weapon?.value += 3;
    }
  }
}

class EmeticElixir extends OnPicked {
  EmeticElixir() : super('Emetic Elixir', 'Discard 3 cards from the deck');

  @override
  void trigger(GameData data) {
    for (int i = 0; i < 3; i++) {
      if (data.deck.isNotEmpty) {
        data.graveyard.add(data.deck.removeLast());
      }
    }
  }
}

class BolterPotion extends OnPicked {
  BolterPotion()
    : super(
        'Bolter Potion',
        'Return the remaining cards on the field to the bottom of the deck',
      );

  @override
  void trigger(GameData data) {
    data.dungeonField.shuffle();
    for (int i = 0; i < data.dungeonField.length; i++) {
      var card = data.dungeonField[i];
      data.dungeonField[i] = null;
      if (card != null) data.deck.insert(0, card);
    }
    data.refillDungeonField();
  }
}

class VolatileElixir extends OnPicked {
  VolatileElixir()
    : super(
        'Volatile Elixir',
        'Remove every card from the dungeon field, your weapon, and your accessories',
      );

  @override
  void trigger(GameData data) {
    for (int i = 0; i < data.dungeonField.length; i++) {
      if (data.dungeonField[i] != null) {
        data.graveyard.add(data.dungeonField[i]!);
        data.dungeonField[i] = null;
      }
    }
    if (data.weapon != null) {
      data.graveyard.add(data.weapon!);
      data.durability = 0;
      data.weapon = null;
    }
    data.graveyard.addAll(data.accessories);
    data.accessories.clear();
  }
}

class BloodthornBrew extends OnPicked {
  BloodthornBrew()
    : super(
        'Bloodthorn Brew',
        'Drinking this potion won\'t heal you, in exchange you will set your weapon power to 30 and restore it\'s durability',
      );

  @override
  void trigger(GameData data) {
    if (data.weapon != null) {
      data.weapon!.value = 30;
      data.durability = 20;
    }
  }
}

class AgedBerries extends OnPicked {
  AgedBerries()
    : super(
        'Aged Berries',
        'These Berries will heal you more for every round you\'ve played',
      );

  @override
  void trigger(GameData data) {
    data.pickedCard!.value += data.round;
  }
}
