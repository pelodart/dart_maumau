import 'dart:math';
import 'card_color.dart';
import 'card_picture.dart';
import 'card.dart';

class _CardDeck {
  final List<Card> _deck;
  Random _rand;

  // c'tor(s)
  _CardDeck(Random rand) : _deck = List<Card>() {
    _rand = rand;
  }

  // getter
  int get Size => _deck.length;
  bool get IsEmpty => _deck.length == 0;

  // public interface
  void push(Card card) {
    _deck.add(card);
  }

  Card pop() {
    if (this.IsEmpty) {
      throw RangeError("Pop::CardDeck is emtpy !");
    }

    Card card = _deck[_deck.length - 1];
    _deck.removeAt(_deck.length - 1);
    return card;
  }

  void clear() {
    _deck.clear();
  }

  // overrides
  @override
  String toString() {
    String s = '';
    for (int i = 0; i < _deck.length; i++) {
      s += "${i + 1}: ${_deck[i]}";
      s += '\n';
    }

    return s;
  }
}

class PlayingDeck extends _CardDeck {
  // c'tor(s)
  PlayingDeck(Random rand) : super(rand) {}

  Card get TopOfDeck {
    if (this.IsEmpty) {
      throw RangeError("TopOfDeck::CardDeck is emtpy !");
    }

    Card card = _deck[_deck.length - 1];
    return card;
  }
}

class DrawingDeck extends _CardDeck {
  static const int ShuffleCount = 30;

  // c'tor(s)
  DrawingDeck(Random rand) : super(rand) {}

  // public interface
  void fill() {
    // fill deck with all available cards
    for (int i = 1; i <= 4; i++) {
      for (int j = 1; j <= 8; j++) {
        Card card = Card(CardColor.values[i], CardPicture.values[j]);
        _deck.add(card);
      }
    }
  }

  void shuffle() {
    // mix deck by random
    for (int i = 0; i < ShuffleCount; i++) {
      int index1 = _rand.nextInt(_deck.length);
      int index2 = _rand.nextInt(_deck.length);

      if (index1 != index2) {
        Card temp = _deck[index1];
        _deck[index1] = _deck[index2];
        _deck[index2] = temp;
      }
    }
  }
}
