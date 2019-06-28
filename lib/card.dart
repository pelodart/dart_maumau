import 'card_color.dart';
import 'card_picture.dart';

class Card {
  final CardColor _color;
  final CardPicture _picture;

  // c'tor
  Card(CardColor color, CardPicture picture)
      : _color = color,
        _picture = picture {}

  // getter
  CardColor get Color => _color;
  CardPicture get Picture => _picture;

  // overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (!(other is Card)) return false;

    final Card tmp = other;
    if (_color != tmp._color) return false;
    if (_picture != tmp._picture) return false;

    return true;
  }

  @override
  String toString() {
    return "${_color.toString().split('.')[1]} ${_picture.toString().split('.')[1]}";
  }
}
