import 'card_deck.dart';
import 'player.dart';

class MauMaster {
  static const String Version = "Simple Mau-Mau Cards Game (Version 1.00)";
  static const int MaxCardsAtBegin =
      5; // used for testing - should be 5 regularly

  CardDeck _playing; // deck to play (Kartenstapel zum Ablegen - offen)
  CardDeck _drawing; // deck to draw (Kartenstapel zum Ziehen - verdeckt)
  List<Player> _players; // array of players
  int _rounds; // counting rounds of a game
}
