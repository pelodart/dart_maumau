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
  int _currentPlayer = 0;
  int _sevenCounter = 2;
  CardColor _choosenColor = CardColor.Empty;
  int _rounds; // counting rounds of a game
  int _activePlayers;
  Random _random;

  bool _isDebug;
  bool _isVerbose;

  MauMaster(List<String> names) {
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

    // TODO: create new random generator (prefer unique results to make testing more easier)
    _random = Random();

    // read environment variables from launch.json
    Map<String, String> env = Platform.environment;
    String value = env["DEBUG"];
    _isDebug = (value == 'true') ? true : (value == 'false') ? false : false;

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
    _activePlayers = _players.length;
    _rounds = 0;
  }

  // public interface
  void printVersion() {
    print("------------------------------------------------------------------");
    print(MauMaster.Version);
    print("------------------------------------------------------------------");
  }

  void playGame() {
    while (_activePlayers > 1) {
      // trace game
      Card topMostCard = _playing.TopOfDeck;
      _logGameStatusDebug(topMostCard, _currentPlayer); // debug/verbose output

      // play next turn
      _rounds++;
      _nextTurn();
      _nextPlayer();
    }

    _logFinalGameStatus();
  }

  // private helper methods
  void _nextTurn() {
    Card top = _playing.TopOfDeck;
    Player player = _players[_currentPlayer];

    if (top.Picture == CardPicture.Sieben) {
      if (player.hasSeven()) {
        player.playSeven();
        _sevenCounter += 2;
      } else {
        player.drawCards(_sevenCounter);
        _sevenCounter = 2;
      }
    } else {
      CardColor currentColor = _playing.TopOfDeck.Color;
      if (_choosenColor != CardColor.Empty) currentColor = _choosenColor;
      CardPicture currentPicture = _playing.TopOfDeck.Picture;

      if (player.playColorOrPicture(currentColor, currentPicture)) {
        // player could play a card
        _choosenColor = CardColor.Empty;
        // Log-Ausgabe;
      } else if (player.hasBube()) {
        // player couldn't play a card, but has a Bube card, we play it immediately
        player.playBube();
        _choosenColor = player.chooseAColor();
      } else {
        // player has either requested color nor requested picture: draw a card
        Card card = player.drawCard();

        // check, whether drawn card can be played immediately
        if (card.Picture == CardPicture.Bube) {
          // player has drawn a Bube card, we play it immediately
          player.playBube();
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

  void _nextPlayer() {
    // update number of active players
    _activePlayers = 0;
    for (int i = 0; i < _players.length; i++) {
      if (_players[i].IsPlaying) {
        _activePlayers++;
      }
    }

    // move to next player
    _currentPlayer++;
    if (_currentPlayer == _players.length) _currentPlayer = 0;

    // search next array slot with still active player
    while (!_players[_currentPlayer].IsPlaying) {
      _currentPlayer++;
      if (_currentPlayer == _players.length) _currentPlayer = 0;
    }
  }

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
      print(
          "------------------------------------------------------------------");
      print("Topmost card: ${topMostCard}");
      print(
          "------------------------------------------------------------------");

      for (int i = 0; i < _players.length; i++) {
        String prefix = (i == currentPlayer) ? "-->" : "   ";
        print("${prefix} ${_players[i]}");
      }

      print(
          "------------------------------------------------------------------");
    }

// #if SINGLE_STEP
//         Console.ReadKey();  // just for testing
// #endif
  }
}
