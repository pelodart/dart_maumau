import 'card_picture.dart';
import 'card_color.dart';
import 'card.dart';
import 'card_deck.dart';
import 'card_set.dart';
import 'mau_master.dart';

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
  set IsPlaying(bool value) => _isPlaying = value;

  set PlayingDeck(CardDeck value) => _playing = value;
  set DrawingDeck(CardDeck value) => _drawing = value;

  // public interface
  bool hasSeven() {
    for (int i = 0; i < _hand.Size; i++) {
      Card card = _hand[i];
      if (card.Picture == CardPicture.Sieben) return true;
    }

    return false;
  }

  bool hasBube() {
    for (int i = 0; i < _hand.Size; i++) {
      Card card = _hand[i];
      if (card.Picture == CardPicture.Bube) return true;
    }

    return false;
  }

  bool playSeven() {
    for (int i = 0; i < _hand.Size; i++) {
      Card card = _hand[i];
      if (card.Picture == CardPicture.Sieben) {
        _hand.remove(i);
        playCard(card);
        return true;
      }
    }

    throw Exception('Unexpected error: Player should have a 7!');
  }

  bool playBube() {
    for (int i = 0; i < _hand.Size; i++) {
      Card card = _hand[i];
      if (card.Picture == CardPicture.Bube) {
        _hand.remove(i);
        playCard(card);
        return true;
      }
    }

    throw Exception('Unexpected error: Player should have a Bube!');
  }

  void drawCards(int number) {
    for (int i = 0; i < number; i++) {
      Card card = this.drawCard();
      _hand.add(card);
    }
  }

  bool playColorOrPicture(CardColor color, CardPicture picture) {
    for (int i = 0; i < _hand.Size; i++) {
      Card card = _hand[i];

      // picture 'Bube' isn't a *regular* picture
      if (card.Picture == CardPicture.Bube) continue;

      if (card.Color == color || card.Picture == picture) {
        _hand.remove(i);
        playCard(card);
        return true;
      }
    }
    return false;
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

  void playCard(Card card) {
    MauMaster.log('>   ${_name} plays ${card}');
    _playing.push(card);
    _testMauMau();
  }

  // private helper methods
  void _testMauMau() {
    if (_hand.Size == 1) {
      String s = "==> ${_name} says 'Mau'";
      MauMaster.log(s);
    } else if (_hand.Size == 0) {
      String msg = ">   ${_name} says 'Mau-Mau', leaving game !";
      MauMaster.log(msg);
      _isPlaying = false;
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

  void clearHand() {
    _hand.clear();
  }

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
