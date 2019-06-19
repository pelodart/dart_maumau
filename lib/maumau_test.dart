import 'dart:math';


import 'card.dart';
import 'card_color.dart';
import 'card_deck.dart';
import 'card_picture.dart';
import 'card_set.dart';
import 'mau_master.dart';

class MauMauTest {
  static void testUnit_01_Cards() {
    // test frame for Card objects
    Card card1 = Card(CardColor.Kreuz, CardPicture.Neun);
    Card card2 = Card(CardColor.Pik, CardPicture.Koenig);
    Card card3 = Card(CardColor.Kreuz, CardPicture.Neun);

    print(card1);
    print(card2);

    print("Farbe: ${card1.Color}");
    print("Bild:  ${card2.Picture}");

    if (card1 == card2)
      print("Die Karten sind gleich");
    else
      print("Die Karten sind verschieden");

    print(card1 == card3);
  }

  static void testUnit_02_CardDeck() {
    Random rand = Random(1);

    // test frame for a single CardDeck object
    Card card1 = Card(CardColor.Kreuz, CardPicture.Neun);
    Card card2 = Card(CardColor.Pik, CardPicture.Koenig);
    Card card3 = Card(CardColor.Herz, CardPicture.Sieben);

    CardDeck deck = CardDeck(rand);
    deck.push(card1);
    deck.push(card2);
    deck.push(card3);

    print(deck);
  }

  static void testUnit_03_CardDeck() {
    Random rand = Random(1);

    // test frame for a single CardDeck object
    CardDeck deck = CardDeck(rand);
    deck.fill();
    print(deck);
    deck.shuffle();
    print(deck);
  }

  static void testUnit_04_CardSet() {
    // test frame for a single CardSet object
    Card card1 = new Card(CardColor.Kreuz, CardPicture.Neun);
    Card card2 = new Card(CardColor.Pik, CardPicture.Koenig);
    Card card3 = new Card(CardColor.Herz, CardPicture.Sieben);

    CardSet set = new CardSet();
    set.add(card1);
    set.add(card2);
    set.add(card3);

    for (int i = 0; i < set.Size; i++) {
      print("Karte ${i}: ${set[i]}");
    }

    print("Karten auf der Hand: ${set}");
    set.remove(1);
    print("Karten auf der Hand: ${set}");
  }

  static void testUnit_05_PlayTheGame() {
    List<String> names = ["Hans", "Sepp", "Ulli"];
    MauMaster master = new MauMaster(names);
    master.printVersion();
    master.reset();
    master.playGame();
  }

  // static void testUnit_10_EnvironmentVariables() {
  //   Map<String, String> env = Platform.environment;
  //   String value = env["DEBUG"];
  //   bool flag = (value == 'true') ? true : (value == 'false') ? false : false;
  //   print(flag);

  //   String result = String.fromEnvironment('DEBUG');
  //   print('result: >>>${result}<<<');

  //   if (const String.fromEnvironment('DEBUG') != null) {
  //     print('debug: Ahhhhh');
  //   }
  //   print('debug: Boooo');
  // }
}
