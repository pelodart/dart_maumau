import 'card_picture.dart';
import 'card_color.dart';
import 'card.dart';
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
        _playing.push(card);
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
        _playing.push(card);
        return true;
      }
    }

    throw Exception('Unexpected error: Player should have a Bube!');
  }

  void drawCards(int number) {
    for (int i = 0; i < number; i++) {
      Card card = this.drawCard();
      _hand.add(card);

      // String msg = (">   {_name} draws {card} from drawing deck!");
      // MauMaster.Log(msg);
    }
  }

  bool playColorOrPicture(CardColor color, CardPicture picture) {
    for (int i = 0; i < _hand.Size; i++) {
      Card card = _hand[i];
      if (card.Color == color || card.Picture == color) {
        _hand.remove(i);
        _playing.push(card);
        // String s = (">   {_name} plays {card}");
        // MauMaster.Log(s);
        // this.PrintMauMauIf();
        return true;
      }
    }
    return false;
  }

  CardColor chooseAColor() {
    if (_hand.Size > 0) {
      // players has (still) some cards in his hand - very simple algorithm
      return _hand[0].Color;
    } else {
      // players has no more cards, choose arbitrary card color
      return CardColor.Herz;
    }
  }

  void playCard(Card card) {
    _playing.push(card);
  }

  // private helper methods
  Card drawCard() {
    // turn over playing deck to serve as new drawing deck
    if (_drawing.Size == 0) {
      // MauMaster.Log(">   turn over playing deck to serve as new drawing deck");

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

    return _drawing.pop();
  }
}
