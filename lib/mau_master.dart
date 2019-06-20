import "dart:io";
import 'dart:math';

import 'card.dart';
import 'card_color.dart';
import 'card_deck.dart';
import 'card_picture.dart';
import 'player.dart';

class MauMaster {
  static const String Version = "Simple Mau-Mau Cards Game (Version 1.00)";
  static const int CardsAtHand = 5; // used for testing - should be 5 normally

  CardDeck _playing; // deck to play (Kartenstapel zum Ablegen - offen)
  CardDeck _drawing; // deck to draw (Kartenstapel zum Ziehen - verdeckt)
  List<Player> _players; // array of players

  // controlling variables of a single game
  int _currentPlayer; // index of current player
  bool _isSevenActive; // must seven be considered or not
  int _sevenCounter; // number of cards to draw, if seven is played
  CardColor _choosenColor; // choosen color, if 'Bube' is played
  int _activePlayers; // number of active players
  int _rounds; // counting rounds of a game

  Random _random;

  // needed to control output
  bool _isDebug;
  bool _isVerbose;

  MauMaster(List<String> names) {
    // TODO: create new random generator (prefer unique results to make testing more easier)
    _random = Random();

    // create two card decks
    _playing = CardDeck(_random); // deck to play (Kartenstapel zum Ablegen)
    _drawing = CardDeck(_random); // deck to draw (Kartenstapel zum Ziehen)

    // create array of players
    _players = List<Player>(names.length);
    for (int i = 0; i < names.length; i++) {
      _players[i] = Player(name: names[i]);
      _players[i].PlayingDeck = _playing;
      _players[i].DrawingDeck = _drawing;
    }

    // read environment variables from launch.json
    Map<String, String> env = Platform.environment;
    String value = env["DEBUG"];
    _isDebug = (value == 'true') ? true : false;

    // set (or clear) 'verbose' flag
    _isVerbose = true;
  }

  // public interface
  void reset() {
    // intialize card decks
    _playing.clear();
    _drawing.clear();
    _drawing.fill(); // fill deck with all available cards ...
    _drawing.shuffle(); // ... and mix them ...

    for (int i = 0; i < _players.length; i++) {
      _players[i].IsPlaying = true;
      _players[i].clearHand();
      _players[i].drawCards(CardsAtHand); // draw initial amount of cards
    }

    _currentPlayer = 0;
    _isSevenActive = true;
    _sevenCounter = 2;
    _choosenColor = CardColor.Empty;
    _activePlayers = _players.length;
    _rounds = 0;
  }

  // public interface
  void printVersion() {
    print("-------------------------------------------------------------");
    print(MauMaster.Version);
    print("-------------------------------------------------------------");
  }

  void playGame() {
    // uncover first card
    Card firstCard = _drawing.pop();
    _playing.push(firstCard);

    while (_activePlayers > 1) {
      // trace game
      Card topMostCard = _playing.TopOfDeck;
      _logGameStatusDebug(topMostCard, _currentPlayer); // debug/verbose output

      // play next turn
      _rounds++;
      _nextTurn();
      _updateNumberOfActivePlayers();
      _nextPlayer();
    }

    _logFinalGameStatus();
  }

  // private helper methods
  void _nextTurn() {
    Card top = _playing.TopOfDeck;
    Player player = _players[_currentPlayer];

    if (top.Picture == CardPicture.Sieben && _isSevenActive) {
      if (player.hasSeven()) {
        player.playSeven();
        _sevenCounter += 2;
      } else {
        player.drawCards(_sevenCounter);
        _sevenCounter = 2;
        _isSevenActive = false;
      }
    } else {
      _isSevenActive = true;
      CardColor currentColor = _playing.TopOfDeck.Color;
      if (_choosenColor != CardColor.Empty) currentColor = _choosenColor;
      CardPicture currentPicture = _playing.TopOfDeck.Picture;

      if (player.playColorOrPicture(currentColor, currentPicture)) {
        // player has played a card
        _choosenColor = CardColor.Empty;
      } else if (player.hasBube()) {
        // player cannot play a card, but has a 'Bube', we play it immediately
        player.playBube();
        _choosenColor = player.chooseAColor();
      } else {
        // player has neither requested color nor requested picture: draw a card
        Card card = player.drawCard();

        // check, whether drawn card can be played immediately
        if (card.Picture == CardPicture.Bube) {
          // player has drawn a Bube card, we play it immediately
          player.playCard(card);
          _choosenColor = player.chooseAColor();
        } else if (card.Color == _playing.TopOfDeck.Color ||
            card.Picture == _playing.TopOfDeck.Picture) {
          // player can play drawn card
          player.playCard(card);
          _choosenColor = CardColor.Empty;
        }
      }
    }
  }

  void _updateNumberOfActivePlayers() {
    _activePlayers = 0;
    for (int i = 0; i < _players.length; i++) {
      if (_players[i].IsPlaying) {
        _activePlayers++;
      }
    }
  }

  void _nextPlayer() {
    _nextPlayerInternal();
    Card top = _playing.TopOfDeck;
    if (top.Picture == CardPicture.Acht) {
      _nextPlayerInternal();
    }
  }

  void _nextPlayerInternal() {
    // move index to next valid index (take care of array bounds)
    _currentPlayer++;
    if (_currentPlayer == _players.length) _currentPlayer = 0;

    // search next array slot with still active player
    while (!_players[_currentPlayer].IsPlaying) {
      _currentPlayer++;
      if (_currentPlayer == _players.length) _currentPlayer = 0;
    }
  }

  // void _nextPlayer() {
  //   // update number of active players
  //   _activePlayers = 0;
  //   for (int i = 0; i < _players.length; i++) {
  //     if (_players[i].IsPlaying) {
  //       _activePlayers++;
  //     }
  //   }

  //   // move to next player
  //   _currentPlayer++;
  //   if (_currentPlayer == _players.length) _currentPlayer = 0;

  //   // search next array slot with still active player
  //   while (!_players[_currentPlayer].IsPlaying) {
  //     _currentPlayer++;
  //     if (_currentPlayer == _players.length) _currentPlayer = 0;
  //   }
  // }

  // logging utilities
  static void log(String message) {
    print(message);
  }

  void _logFinalGameStatus() {
    int index = _players.indexWhere((player) => player.IsPlaying);
    print("${_players[index].Name} has lost --- Game over [${_rounds}]");
  }

  void _logGameStatusDebug(Card topMostCard, int currentPlayer) {
    if (_isVerbose) {
      print("-------------------------------------------------------------");
      print("Topmost card: ${topMostCard}");
      print("-------------------------------------------------------------");

      for (int i = 0; i < _players.length; i++) {
        String prefix = (i == currentPlayer) ? "-->" : "   ";
        print("${prefix} ${_players[i].toString()}");
      }

      print("-------------------------------------------------------------");
    }

// #if SINGLE_STEP
//         Console.ReadKey();  // just for testing
// #endif
  }
}
