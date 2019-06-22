# Das Kartenspiel Mau Mau

Wir betrachten in dieser Aufgabe den bekannten Kartenspiele-Klassiker Mau Mau. Für das Spiel sind eine Reihe von Dart-Klassen zu entwickeln, die wir in den ersten Abschnitten zunächst unabhängig voneinander betrachten. Erst am Schluss der Aufgabe fügen wir diese Klassen zu einem Ganzen zusammen. Die Grundregeln des Spiels sind folgende:

*Spielvorbereitung*:

- An einem Kartentisch sitzen mehrere Kartenspieler zusammen. Auf dem Tisch liegt ein Stapel mit verdeckten Spielkarten. 

- Jeder Spieler erhält vor Spielbeginn fünf Karten. Dann wird eine Karte vom Stapel genommen und aufgedeckt. Während des Spiels gibt es also zwei Kartenstapel: Einen Stapel zum Ziehen von (verdeckten) Karten (Ziehstapel, engl. "drawing deck"), einen zweiten Stapel zum Ablegen von (aufgedeckten) Karten (Ablagestapel, engl. "playing deck"). 

*Spielverlauf*:

- Derjenige Spieler, der an der Reihe ist, legt eine seiner Karten offen auf den Ablagestapel. Die Karte, die der Spieler ablegen möchte, muss entweder die gleiche Farbe (Karo, Herz, Pik, Kreuz) oder das gleiche Bild (Sieben, Acht, Neun, Zehn, Dame, König, Ass) wie die zuletzt aufgedeckte Karte haben. Auf die Pik-10 darf also entweder eine andere Pik-Karte oder eine andere 10 gelegt werden. Kann ein Spieler keine Karte ablegen, muss er eine Karte vom Ziehstapel ziehen und warten, bis er erneut an der Reihe ist.

- Ist der Stapel mit den verdeckten Karten irgendwann aufgebraucht, so werden die abgelegten Karten, außer der obersten, gemischt und als neuer Stapel ausgelegt.

- Gewonnen hat, wer zuerst alle seine Karten abgelegt hat. Das Spiel wird mit den übrigen Spielern solange fortgesetzt, bis nur noch ein Spieler übrig bleibt.

*Karten mit besonderer Bedeutung*:

- Karte mit Bild Acht:

   Legt ein Spieler eine Acht auf die aufgedeckte Karte, dann muss der nächste Spieler einmal aussetzen. Bei zwei Spielern ist dann derjenige, der die Acht ausgelegt hat, erneut an der Reihe.

- Karte mit Bild Bube:

   Ein Bube kann grundsätzlich auf alle Karten gelegt werden. Legt ein Spieler einen Buben, darf er sich eine Farbe wünschen. Die nächste Karte, die auf den Buben gelegt wird, muss dann diese Farbe haben. Besitzt der nächste Spieler diese Farbe nicht, so muss er – wie gehabt – eine Karte ziehen.

- Karte mit Bild Sieben:

   Legt ein Spieler eine Sieben auf die aufgedeckte Karte, dann muss der nächste Spieler zwei Karten ziehen. Sollte er jedoch ebenfalls eine Sieben haben, dann kann er sie auf die bereits abgelegte Sieben legen und braucht keine Karten zu ziehen. Der nächste Spieler muss dann aber vier Karten ziehen, der übernächste 6 usw.

Mau-Mau kennt neben dem oben beschriebenen Standardregelwerk zahlreiche weitere Varianten, sie spielen für diese Aufgabe keine Rolle! Wir beschreiben nun im Folgenden eine mögliche Strukturierung der Aufgabenstellung an Hand des geschickten Entwurfs einiger zentraler Klassen detaillierter.

## Klasse ``Card``

Wir gehen als Erstes auf die Klasse ``Card`` ein. Jede Karte des Kartenspiels wird durch ein ``Card``-Objekt repräsentiert. Ein ``Card``-Objekt wird durch die Kartenfarbe und das Kartenbild eindeutig beschrieben. Zu diesem Zweck definieren wir zwei Aufzählungstypen ``CardColor`` und ``CardPicture``:

```dart
enum CardColor { Empty, Karo, Herz, Pik, Kreuz }
```

und 

```dart
enum CardPicture { Empty, Sieben, Acht, Neun, Zehn, Bube, Dame, Koenig, Ass }
```

Mit ihrer Hilfe können Sie nun die Klasse ``Card`` realisieren, entnehmen Sie weitere Hilfestellungen dazu Tabelle 1:

| Element | Schnittstelle und Beschreibung |
|:-|:-|
| Konstruktor | ``Card(CardColor color, CardPicture picture);``<br/> Der Konstruktor dient zum Erzeugen eines Kartenobjekts. Die beiden Parameter ``color`` und ``picture`` legen die Details der Karte fest.|
| *getter* ``Color`` | ``CardColor get Color`` <br/> Liefert die Farbe einer Spielkarte zurück.|
| *getter* ``Picture`` | ``CardPicture get Picture`` <br/> Liefert das Bild einer Spielkarte zurück.|
| *operator* ``==``| ``@override bool operator ==(Object other);`` <br/> Vergleicht zwei Karten auf Gleichheit. |

Tabelle 1. Zentrale Elemente der Klasse ``Card``.

Der ``==``-Operator ist Bestandteil des Dart-Objektmodells, er ist in der ultimativen Basisklasse ``Object`` definiert und in den abgeleiteten Klassen geeignet zu überschreiben. Dies gilt ebenfalls für die ``toString``-Methode: Überschreiben Sie diese Methode, um ein ``Card``-Objekt auf der Konsole ausgeben zu können.

*Testrahmen für Klasse* ``Card``:

```dart
static void testCards() {
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
```

*Ausgabe*:

```
Kreuz Neun
Pik Koenig
Farbe: CardColor.Kreuz
Bild:  CardPicture.Koenig
Die Karten sind verschieden
true
```

## Klasse ``CardDeck``

Auf dem Spieltisch liegen während eines Mau-Mau-Spiels zwei Kartenstapel: Einer zum Ziehen von Karten und ein zweiter zum Ablegen. Die Verwaltung eines solchen Kartenstapels obliegt der Klasse ``CardDeck``. Implementieren Sie – auf möglichst einfache Weise – die Klasse ``CardDeck`` mit den in Tabelle 2 beschriebenen Methoden.

Neben den üblichen Methoden ``push``, ``pop`` und ``isEmpty`` gibt es auch die *getter*-Methode ``TopOfStack``. Sie ist vor allem für den Stapel mit den abgelegten Karten relevant, da die Spieler stets sehen müssen, welche Karte als letztes abgelegt wurde und folglich als oberste Karte aufliegt. Für den Stapel zum Ziehen von Karten wäre ein Aufruf der ``TopOfStack``-Methode natürlich tabu.

| Element | Schnittstelle und Beschreibung |
|:-|:-|
| Konstruktor | ``CardDeck();``<br/> Legt ein leeres Kartenstapelobjekt an.|
| *getter* ``Size`` | ``int get Size`` <br/> Liefert die Anzahl der Karten des Stapels zurück.|
| *getter* ``IsEmpty`` | ``bool get IsEmpty`` <br/> Mit ``IsEmpty`` lässt sich feststellen, ob der Kartenstapel noch Karten enthält oder leer ist   .|
| *getter* ``TopOfDeck`` | ``Card get TopOfDeck`` <br/> Dient zum Betrachten der obersten Karte des Kartenstapels. Die Karte wird **nicht** vom Stapel entfernt!|
| Methode ``push``| ``void push(Card card);`` <br/> Dient zum Ablegen einer Karte ``card`` auf dem Kartenstapel. |
| Methode ``pop``| ``Card pop();`` <br/> Dient zum Abheben einer Karte vom Kartenstapel. |
| Methode ``fill``| ``void fill();`` <br/> Dient zum Vorbelegen des Stapels mit allen verfügbaren Karten. |
| Methode ``clear``| ``void clear();`` <br/> Dient zum Leeren des Stapel. |
| Methode ``shuffle``| ``void shuffle();`` <br/> Mit der Methode ``Shuffle`` lassen sich die Karten des Stapels mischen.|

Tabelle 2. Zentrale Elemente der Klasse ``CardDeck``.

Die ``toString``-Methode ist ebenfalls passend zu überschreiben, um ein ``CardDeck``-Objekt auf der Konsole ausgeben zu können.

*Frage*: Wie können man die Unterschiede zwischen einem Ablage- und einem Ziehstapel mit einem zentralen Feature der objektorientierten Programmierung exakt modellieren?

*Testrahmen für Klasse* ``CardDeck``:

```dart
static void testCardDeck() {
  Card card1 = Card(CardColor.Kreuz, CardPicture.Neun);
  Card card2 = Card(CardColor.Pik, CardPicture.Koenig);
  Card card3 = Card(CardColor.Herz, CardPicture.Sieben);

  CardDeck deck = CardDeck();
  deck.push(card1);
  deck.push(card2);
  deck.push(card3);
  print(deck);
}
```

*Ausgabe*:

```
1: Kreuz Neun
2: Pik Koenig
3: Herz Sieben
```

## Klasse ``CardSet``

Beim Spielen von Mau-Mau hält jeder Spieler eine bestimmte Menge von Spielkarten in der Hand. Die Klasse ``CardDeck`` ist dazu nicht geeignet. Möchte man beispielsweise eine Karte ablegen, kann man von einem Stapel nur die oberste Karte entfernen. Eine beliebige Karte innerhalb des Stapels kann nicht gezogen werden. Mit den Methoden der Klasse ``CardDeck`` ist dies nicht möglich, wir benötigen deshalb eine zweite Hilfsklasse ``CardSet``.

Eine Beschreibung der wichtigsten Methoden und Eigenschaften der Klasse ``CardSet`` finden Sie in Tabelle 3 vor:

| Element | Schnittstelle und Beschreibung |
|:-|:-|
| Konstruktor | ``CardSet();``<br/> Legt ein leeres ``CardSet``-Objekt an.|
| *getter* ``Size`` | ``int get Size`` <br/> Liefert die Anzahl der Karten in der Kartenmenge zurück.|
| *getter* ``IsEmpty`` | ``bool get IsEmpty`` <br/> Mit ``IsEmpty`` lässt sich feststellen, ob die Kartenmenge leer ist oder nicht.|
| *operator* ``[]``| ``operator [](int i);`` <br/> ``operator []=(int i, Card value);`` <br/> Ermöglicht den indizierten Zugriff auf eine Karte in der Kartenmenge (lesend und schreibend). Der überschriebene ``[]``-Operator ist vergleichbar mit dem so genannten *Indexer* aus der Programmiersprache C#.|
| Methode ``add``| ``void add(Card card);`` <br/> Fügt eine Karte ``card`` zur Kartenmenge hinzu. |
| Methode ``remove``| ``void remove(int index);`` <br/> Entfernt die Karte mit dem Index ``index`` aus der Kartenmenge. |
| Methode ``clear``| ``void clear();`` <br/> Entfernt alle Karten aus der Kartenmenge.|

Tabelle 3. Zentrale Elemente der Klasse ``CardSet``.

*Testrahmen für Klasse* ``CardDeck``:

```dart
static void testCardSet() {
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
```

*Ausgabe*:

```
Karte 0: Kreuz Neun
Karte 1: Pik Koenig
Karte 2: Herz Sieben
Karten auf der Hand: Kreuz Neun, Pik Koenig, Herz Sieben
Karten auf der Hand: Kreuz Neun, Herz Sieben
```

## Klasse ``Player``

Jeder Spieler von Mau-Mau *hat* einen Namen und *kennt* zwei Kartenstapel: Einen Stapel zum Ablegen der Karten und einen zweiten Stapel zum Ziehen von Karten – also zwei ``CardDeck``-Objekte. Ein Spieler hält eine bestimmte Menge von Karten in der Hand, er *hat* also ein ``CardSet``-Objekt. Die Methoden des Spielers, die in Tabelle 4 spezifiziert werden, sind auf die Logik des Mau-Mau-Spiels abgestimmt. Mit der Methode ``chooseAColor`` wird beispielsweise ein bestimmter Spieler gefragt, welche Farbe als nächstes für die abzulegenden Karten zu Grunde zu legen ist (wenn zuvor ein Bube abgelegt wurde).

| Element | Schnittstelle und Beschreibung |
|:-|:-|
| Konstruktor | ``Player(String name, CardDeck playing, CardDeck drawing);``<br/> Legt ein ``Player``-Objekt mit dem Namen des Spielers an. Zusätzlich werden Referenzen zweier ``CardDeck``-Objekte übergeben: Ein Kartenstapel zum Ablegen von Karten (Parameter ``playing``) und einer zum Ziehen (Parameter ``drawing``). |
| *getter* ``Name`` | ``String get Name`` <br/> Dient zum Lesen des Spielernamens. |
| *getter* ``NumberCards`` | ``int get NumberCards`` <br/> Liefert die Anzahl der Karten zurück, die ein Spieler in der Hand hält. |
| *getter* ``IsPlaying`` | ``bool get IsPlaying`` <br/> Zeigt an, ob der Spieler noch „im Spiel“ ist (*true*) oder bereits all seine Karten abgelegt hat (*false*).|
| *setter* ``IsPlaying`` | ``set IsPlaying(bool value)`` <br/> Dient zum Verändern des Spielstatus eines Spielers.|    
| Methode ``hasPicture``| ``bool hasPicture(CardPicture picture);`` <br/> Liefert ``true`` zurück, wenn der Spieler eine Karte mit dem Bild ``picture`` in seiner Hand hält, andernfalls  ``false``. |
| Methode ``playCard``| ``void playCard(Card card);`` <br/> Der Spieler legt eine Karte (Parameter ``card``) auf dem Stapel zum Ablegen der Karten ab. |
| Methode ``playPicture``| ``bool playPicture(CardPicture picture);`` <br/> Der Spieler legt eine Karte mit dem Bild ``picture`` ab. Vorzugsweise dient diese Methode zum Ablegen von '7'-er oder Bube-Karten.|
| Methode ``playColorOrPicture``| ``bool playColorOrPicture(CardColor requestedColor, CardPicture requestedPicture);`` <br/> Mit ``playColorOrPicture`` wird ein Spieler aufgefordert, eine Karte abzulegen. Die beiden Parameter ``requestedColor`` und ``requestedPicture`` spezifizieren die oberste Karte des Kartenstapels zum Ablegen. Die abzulegende Karte muss also entweder diese Farbe oder dieses Bild haben. Kann der Spieler keine Karte ablegen, verlässt er die Methode mit dem Rückgabewert ``false``, andernfalls mit ``true``. |
| Methode ``drawCards``| ``void drawCards(int number);`` <br/> Mit dem Aufruf dieser Methode zieht der Spieler die Anzahl von ``number`` Karten. Vorzugsweise muss ein Spieler diese Methode aufrufen, wenn sein Vorgänger im Spiel eine '7' abgelegt hat. |
| Methode ``drawCard``| ``Card drawCard();`` <br/> Mit dem Aufruf dieser Methode zieht der Spieler eine Karte.  |
| Methode ``chooseAColor``| ``CardColor chooseAColor();`` <br/>  Legt der Spieler eine Bube-Karte ab, darf er sich eine Farbe wünschen, die für den nächsten Spieler gilt. Es empfiehlt sich, eine Farbe zu wählen, von der der aktuelle Spieler ein oder mehrere Karten besitzt. |

Tabelle 4. Zentrale Elemente der Klasse ``Player``.

## Klasse ``MauMaster``

Ein ``MauMaster``-Objekt besitzt zwei Kartenstapel zum Ablegen und Ziehen und verwaltet mehrere Spieler. Das Kernstück der Klasse ``MauMaster`` ist die Methode ``playGame`` (Tabelle 5). Sie simuliert den kompletten Ablauf eines Mau-Mau-Spiels. Im einfachsten Fall wird die jeweils aufliegende Karte betrachtet und ihre Information an den aktuellen Spieler mit PlayCard weitergereicht. Kann ein Spieler keine Karte ablegen, wird er mit DrawCards zum Ziehen einer entsprechenden Anzahl von Karten aufgefordert. Die Spezialkarten Sieben, Acht und Bube sind von der Play-Methode ebenfalls zu behandeln.


| Element | Schnittstelle und Beschreibung |
|:-|:-|
| Konstruktor | ``MauMaster(List<String> names);``<br/> Legt ein ``MauMaster``-Objekt an. Die Namen der Spieler werden im Parameter ``names`` übergeben. Ferner verwaltet dieses Objekt alle (Unter-)Objekte, die zum Ablauf des Spiels erforderlich sind.|
| Methode ``playGame``| ``void playGame();`` <br/> Führt den kompletten Ablauf eines Mau-Mau-Spiels durch. *Tipp*: Implementieren Sie die Methode zunächst ohne Betrachtung der Sonderregeln für die drei Karten **Sieben**, **Acht** und **Bube**. Ergänzen Sie dann eine Sonderregel nach der anderen.|
| *getter* ``Rounds`` | ``int get Rounds`` <br/> Liefert die Anzahl der Runden des letzten Spiels zurück. |

Tabelle 4. Zentrale Elemente der Klasse ``MauMaster``.

## Die Spielidee als Pseudocode

Die Entwicklung des Spielverlaufs kann aufgrund der vielen Ausnahmen (welcher Spieler ist als Nächtes an der Reihe; wieviele Karten sind zu ziehen; welche Spieler sind noch mit von der Partie, etc.) durchaus unübersichtlich werden. Im Folgenden skizzieren wir einige Codefragmente (in Pseudocode-Notation), die die Realisierung der Klasse ``MauMaster`` veranschaulichen sollen.

Der zentrale Spielablauf könnte in einer while-Kontrollstruktur eingebettet werden:

```
MauMaster game;
while (game.isActive)
{
  game._nextTurn();
  game._nextPlayer();
}
```

Die Methode ``_nextTurn`` behandelt die Aktionen des Spielers, der gerade am Zug ist. Mit der ``_nextPlayer``-Methode wird der nächste Spieler ermittelt. Wir betrachten zunächst den Pseudo-Code der Methode ``_nextTurn``:

```
if (karteOnDeck = 7) {
  if (aktuellerSpieler hat 7) {
    = aktuellerSpieler legt 7 ab;
    = siebenCounter += 2;
  }
  else {
    = aktuellerSpieler zieht siebenCounter Karten;
    = siebenCounter = 2;
  }
} else (aktuellerSpieler hat Farbe oder Figur bzgl. karteOnDeck) {
    = aktuellerSpieler legt Karte mit Farbe oder Figur ab;
} else if (aktuellerSpieler hat Bube) {
    = aktuellerSpieler legt Bube ab;
    = aktuellerSpieler legt nächste Farbe fest;
} else {
    = aktuellerSpieler zieht Karte;
    = if (gezogeneKarte = Bube) {
        = Bube ablegen;
        = aktuellerSpieler legt nächste Farbe fest;
      } else if (gezogeneKarte stimmt in Farbe oder Figur mit karteOnDeck überein) {
        = Karte ablegen
      }
}
```

In dieser Methode sind einige (Instanz-)Variablen zum Einsatz gekommen wie etwa 

```
int aktuellerSpieler;   // Beschreibung des aktuellen Spielers 
int siebenCounter = 2;  // zählt mit, wieviele 7-er Karten abzulegen sind
Card karteOnDeck;       // oberste Karte des Ziehstabels
```

Pseudo-Code der Methode ``nextPlayer``:

```
aktuellerSpieler = nächster noch aktiver Spieler;
if (karteOnDeck = 8) {
    aktuellerSpieler = nächster noch aktiver Spieler;
}
```

## Der Programmablauf

Das folgende Beispiel demonstriert, wie der Ablauf Ihres Programms aussehen könnte. Es sind für alle zentralen Aktionen wie Karte ziehen oder ablegen entsprechende Ausgaben zu machen. An Hand der Ausgaben muss die Einhaltung der Spielregeln von Mau-Mau nachvollziehbar sein:

```
-------------------------------------------------------------
Simple Mau-Mau Cards Game (Version 1.00)
-------------------------------------------------------------
>   Hans draws Herz Dame from drawing deck!
>   Hans draws Herz Koenig from drawing deck!
>   Hans draws Karo Dame from drawing deck!
>   Hans draws Herz Ass from drawing deck!
>   Hans draws Kreuz Zehn from drawing deck!
>   Sepp draws Pik Sieben from drawing deck!
>   Sepp draws Kreuz Dame from drawing deck!
>   Sepp draws Pik Zehn from drawing deck!
>   Sepp draws Karo Acht from drawing deck!
>   Sepp draws Pik Acht from drawing deck!
>   Ulli draws Kreuz Sieben from drawing deck!
>   Ulli draws Herz Sieben from drawing deck!
>   Ulli draws Herz Bube from drawing deck!
>   Ulli draws Herz Zehn from drawing deck!
>   Ulli draws Pik Bube from drawing deck!
-------------------------------------------------------------
Topmost card: Kreuz Acht
-------------------------------------------------------------
--> Hans [X]: Herz Dame, Herz Koenig, Karo Dame, Herz Ass, Kreuz Zehn
    Sepp [X]: Pik Sieben, Kreuz Dame, Pik Zehn, Karo Acht, Pik Acht
    Ulli [X]: Kreuz Sieben, Herz Sieben, Herz Bube, Herz Zehn, Pik Bube
-------------------------------------------------------------
>   Hans plays Kreuz Zehn
-------------------------------------------------------------
Topmost card: Kreuz Zehn
-------------------------------------------------------------
    Hans [X]: Herz Dame, Herz Koenig, Karo Dame, Herz Ass
--> Sepp [X]: Pik Sieben, Kreuz Dame, Pik Zehn, Karo Acht, Pik Acht
    Ulli [X]: Kreuz Sieben, Herz Sieben, Herz Bube, Herz Zehn, Pik Bube
-------------------------------------------------------------
>   Sepp plays Kreuz Dame
-------------------------------------------------------------
Topmost card: Kreuz Dame
-------------------------------------------------------------
    Hans [X]: Herz Dame, Herz Koenig, Karo Dame, Herz Ass
    Sepp [X]: Pik Sieben, Pik Zehn, Karo Acht, Pik Acht
--> Ulli [X]: Kreuz Sieben, Herz Sieben, Herz Bube, Herz Zehn, Pik Bube
-------------------------------------------------------------
>   Ulli plays Kreuz Sieben
-------------------------------------------------------------
Topmost card: Kreuz Sieben
-------------------------------------------------------------
--> Hans [X]: Herz Dame, Herz Koenig, Karo Dame, Herz Ass
    Sepp [X]: Pik Sieben, Pik Zehn, Karo Acht, Pik Acht
    Ulli [X]: Herz Sieben, Herz Bube, Herz Zehn, Pik Bube
-------------------------------------------------------------
>   Hans draws Karo Zehn from drawing deck!
>   Hans draws Kreuz Bube from drawing deck!
-------------------------------------------------------------
Topmost card: Kreuz Sieben
-------------------------------------------------------------
    Hans [X]: Herz Dame, Herz Koenig, Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube
--> Sepp [X]: Pik Sieben, Pik Zehn, Karo Acht, Pik Acht
    Ulli [X]: Herz Sieben, Herz Bube, Herz Zehn, Pik Bube
-------------------------------------------------------------
>   Sepp plays Pik Sieben
-------------------------------------------------------------
Topmost card: Pik Sieben
-------------------------------------------------------------
    Hans [X]: Herz Dame, Herz Koenig, Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube
    Sepp [X]: Pik Zehn, Karo Acht, Pik Acht
--> Ulli [X]: Herz Sieben, Herz Bube, Herz Zehn, Pik Bube
-------------------------------------------------------------
>   Ulli plays Herz Sieben
-------------------------------------------------------------
Topmost card: Herz Sieben
-------------------------------------------------------------
--> Hans [X]: Herz Dame, Herz Koenig, Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube
    Sepp [X]: Pik Zehn, Karo Acht, Pik Acht
    Ulli [X]: Herz Bube, Herz Zehn, Pik Bube
-------------------------------------------------------------
>   Hans draws Kreuz Koenig from drawing deck!
>   Hans draws Pik Koenig from drawing deck!
>   Hans draws Pik Dame from drawing deck!
>   Hans draws Herz Acht from drawing deck!
-------------------------------------------------------------
Topmost card: Herz Sieben
-------------------------------------------------------------
    Hans [X]: Herz Dame, Herz Koenig, Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Koenig, Pik Dame, Herz Acht
--> Sepp [X]: Pik Zehn, Karo Acht, Pik Acht
    Ulli [X]: Herz Bube, Herz Zehn, Pik Bube
-------------------------------------------------------------
>   Sepp draws Kreuz Ass from drawing deck!
-------------------------------------------------------------
Topmost card: Herz Sieben
-------------------------------------------------------------
    Hans [X]: Herz Dame, Herz Koenig, Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Koenig, Pik Dame, Herz Acht
    Sepp [X]: Pik Zehn, Karo Acht, Pik Acht, Kreuz Ass
--> Ulli [X]: Herz Bube, Herz Zehn, Pik Bube
-------------------------------------------------------------
>   Ulli draws Karo Bube from drawing deck!
>   Ulli draws Pik Ass from drawing deck!
-------------------------------------------------------------
Topmost card: Herz Sieben
-------------------------------------------------------------
--> Hans [X]: Herz Dame, Herz Koenig, Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Koenig, Pik Dame, Herz Acht
    Sepp [X]: Pik Zehn, Karo Acht, Pik Acht, Kreuz Ass
    Ulli [X]: Herz Bube, Herz Zehn, Pik Bube, Karo Bube, Pik Ass
-------------------------------------------------------------
>   Hans plays Herz Dame
-------------------------------------------------------------
Topmost card: Herz Dame
-------------------------------------------------------------
    Hans [X]: Herz Koenig, Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Koenig, Pik Dame, Herz Acht
--> Sepp [X]: Pik Zehn, Karo Acht, Pik Acht, Kreuz Ass
    Ulli [X]: Herz Bube, Herz Zehn, Pik Bube, Karo Bube, Pik Ass
-------------------------------------------------------------
>   Sepp draws Karo Koenig from drawing deck!
-------------------------------------------------------------
Topmost card: Herz Dame
-------------------------------------------------------------
    Hans [X]: Herz Koenig, Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Koenig, Pik Dame, Herz Acht
    Sepp [X]: Pik Zehn, Karo Acht, Pik Acht, Kreuz Ass, Karo Koenig
--> Ulli [X]: Herz Bube, Herz Zehn, Pik Bube, Karo Bube, Pik Ass
-------------------------------------------------------------
>   Ulli plays Herz Zehn
-------------------------------------------------------------
Topmost card: Herz Zehn
-------------------------------------------------------------
--> Hans [X]: Herz Koenig, Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Koenig, Pik Dame, Herz Acht
    Sepp [X]: Pik Zehn, Karo Acht, Pik Acht, Kreuz Ass, Karo Koenig
    Ulli [X]: Herz Bube, Pik Bube, Karo Bube, Pik Ass
-------------------------------------------------------------
>   Hans plays Herz Koenig
-------------------------------------------------------------
Topmost card: Herz Koenig
-------------------------------------------------------------
    Hans [X]: Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Koenig, Pik Dame, Herz Acht
--> Sepp [X]: Pik Zehn, Karo Acht, Pik Acht, Kreuz Ass, Karo Koenig
    Ulli [X]: Herz Bube, Pik Bube, Karo Bube, Pik Ass
-------------------------------------------------------------
>   Sepp plays Karo Koenig
-------------------------------------------------------------
Topmost card: Karo Koenig
-------------------------------------------------------------
    Hans [X]: Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Koenig, Pik Dame, Herz Acht
    Sepp [X]: Pik Zehn, Karo Acht, Pik Acht, Kreuz Ass
--> Ulli [X]: Herz Bube, Pik Bube, Karo Bube, Pik Ass
-------------------------------------------------------------
>   Ulli plays Herz Bube
>   Ulli has choosen color Pik
-------------------------------------------------------------
Topmost card: Herz Bube
-------------------------------------------------------------
--> Hans [X]: Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Koenig, Pik Dame, Herz Acht
    Sepp [X]: Pik Zehn, Karo Acht, Pik Acht, Kreuz Ass
    Ulli [X]: Pik Bube, Karo Bube, Pik Ass
-------------------------------------------------------------
>   Hans plays Pik Koenig
-------------------------------------------------------------
Topmost card: Pik Koenig
-------------------------------------------------------------
    Hans [X]: Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Dame, Herz Acht
--> Sepp [X]: Pik Zehn, Karo Acht, Pik Acht, Kreuz Ass
    Ulli [X]: Pik Bube, Karo Bube, Pik Ass
-------------------------------------------------------------
>   Sepp plays Pik Zehn
-------------------------------------------------------------
Topmost card: Pik Zehn
-------------------------------------------------------------
    Hans [X]: Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Dame, Herz Acht
    Sepp [X]: Karo Acht, Pik Acht, Kreuz Ass
--> Ulli [X]: Pik Bube, Karo Bube, Pik Ass
-------------------------------------------------------------
>   Ulli plays Pik Ass
-------------------------------------------------------------
Topmost card: Pik Ass
-------------------------------------------------------------
--> Hans [X]: Karo Dame, Herz Ass, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Dame, Herz Acht
    Sepp [X]: Karo Acht, Pik Acht, Kreuz Ass
    Ulli [X]: Pik Bube, Karo Bube
-------------------------------------------------------------
>   Hans plays Herz Ass
-------------------------------------------------------------
Topmost card: Herz Ass
-------------------------------------------------------------
    Hans [X]: Karo Dame, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Dame, Herz Acht
--> Sepp [X]: Karo Acht, Pik Acht, Kreuz Ass
    Ulli [X]: Pik Bube, Karo Bube
-------------------------------------------------------------
>   Sepp plays Kreuz Ass
-------------------------------------------------------------
Topmost card: Kreuz Ass
-------------------------------------------------------------
    Hans [X]: Karo Dame, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Dame, Herz Acht
    Sepp [X]: Karo Acht, Pik Acht
--> Ulli [X]: Pik Bube, Karo Bube
-------------------------------------------------------------
>   Ulli plays Pik Bube
==> Ulli says 'Mau'
>   Ulli has choosen color Karo
-------------------------------------------------------------
Topmost card: Pik Bube
-------------------------------------------------------------
--> Hans [X]: Karo Dame, Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Dame, Herz Acht
    Sepp [X]: Karo Acht, Pik Acht
    Ulli [X]: Karo Bube
-------------------------------------------------------------
>   Hans plays Karo Dame
-------------------------------------------------------------
Topmost card: Karo Dame
-------------------------------------------------------------
    Hans [X]: Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Dame, Herz Acht
--> Sepp [X]: Karo Acht, Pik Acht
    Ulli [X]: Karo Bube
-------------------------------------------------------------
>   Sepp plays Karo Acht
==> Sepp says 'Mau'
-------------------------------------------------------------
'8' is on top of deck - skip next player
-------------------------------------------------------------
Topmost card: Karo Acht
-------------------------------------------------------------
--> Hans [X]: Karo Zehn, Kreuz Bube, Kreuz Koenig, Pik Dame, Herz Acht
    Sepp [X]: Pik Acht
    Ulli [X]: Karo Bube
-------------------------------------------------------------
>   Hans plays Karo Zehn
-------------------------------------------------------------
Topmost card: Karo Zehn
-------------------------------------------------------------
    Hans [X]: Kreuz Bube, Kreuz Koenig, Pik Dame, Herz Acht
--> Sepp [X]: Pik Acht
    Ulli [X]: Karo Bube
-------------------------------------------------------------
>   Sepp draws Herz Neun from drawing deck!
-------------------------------------------------------------
Topmost card: Karo Zehn
-------------------------------------------------------------
    Hans [X]: Kreuz Bube, Kreuz Koenig, Pik Dame, Herz Acht
    Sepp [X]: Pik Acht, Herz Neun
--> Ulli [X]: Karo Bube
-------------------------------------------------------------
>   Ulli plays Karo Bube
>   Ulli says 'Mau-Mau', leaving game !
>   Ulli has choosen color Herz
-------------------------------------------------------------
Topmost card: Karo Bube
-------------------------------------------------------------
--> Hans [X]: Kreuz Bube, Kreuz Koenig, Pik Dame, Herz Acht
    Sepp [X]: Pik Acht, Herz Neun
    Ulli [-]
-------------------------------------------------------------
>   Hans plays Herz Acht
-------------------------------------------------------------
'8' is on top of deck - skip next player
-------------------------------------------------------------
Topmost card: Herz Acht
-------------------------------------------------------------
--> Hans [X]: Kreuz Bube, Kreuz Koenig, Pik Dame
    Sepp [X]: Pik Acht, Herz Neun
    Ulli [-]
-------------------------------------------------------------
>   Hans plays Kreuz Bube
>   Hans has choosen color Kreuz
-------------------------------------------------------------
Topmost card: Kreuz Bube
-------------------------------------------------------------
    Hans [X]: Kreuz Koenig, Pik Dame
--> Sepp [X]: Pik Acht, Herz Neun
    Ulli [-]
-------------------------------------------------------------
>   Sepp draws Karo Ass from drawing deck!
-------------------------------------------------------------
Topmost card: Kreuz Bube
-------------------------------------------------------------
--> Hans [X]: Kreuz Koenig, Pik Dame
    Sepp [X]: Pik Acht, Herz Neun, Karo Ass
    Ulli [-]
-------------------------------------------------------------
>   Hans plays Kreuz Koenig
==> Hans says 'Mau'
-------------------------------------------------------------
Topmost card: Kreuz Koenig
-------------------------------------------------------------
    Hans [X]: Pik Dame
--> Sepp [X]: Pik Acht, Herz Neun, Karo Ass
    Ulli [-]
-------------------------------------------------------------
>   Sepp draws Kreuz Neun from drawing deck!
>   Sepp plays Kreuz Neun
-------------------------------------------------------------
Topmost card: Kreuz Neun
-------------------------------------------------------------
--> Hans [X]: Pik Dame
    Sepp [X]: Pik Acht, Herz Neun, Karo Ass
    Ulli [-]
-------------------------------------------------------------
>   Hans draws Karo Neun from drawing deck!
>   Hans plays Karo Neun
==> Hans says 'Mau'
-------------------------------------------------------------
Topmost card: Karo Neun
-------------------------------------------------------------
    Hans [X]: Pik Dame
--> Sepp [X]: Pik Acht, Herz Neun, Karo Ass
    Ulli [-]
-------------------------------------------------------------
>   Sepp plays Herz Neun
-------------------------------------------------------------
Topmost card: Herz Neun
-------------------------------------------------------------
--> Hans [X]: Pik Dame
    Sepp [X]: Pik Acht, Karo Ass
    Ulli [-]
-------------------------------------------------------------
>   Hans draws Pik Neun from drawing deck!
>   Hans plays Pik Neun
==> Hans says 'Mau'
-------------------------------------------------------------
Topmost card: Pik Neun
-------------------------------------------------------------
    Hans [X]: Pik Dame
--> Sepp [X]: Pik Acht, Karo Ass
    Ulli [-]
-------------------------------------------------------------
>   Sepp plays Pik Acht
==> Sepp says 'Mau'
-------------------------------------------------------------
'8' is on top of deck - skip next player
-------------------------------------------------------------
Topmost card: Pik Acht
-------------------------------------------------------------
    Hans [X]: Pik Dame
--> Sepp [X]: Karo Ass
    Ulli [-]
-------------------------------------------------------------
>   Sepp draws Karo Sieben from drawing deck!
-------------------------------------------------------------
'8' is on top of deck - skip next player
-------------------------------------------------------------
Topmost card: Pik Acht
-------------------------------------------------------------
    Hans [X]: Pik Dame
--> Sepp [X]: Karo Ass, Karo Sieben
    Ulli [-]
-------------------------------------------------------------
>   turn over playing deck to serve as new drawing deck
>   Sepp draws Kreuz Sieben from drawing deck!
-------------------------------------------------------------
'8' is on top of deck - skip next player
-------------------------------------------------------------
Topmost card: Pik Acht
-------------------------------------------------------------
    Hans [X]: Pik Dame
--> Sepp [X]: Karo Ass, Karo Sieben, Kreuz Sieben
    Ulli [-]
-------------------------------------------------------------
>   Sepp draws Karo Acht from drawing deck!
>   Sepp plays Karo Acht
-------------------------------------------------------------
'8' is on top of deck - skip next player
-------------------------------------------------------------
Topmost card: Karo Acht
-------------------------------------------------------------
    Hans [X]: Pik Dame
--> Sepp [X]: Karo Ass, Karo Sieben, Kreuz Sieben
    Ulli [-]
-------------------------------------------------------------
>   Sepp plays Karo Ass
-------------------------------------------------------------
Topmost card: Karo Ass
-------------------------------------------------------------
--> Hans [X]: Pik Dame
    Sepp [X]: Karo Sieben, Kreuz Sieben
    Ulli [-]
-------------------------------------------------------------
>   Hans draws Kreuz Bube from drawing deck!
>   Hans plays Kreuz Bube
==> Hans says 'Mau'
>   Hans has choosen color Pik
-------------------------------------------------------------
Topmost card: Kreuz Bube
-------------------------------------------------------------
    Hans [X]: Pik Dame
--> Sepp [X]: Karo Sieben, Kreuz Sieben
    Ulli [-]
-------------------------------------------------------------
>   Sepp draws Herz Koenig from drawing deck!
-------------------------------------------------------------
Topmost card: Kreuz Bube
-------------------------------------------------------------
--> Hans [X]: Pik Dame
    Sepp [X]: Karo Sieben, Kreuz Sieben, Herz Koenig
    Ulli [-]
-------------------------------------------------------------
>   Hans plays Pik Dame
>   Hans says 'Mau-Mau', leaving game !
Sepp has lost --- Game over [42]
```
