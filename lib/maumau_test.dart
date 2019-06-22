import "dart:io";
import 'dart:math';

import 'card.dart';
import 'card_color.dart';
import 'card_deck.dart';
import 'card_picture.dart';
import 'card_set.dart';
import 'mau_master.dart';

class MauMauTest {
  static void test_01_Cards() {
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

  static void test_02_CardDeck() {
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

  static void test_03_CardDeck() {
    Random rand = Random(1);

    // test frame for a single CardDeck object
    CardDeck deck = CardDeck(rand);
    deck.fill();
    print(deck);
    deck.shuffle();
    print(deck);
  }

  static void test_04_CardSet() {
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

  static void test_05_PlayTheGame() {
    List<String> names = ["Hans", "Sepp", "Ulli"];
    MauMaster master = new MauMaster(names);
    master.printVersion();
    master.reset();
    master.playGame();
  }

  static void test_06_StressTestMauMaster() {
    MauMaster mm = new MauMaster(["Hans", "Sepp", "Ulli"]);
    mm.printVersion();

    int minRounds = 9223372036854775807;
    int minRoundsIndex = -1;
    int maxRounds = -1;
    int maxRoundsIndex = -1;

    for (int i = 1; i < 1000; i++) {
      mm.reset();
      mm.playGame();

      if (mm.Rounds < minRounds) {
        minRounds = mm.Rounds;
        minRoundsIndex = i;
      }

      if (mm.Rounds > maxRounds) {
        maxRounds = mm.Rounds;
        maxRoundsIndex = i;
      }

      print("Game at ${i}: ${mm.Rounds}");
    }

    print("Minumum number of rounds: ${minRounds} [Index ${minRoundsIndex}]");
    print("Maximum number of rounds: ${maxRounds} [Index ${maxRoundsIndex}]");
  }

  static void test_09_EnvironmentVariables() {
    Map<String, String> env = Platform.environment;
    String value = env["DEBUG"];
    bool flag = (value == 'true') ? true : false;
    print(flag);

    String result = String.fromEnvironment('DEBUG');
    print('result: >>>${result}<<<');

    if (const String.fromEnvironment('DEBUG') != null) {
      print('debug: found!');
    }
  }
}
