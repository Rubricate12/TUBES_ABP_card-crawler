import '../../model/game_data.dart';
import 'effect.dart';

class HolyHammer extends OnUse {
  HolyHammer() : super('Holy Hammer', 'Fighting an enemy will recover 1 HP');

  @override
  void trigger(GameData data) {
    data.health += 1;
  }
}

class ArtemisBow extends OnUse {
  ArtemisBow()
    : super(
        'Artemis\'s Bow',
        'This weapon\'s durability will always recover to full when used',
      );

  @override
  void trigger(GameData data) {
    data.durability = 20;
  }
}

class TenaciousMallet extends OnUse {
  TenaciousMallet()
    : super(
        'Tenacious Mallet',
        'This weapon will deal more damage the lower it\'s durability is',
      );

  @override
  void trigger(GameData data) {
    if (data.durability < 9 && data.durability >= 6) {
      data.tempBuff = 3;
    } else if (data.durability < 6) {
      data.tempBuff = 5;
    }
  }
}

class IchorSickle extends OnUse {
  IchorSickle()
    : super(
        'Ichor Sickle',
        'This weapon will decrease the opponent\'s strength',
      );

  @override
  void trigger(GameData data) {
    data.pickedCard?.value -= 3;
    if ((data.pickedCard?.value ?? 0) < 0) {
      data.pickedCard?.value = 0;
    }
  }
}

class CursedAxe extends OnUse {
  CursedAxe()
    : super(
        'Cursed Axe',
        'This weapon\'s durability does not decay, but it needs to recharge after every use',
      );

  @override
  void trigger(GameData data) {}
}

class BloodlustBlade extends OnUse {
  BloodlustBlade()
    : super(
        'Bloodlust Blade',
        'This weapon will increase in power everytime it\'s used',
      );

  @override
  void trigger(GameData data) {
    data.buff = 1;
  }
}

class BlueStaff extends OnUse {
  BlueStaff()
    : super(
        'Blue Staff',
        'Every time this weapon is used, discard a card from the deck',
      );

  @override
  void trigger(GameData data) {
    data.graveyard.add(data.deck.removeLast());
  }
}

class WarAxe extends OnUse {
  WarAxe() : super('War Axe', 'This weapon gets stronger for every 5 hp lost');

  @override
  void trigger(GameData data) {
    int hpLost = (4 - (data.health) / 5).toInt();
    data.tempBuff = hpLost * 3;
  }
}

class MirrorBolt extends OnUse {
  MirrorBolt()
    : super(
        'Mirror Bolt',
        'This weapon will copy the strength of the monster you\'re facing',
      );

  @override
  void trigger(GameData data) {
    data.weapon!.value = data.pickedCard!.value;
  }
}
