import 'dart:math';

import 'package:card_crawler/provider/gameplay/type/game_card_type.dart';

import '../../model/game_data.dart';
import 'effect.dart';

class PowerBreastplate extends AccessoryEffect {
  PowerBreastplate()
    : super(
        'Breastplate of Power',
        'When fighting with this accessory equipped, the enemy\'s strength will be lowered by 3',
      );

  @override
  void trigger(GameData data) {
    if (data.pickedCard?.type == GameCardType.monster) {
      data.pickedCard?.value -= 3;
      if ((data.pickedCard?.value ?? 0) < 0) {
        data.pickedCard?.value = 0;
      }
    }
  }
}

class HealingAmulet extends AccessoryEffect {
  HealingAmulet()
    : super(
        'Healing Amulet',
        'When having this accessory equipped, you will heal 1 point of HP every turn, and you can always heal from potions, but all potions heal are halved',
      );

  @override
  void trigger(GameData data) {
    data.health += 1;
    if (data.pickedCard?.type == GameCardType.consumable) {
      data.pickedCard?.value = (data.pickedCard?.value ?? 0 / 2) as int;
    }
  }
}

class RingOfMending extends AccessoryEffect {
  RingOfMending()
    : super(
        'Ring Of Mending',
        'When having this accessory equipped, your weapon\'s durability will recover by 3 every turn',
      );

  @override
  void trigger(GameData data) {
    if (data.weapon != null) {
      data.durability += 3;
    }
  }
}

class HeroCape extends AccessoryEffect {
  HeroCape()
    : super(
        'Hero\'s Cape',
        'When you get a new weapon with this accessory equipped, that weapon\'s strength is increased by 3',
      );

  @override
  void trigger(GameData data) {
    if (data.pickedCard?.type == GameCardType.weapon) {
      data.pickedCard?.value += 3;
    }
  }
}

class CommanderHelmet extends AccessoryEffect {
  CommanderHelmet()
    : super(
        'Commander\'s Helmet',
        'When having this accessory equipped, there\'s a 30% chance of enemy you fight to lose all their strength before the fight',
      );

  @override
  void trigger(GameData data) {
    if (data.pickedCard?.type == GameCardType.monster) {
      var rng = Random();
      if (rng.nextInt(100) < 30) {
        data.pickedCard?.value = 0;
      }
    }
  }
}

class SpectreBoots extends AccessoryEffect {
  SpectreBoots()
    : super(
        'Spectre Boots',
        'When having this accessory equipped, you can always flee',
      );

  @override
  void trigger(GameData data) {}
}

class EmperorCrown extends AccessoryEffect {
  EmperorCrown()
    : super(
        'Emperor\'s Crown',
        'When having this accessory equipped, weapon and consumable you pickup will have +5 value, but monsters will have +2 value, this accessory will dissappear after 5 use',
      );

  @override
  void trigger(GameData data) {
    if (data.pickedCard?.type == GameCardType.weapon ||
        data.pickedCard?.type == GameCardType.consumable) {
      data.pickedCard?.value += 5;
    } else if (data.pickedCard?.type == GameCardType.monster) {
      data.pickedCard?.value += 2;
    }
    data.emperorCounter++;
    if (data.emperorCounter >= 4) {
      for (int i = 0; i < data.accessories.length; i++) {
        if (data.accessories[i].effect is EmperorCrown) {
          data.graveyard.add(data.accessories[i]);
          data.accessories.remove(data.accessories[i]);
        }
      }
    }
  }
}
