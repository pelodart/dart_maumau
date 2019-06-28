import 'card.dart';

class CardSet {
  final List<Card> _set;

  // c'tor(s)
  CardSet() : _set = List<Card>() {}

  // getter
  int get Size => _set.length;
  bool get IsEmpty => _set.length == 0;

  // index operator
  operator [](int i) => _set[i];
  operator []=(int i, Card value) => _set[i] = value;

  // public interface
  void add(Card card) {
    _set.add(card);
  }

  void remove(int index) {
    if (index < 0 || index >= _set.length) {
      throw RangeError("Wrong Index ${index} !");
    }

    _set.removeAt(index);
  }

  void clear() {
    _set.clear();
  }

  // overrides
  @override
  String toString() {
    String s = '';
    for (int i = 0; i < _set.length; i++) {
      s += _set[i].toString();
      if (i < _set.length - 1) s += ", ";
    }

    return s;
  }
}
