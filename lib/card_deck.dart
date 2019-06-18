// TODO: IndexOutOfRangeException - gibt es die ???

import 'dart:math';
import 'card_color.dart';
import 'card_picture.dart';
import 'card.dart';

class CardDeck {
  List<Card> _deck;
  Random _rand;

  // c'tor(s)
  CardDeck(Random rand) {
    _rand = rand;
    _deck = List<Card>();
  }

  // getter/setter
  int get Size => _deck.length;
  bool get IsEmpty => _deck.length == 0;
  set Rand(Random value) => _rand = value;

  Card get TopOfDeck {
    if (this.IsEmpty) {
      throw RangeError("TopOfDeck::CardDeck is emtpy !");
    }

    Card card = _deck[_deck.length - 1];
    return card;
  }

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

  void fill() {
    // fill deck with all available cards
    for (int i = 1; i <= 4; i++) {
      for (int j = 1; j <= 8; j++) {
        Card card = Card(CardColor.values[i], CardPicture.values[j]);
        _deck.add(card);
      }
    }
  }

  void clear() {
    _deck.clear();
  }

  void shuffle() {
    // mix deck by random
    const int ShuffleCount = 30;

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
