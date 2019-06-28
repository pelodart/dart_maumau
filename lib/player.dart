import 'card_picture.dart';
import 'card_color.dart';
import 'card.dart';
import 'card_deck.dart';
import 'card_set.dart';
import 'mau_master.dart';

class Player {
  final CardSet _hand; // player's hand of cards (usually 5)
  final PlayingDeck _playing; // deck to play
  final DrawingDeck _drawing; // deck to draw
  final String _name; // players name
  bool _isPlaying; // false, after getting rid of all cards

  Player(String name, PlayingDeck playing, DrawingDeck drawing)
      : _name = name,
        _playing = playing,
        _drawing = drawing,
        _hand = new CardSet() {
    _isPlaying = true;
  }

  // getter/setter
  String get Name => _name;
  int get NumberCards => _hand.Size;
  bool get IsPlaying => _isPlaying;
  set IsPlaying(bool value) => _isPlaying = value;

  // public interface
  bool hasPicture(CardPicture picture) {
    for (int i = 0; i < _hand.Size; i++) {
      Card card = _hand[i];
      if (card.Picture == picture) return true;
    }

    return false;
  }

  void playCard(Card card) {
    MauMaster.log('>   ${_name} plays ${card}');
    _playing.push(card);
    _testMauMau();
  }

  bool playPicture(CardPicture picture) {
    for (int i = 0; i < _hand.Size; i++) {
      Card card = _hand[i];
      if (card.Picture == picture) {
        _hand.remove(i);
        playCard(card);
        return true;
      }
    }

    throw Exception(
        'Unexpected error: Player should have reuested picture ${picture}');
  }

  bool playColorOrPicture(
      CardColor requestedColor, CardPicture requestedPicture) {
    for (int i = 0; i < _hand.Size; i++) {
      Card card = _hand[i];

      // picture 'Bube' isn't a *regular* picture
      if (card.Picture == CardPicture.Bube) continue;

      if (card.Color == requestedColor || card.Picture == requestedPicture) {
        _hand.remove(i);
        playCard(card);
        return true;
      }
    }
    return false;
  }

  void drawCards(int number) {
    for (int i = 0; i < number; i++) {
      Card card = this.drawCard();
      _hand.add(card);
    }
  }

  Card drawCard() {
    // turn over playing deck to serve as new drawing deck
    if (_drawing.Size == 0) {
      MauMaster.log('>   turn over playing deck to serve as new drawing deck');

      // save topmost card of playing stack
      Card topmostPlayingCard = _playing.pop();

      // copy rest of playing deck to drawing deck
      while (!_playing.IsEmpty) {
        Card tmp = _playing.pop();
        _drawing.push(tmp);
      }

      // shuffle drawing stack
      this._drawing.shuffle();

      // restore topmost card of playing stack
      this._playing.push(topmostPlayingCard);
    }

    Card card = _drawing.pop();
    String msg = ('>   ${_name} draws ${card} from drawing deck!');
    MauMaster.log(msg);
    return card;
  }

  void takeCard(Card card) {
    _hand.add(card);
  }

  CardColor chooseAColor() {
    if (_hand.Size > 0) {
      // players has (still) some cards in his hand - very simple algorithm
      MauMaster.log(
          '>   ${_name} has choosen color ${_hand[0].Color.toString().split('.')[1]}');
      return _hand[0].Color;
    } else {
      // players has no more cards, choose arbitrary card color
      MauMaster.log(
          '>   ${_name} has choosen color ${CardColor.Herz.toString().split('.')[1]}');
      return CardColor.Herz;
    }
  }

  void clearHand() {
    _hand.clear();
  }

  // private helper methods
  void _testMauMau() {
    if (_hand.Size == 1) {
      String s = "==> ${_name} says 'Mau'";
      MauMaster.log(s);
    } else if (_hand.IsEmpty) {
      String msg = ">   ${_name} says 'Mau-Mau', leaving game !";
      MauMaster.log(msg);
      _isPlaying = false;
    }
  }

  // overrides
  @override
  String toString() {
    String s = "${_name} [${_isPlaying ? 'X' : '-'}]";
    if (_hand.Size > 0) {
      s += ': ';
      s += _hand.toString();
    }
    return s;
  }
}
