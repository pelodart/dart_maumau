import 'card_deck.dart';
import 'card_set.dart';

class Player {
  CardSet _hand; // player's hand of cards (usually 5)
  CardDeck _playing; // deck to play (Kartenstapel zum Ablegen)
  CardDeck _drawing; // deck to draw (Kartenstapel zum Ziehen)
  String _name; // players name
  bool _isPlaying; // false, after getting rid of all cards

  Player({String name}) {
    _hand = new CardSet();
    _name = name;
    _isPlaying = true;
    _playing = null; // yet to be provided - see property 'PlayingDeck'
    _drawing = null; // yet to be provided - see property 'DrawingDeck'
  }

  // getter/setter
  String get Name => _name;
  int get NumberCards => _hand.Size;
  bool get IsPlaying => _isPlaying;

  set PlayingDeck(CardDeck value) => _playing = value;
  set DrawingDeck(CardDeck value) => _drawing = value;
}
