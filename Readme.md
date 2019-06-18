# Das Kartenspiel Mau Mau

Wir betrachten in dieser Aufgabe den bekannten Kartenspiel-Klassiker Mau Mau. Für das Spiel sind eine Reihe von Dart-Klassen zu entwickeln, die wir in den ersten Abschnitten zunächst unabhängig voneinander betrachten. Erst am Schluss der Aufgabe fügen wir diese Klassen zu einem Ganzen zusammen. Die Grundregeln des Spiels sind folgende:

*Spielvorbereitung*:

- An einem Kartentisch sitzen mehrere Kartenspieler zusammen. Auf dem Tisch liegt ein Stapel mit verdeckten Spielkarten. 

- Jeder Spieler erhält vor Spielbeginn fünf Karten. Dann wird eine Karte vom Stapel genommen und aufgedeckt. Während des Spiels gibt es also zwei Kartenstapel: Einen Stapel zum Ziehen von (verdeckten) Karten (Ziehstapel), einen zweiten Stapel zum Ablegen von (aufgedeckten) Karten (Ablagestapel). 

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

To be done.

## Klasse ``CardDeck``

To be done.

## Klasse ``CardSet``

To be done.

## Klasse ``Player``

To be done.

## Entwurf des Spielautomaten

Die Entwicklung des Spielverlaufs kann aufgrund der vielen Ausnahmen (welcher Spieler ist als Nächtes an der Reihe; wieviele Karten sind zu ziehen, etc.) durchaus unübersichtlich werden. Aus diesem Grunde verfolge ich in der Entwicklung die Konzeption eines endlichen Automaten, der den Spielablauf durchführt.


while (game.isActive) 
{
    game.nextTurn();
	game.nextPlayer();
}

// Data:

int nextPlayer = 1;
int siebenCounter = 2;
int nächsteFarbe;    // TODO: Festlegenm, wann die gesetzt wird

Methoden:

-- nextPlayer
-- nextTurn


-- nextTurn:

// pre-condition: nextPlayer zeigt auf aktuellen Spieler

if (KarteOnDeck = 7) {
        if (Spieler hat 7) {
            = Spieler legt 7 ab;
            = siebenCounter += 2;
        }
        else {
            = Spieler zieht siebenCounter Karten;
            = siebenCounter = 2;
        }
} else (habeFarbeOderFigur) {
    = --> Variable choosenColor kann aktiv sein
    = Lege eine Karte mit Farbe oder Figur ab;
    = --> Variable choosenColor clearen
} else {
    // Habe weder Farbe noch Figur
    if (habeEinenBuben) {
        = Lege Bube ab
        = Bestimme nächste Farbe (Color) --> Variable choosenColor gesetzt
    }
    else {
        = Ziehe Karte;
        = if (habeFarbeOderFigur) {
            --> Variable choosenColor kann aktiv sein
            = Gezogene Karte ablegen;
            = --> Variable choosenColor clearen
        }
    }
}


-- nextPlayer:

nextPlayer = suche nächsten aktiven Spieler;

if (KarteOnDeck = 8) {
    nextPlayer = suche nächsten aktiven Spieler;
}


// ==============

Folgende Methoden werden bei diesem Design gebraucht:

Card CardDeck::TopOfDeck
bool Player::hasSeven // Jepp
Card Player::playSeven // Jepp
void Player::drawCards(int number);   // Jepp
bool Player::hasColorOrPicture(CardColor color, CardPicture picture);   // Jepp
bool Player::hasBube   // Jepp
void Player::playBube  // Jepp
void Player::chooseColor    // Jepp
Card Player::drawCard   (die Karte vom Rückgabewert sollte mit den nächsten Methode gleich abgelegt werden)  // habe ich schon
void Player::playCard (Card card);
