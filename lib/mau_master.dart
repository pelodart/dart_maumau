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

  // TODO: DA muss ein c'tor her ....

  // public interface
  void nextTurn() {
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

  void nextPlayer() {}
}
