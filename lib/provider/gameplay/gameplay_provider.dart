import 'package:card_crawler/data/game_save_service.dart';
import 'package:card_crawler/data/leaderboard_service.dart';
import 'package:card_crawler/provider/gameplay/type/effect/accessory_effect.dart';
import 'package:card_crawler/provider/gameplay/type/effect/consumable_effect.dart';
import 'package:card_crawler/provider/gameplay/type/effect/effect.dart';
import 'package:card_crawler/provider/gameplay/type/effect/weapon_effect.dart';
import 'package:card_crawler/provider/gameplay/type/game_card_type.dart';
import 'package:card_crawler/provider/gameplay/model/game_card.dart';
import 'package:card_crawler/provider/gameplay/type/gameplay_state.dart';
import 'package:card_crawler/provider/gameplay/type/card_location.dart';
import 'package:card_crawler/provider/gameplay/type/ui_action.dart';
import 'package:card_crawler/provider/main_menu/model/leaderboard_entry.dart';
import 'package:flutter/material.dart';

import '../../data/achievements_service.dart';
import 'type/achievement.dart';
import 'constant/game_cards/game_cards.dart';
import 'model/game_data.dart';
import 'type/gameplay_action.dart';

class GameplayProvider extends ChangeNotifier {
  GameplayState _state = Playing();

  GameplayState get state => _state;

  final List<GameplayState> _pendingStates = List.empty(growable: true);

  GameData _data = GameData();

  List<GameCard> get deck => _data.deck;

  List<GameCard?> get dungeonField => _data.dungeonField;

  GameCard? get weapon => _data.weapon;

  List<GameCard> get accessories => _data.accessories;

  List<GameCard> get graveyard => _data.graveyard;

  (CardLocation?, int) _cardWithVisibleEffectDetails = (null, -1);

  (CardLocation?, int) get cardWithVisibleEffectDetails =>
      _cardWithVisibleEffectDetails;

  int get round => _data.round;

  int get health => _data.health;

  int get durability => _data.durability;

  bool get canFlee => _data.canFlee;

  final Set<int> _unlockedAchievementIds = {};

  int get score => _data.score;

  String? _username;

  Future<void> init({GameData? gameData, required String? username}) async {
    _state = Playing();
    _pendingStates.clear();

    _username = username;

    _data =
        gameData ??
        (GameData(deck: gameCards.toList()..shuffle())..refillDungeonField());

    _resetCardView();

    for (var card in _data.dungeonField) {
      if (card != null && card.effect is OnField) {
        card.effect.trigger(_data);
        _queueState(EffectTriggered(card: card));
      }
    }

    final (unlockedAchievements, _) = await AchievementsService.getAchievements(
      username,
    );
    _unlockedAchievementIds.addAll(
      unlockedAchievements.map((achievement) => achievement.id),
    );

    _unlockAchievement(Achievement.firstStep);

    _triggerPendingState();

    notifyListeners();
  }

  void action(GameplayAction action) {
    _resetCardView();

    for (var card in _data.accessories) {
      if (card.effect is SpectreBoots) {
        _data.canFlee = true;
      }
    }

    switch (action) {
      case SelectCardFromDungeonField(card: var card, index: var index):
        {
          _data.pickedCard = card;
          _data.removeCardFromDungeonField(index);

          for (var acc in _data.accessories) {
            if (acc.effect is AccessoryEffect) {
              acc.effect.trigger(_data);
            }
          }

          if (card.effect is OnPicked) {
            card.effect.trigger(_data);
            _queueState(EffectTriggered(card: card));
          }

          switch (card.type) {
            case GameCardType.consumable:
              {
                if (!_data.hasHealed) {
                  _data.health += card.value;
                  _data.hasHealed = true;
                }
                _data.graveyard.add(card);
                if (card.effect == VolatileElixir() && _data.weapon != null && _data.accessories.length >= 3) _unlockAchievement(Achievement.oops);
              }
            case GameCardType.weapon:
              {
                if (_data.weapon == null) {
                  _data.weapon = card;
                } else {
                  _data.graveyard.add(_data.weapon!);
                  _data.weapon = card;
                }
                _data.durability = 15;
              }
            case GameCardType.monster:
              {
                card.value += _data.tempBuff;
                _data.buff = 0;
                _data.tempBuff = 0;

                if (_data.durability > card.value) {
                  if (_data.weapon?.effect is OnUse) {
                    _data.weapon?.effect.trigger(_data);
                    _queueState(EffectTriggered(card: _data.weapon!));
                  }

                  _data.weapon?.value += _data.buff;
                  _data.weapon?.value += _data.tempBuff;

                  if (card.value > (_data.weapon?.value ?? 0)) {
                    _data.reduceHealth(card.value - _data.weapon!.value);
                  }

                  _data.durability = card.value;
                } else {
                  _data.reduceHealth(card.value);
                }

                _data.graveyard.add(card);

                _data.weapon?.value -= _data.tempBuff;

                if (card.effect is OnKill) {
                  card.effect.trigger(_data);
                  _queueState(EffectTriggered(card: card));
                }
                if (_data.weapon?.effect is CursedAxe) {
                  _data.cursedAxeCounter++;
                  if (_data.cursedAxeCounter % 2 != 0) {
                    _data.durability = 0;
                  } else {
                    _data.durability = 15;
                  }
                }

                if (_data.weapon?.effect is ArtemisBow) {
                  _data.weapon?.effect.trigger(_data);
                }

                if(card.value == 0) _unlockAchievement(Achievement.reducedToAtoms);
                _data.score += card.value * 100;
                if (_data.score >= 10000) _unlockAchievement(Achievement.highScore);
              }
            case GameCardType.accessory:
              {
                if (_data.accessories.length < 3) {
                  _data.accessories.add(card);
                } else {
                  _queueState(ReplacingAccessory());
                }
              }
          }

          if (_data.health == 0) {
            _queueState(Finished(isWin: false));
            _unlockAchievement(Achievement.niceTry);
            if (_data.deck.isEmpty) _unlockAchievement(Achievement.soClose);

            if (_username != null) {
              LeaderboardService.sendLeaderboardEntry(
                  LeaderboardEntry(username: _username!, score: score));
            }
          } else if (_data.isDungeonFieldEmpty() && _data.deck.isEmpty) {
            _unlockAchievement(Achievement.dungeonCrawler);
            if (_data.health == 20) _unlockAchievement(Achievement.perfectAdventurer);
            if (_data.accessories.isEmpty) _unlockAchievement(Achievement.nakedButNotAfraid);
            _queueState(Finished(isWin: true));

            if (_username != null) {
              LeaderboardService.sendLeaderboardEntry(
                  LeaderboardEntry(username: _username!, score: score));
            }
          }

          if (_data.health > 20) _data.health = 20;

          _data.buff = 0;
          _data.tempBuff = 0;

          if (_data.pickedCard!.effect is TemporalDew) {
            _data.hasHealed = false;
          }

          if (_data.isDungeonFieldLow()) {
            _data.refillDungeonField();
            _data.round++;
            _data.canFlee = true;
            _data.hasHealed = false;
          }
        }
      case ReplaceAccessory(card: var card, index: var index):
        {
          _data.graveyard.add(card);
          _data.accessories[index] = _data.pickedCard!;
          _queueState(Playing());
        }
      case Flee():
        {
          _data.dungeonField.shuffle();
          for (int i = 0; i < _data.dungeonField.length; i++) {
            var card = _data.dungeonField[i];
            _data.dungeonField[i] = null;
            if (card != null) _data.deck.insert(0, card);
          }
          _data.refillDungeonField();
          _data.canFlee = false;
          _unlockAchievement(Achievement.gottaDash);
        }
    }

    for (var card in _data.dungeonField) {
      if (card != null && card.effect is OnField) {
        card.effect.trigger(_data);
        _queueState(EffectTriggered(card: card));
      }
    }

    _triggerPendingState();

    notifyListeners();
  }

  void uiAction(UiAction action) {
    switch (action) {
      case TapCard(location: var location, index: var index):
        {
          _cardWithVisibleEffectDetails == (location, index)
              ? _cardWithVisibleEffectDetails = (null, -1)
              : _cardWithVisibleEffectDetails = (location, index);
        }
      case ShowGraveyard():
        {
          _queueState(GraveyardShown());
          _triggerPendingState();
        }
      case Pause():
        {
          _queueState(Paused());
          _triggerPendingState();
        }
      case SaveToDevice():
        {
          GameSaveService.save(_data);
          _triggerPendingState();
        }
      case SaveToCloud():
        {}
      case DismissDialog():
        _triggerPendingState();
    }

    notifyListeners();
  }

  void _resetCardView() {
    _cardWithVisibleEffectDetails = (null, -1);
  }

  void _queueState(GameplayState state) {
    _pendingStates.add(state);
  }

  void _triggerPendingState() {
    var nextState =
        (_pendingStates.isNotEmpty) ? _pendingStates.removeAt(0) : null;
    _state = nextState ?? Playing();
  }

  void _unlockAchievement(Achievement achievement) {
    final isUnlocked = _unlockedAchievementIds.contains(achievement.id);

    if (!isUnlocked) {
      _unlockedAchievementIds.add(achievement.id);
      _queueState(AchievementUnlocked(achievement: achievement));
      AchievementsService.unlockAchievement(achievement, _username);
    }
  }
}
