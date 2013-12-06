import 'dart:html';
import 'dart:math';

//This Program needs blackjack.css and blackjack.html and runs best using Dart's Chromium
//Hit Refresh if you want to play again

class Card
{
  //Every card has a value such as 1-11
  int value;
  //Card's face represents if its a 1-10,Jack,Queen,King or Ace
  String face;
  //Card's suit represents if its a Diamond, Club, Spade or Heart
  String suit;
  
  setValue (int num)
  {
    this.value = num;
  }
  
  setFace (String face)
  {
    this.face = face;
  }
  
  setSuit (String suit)
  {
    this.suit = suit;
  }
}

class Deck
{
  //A list of 52 cards for the deck
  var cards = new List<Card>(52);
 
  //Deck constructor
  Deck ()
  {
    //Set the deck and add the correct cards in
    for (int i = 0; i < 13; i++)
    {
      cards[i] = new Card();
      cards[i].setSuit("Heart");
      
      if (i < 9)
      {
        cards[i].setValue(i + 2);
        cards[i].setFace((i + 2).toString());
      }
      else if (i > 8 && i < 12)
      {
        cards[i].setValue(10);
        
        if (i == 9)
        {
          cards[i].setFace("Jack");
        }
        else if (i == 10)
        {
          cards[i].setFace("Queen");
        }
        else
        {
          cards[i].setFace("King");
        }
      }
      else
      {
        cards[i].setValue(11);
        cards[i].setFace("Ace");
      }
    }
    
    for (int i = 13; i < 26; i++)
    {
      cards[i] = new Card();
      cards[i].setSuit("Spade");
      
      if (i < 22)
      {
        cards[i].setValue(i - 11);
        cards[i].setFace((i - 11).toString());
      }
      else if (i > 21 && i < 25)
      {
        cards[i].setValue(10);
        if (i == 22)
        {
          cards[i].setFace("Jack");
        }
        else if (i == 23)
        {
          cards[i].setFace("Queen");
        }
        else
        {
          cards[i].setFace("King");
        }
      }
      else
      {
        cards[i].setValue(11);
        cards[i].setFace("Ace");
      }
    }
    
    for (int i = 26; i < 39; i++)
    {
      cards[i] = new Card();
      cards[i].setSuit("Diamond");
      
      if (i < 35)
      {
        cards[i].setValue(i - 24);
        cards[i].setFace((i - 24).toString());
      }
      else if (i > 34 && i < 38)
      {
        cards[i].setValue(10);
        if (i == 35)
        {
          cards[i].setFace("Jack");
        }
        else if (i == 36)
        {
          cards[i].setFace("Queen");
        }
        else
        {
          cards[i].setFace("King");
        }
      }
      else
      {
        cards[i].setValue(11);
        cards[i].setFace("Ace");
      }
    }
    
    for (int i = 39; i < 52; i++)
    {
      cards[i] = new Card();
      cards[i].setSuit("Club");
      
      if (i < 48)
      {
        cards[i].setValue(i - 37);
        cards[i].setFace((i - 37).toString());
      }
      else if (i > 47 && i < 51)
      {
        cards[i].setValue(10);
        if (i == 48)
        {
          cards[i].setFace("Jack");
        }
        else if (i == 49)
        {
          cards[i].setFace("Queen");
        }
        else
        {
          cards[i].setFace("King");
        }
      }
      else
      {
        cards[i].setValue(11);
        cards[i].setFace("Ace");
      }
    }
  }

  shuffle()
  {
    var rand = new Random();
    int num;
    Card temp;
    
    for (int i = 0; i < cards.length; i++)
    {
      num = rand.nextInt(cards.length);
      temp = cards[i];
      cards[i] = cards[num];
      cards[num] = temp;
    }
  }
  
  printOut()
  {
    for (int i = 0; i < cards.length; i++)
    {
      print (cards[i].suit + " " + cards[i].face);
    }
  }
}

void main() 
{
  Deck deck = new Deck();
  deck.shuffle();
  String cards;
  //total = hand number
  int total = 0;
  //num = where in the Deck list we are in
  int num = 1;
  
  //User's hand he/she starts with
  var hand = new List<Card>();
  hand.add(deck.cards[0]);
  hand.add(deck.cards[1]);
  
  cards = "You have a " + hand[0].suit + " of " + hand[0].face + ", a " + hand[1].suit + " of " + hand[1].face;
  
  query("#Cards").text = cards;
  
  total = figureOutTotal(hand);
  
  query("#Total").text = total.toString();
  
  //This query simply adds another card to the Hand list from Deck using num and adds the total value of the cards
  query("#Hit")
    ..text = "Hit"
    ..onClick.listen((hitMe)
        {
          if (query("#Hit").text == "Hit")
          {
            num = num + 1;
            hand.add(deck.cards[num]);
            total = figureOutTotal(hand);
          
            cards = cards + ", a " +  hand[num].suit + " of " + hand[num].face;
          
            query("#Cards").text = cards;
            query("#Total").text = total.toString();
          
            if (total > 21)
            {
              query("#Hit").text = "BUST!!";
              query("#Stay").text = "You LOSE";
            }
            else if (total == 21)
            {
              query("#Hit").text = "BLACKJACK!!";
              query("#Stay").text = "You WIN";
            }
              
          }
        });
  
  //This query ends the game, so the user can decide when to stop so he/she won't bust
  query("#Stay")
    ..text = "Stay"
    ..onClick.listen((endGame)
        {
          if (query("#Stay").text == "Stay")
          {
            query("#Hit").text = "Game Over";
      
            if (total != 21)
            {
              query("#Stay").text = "You didn't get 21!";
            }
          }
        });
  
  //If the first two cards are already 21 You win!
  if (total == 21)
  {    
    query("#Hit").text = "BLACKJACK!!";
    query("#Stay").text = "You WIN";
  }
}

int figureOutTotal(List<Card> hand)
{
  //All the math for figuring out the total
  int total = 0;
  //Keep track of how many Aces there are
  int num = 0;
  
  for (int i = 0; i < hand.length; i++)
  {
    if (hand[i].value < 11)
    {
      total = total + hand[i].value;
    }
    else
    {
      num = num + 1;
    }
  }
  
  //Calculate total dependent on how many Aces there because 2 or more Aces should be counted as 2, not 22
  for (int x = 0; x < hand.length; x++)
  {
    if (hand[x].value == 11)
    {
      num = num - 1;
      
      if ((hand[x].value + total >= 21) && num != 0)
      {
        total = total + 1;
      }
      else if ((hand[x].value + total == 21) && num == 0)
      {
        total = total + 11;
      }
      else if ((hand[x].value + total < 21) && num == 0)
      {
        total = total + 11;
      }
      else if (num > 0)
      {
        total = total + 1;
      }
      else
      {
        total = total + 1;
      }
    }
  }
  
  return total;
}
