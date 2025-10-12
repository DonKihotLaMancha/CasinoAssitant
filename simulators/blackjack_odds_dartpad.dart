import 'dart:math';

/// Represents a playing card
class Card {
  final String rank;
  final String suit;

  Card(this.rank, this.suit);

  /// Get the blackjack value of the card
  int getValue() {
    if (rank == 'A') return 11;
    if (['K', 'Q', 'J'].contains(rank)) return 10;
    return int.parse(rank);
  }

  @override
  String toString() => '$rank$suit';
}

/// Represents a deck of cards
class Deck {
  final List<Card> cards = [];
  final Random random = Random();

  Deck({int numDecks = 1}) {
    final suits = ['♠', '♥', '♦', '♣'];
    final ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];

    for (int i = 0; i < numDecks; i++) {
      for (var suit in suits) {
        for (var rank in ranks) {
          cards.add(Card(rank, suit));
        }
      }
    }
  }

  void shuffle() {
    cards.shuffle(random);
  }

  Card draw() {
    if (cards.isEmpty) throw Exception('Deck is empty');
    return cards.removeLast();
  }

  bool get isEmpty => cards.isEmpty;
}

/// Represents a hand in blackjack
class Hand {
  final List<Card> cards = [];

  void addCard(Card card) {
    cards.add(card);
  }

  /// Calculate the best value for the hand (handling aces)
  int getValue() {
    int value = 0;
    int aces = 0;

    for (var card in cards) {
      value += card.getValue();
      if (card.rank == 'A') aces++;
    }

    // Adjust for aces
    while (value > 21 && aces > 0) {
      value -= 10;
      aces--;
    }

    return value;
  }

  bool get isBusted => getValue() > 21;
  bool get isBlackjack => cards.length == 2 && getValue() == 21;

  @override
  String toString() => cards.map((c) => c.toString()).join(' ') + ' (${getValue()})';
}

/// Blackjack game simulator
class BlackjackSimulator {
  final int numDecks;
  final Random random = Random();

  BlackjackSimulator({this.numDecks = 6});

  /// Simulate a single hand of blackjack
  GameResult playHand({bool useBasicStrategy = true}) {
    final deck = Deck(numDecks: numDecks);
    deck.shuffle();

    final playerHand = Hand();
    final dealerHand = Hand();

    // Initial deal
    playerHand.addCard(deck.draw());
    dealerHand.addCard(deck.draw());
    playerHand.addCard(deck.draw());
    dealerHand.addCard(deck.draw());

    // Check for blackjacks
    if (playerHand.isBlackjack && dealerHand.isBlackjack) {
      return GameResult.push;
    }
    if (playerHand.isBlackjack) {
      return GameResult.playerBlackjack;
    }
    if (dealerHand.isBlackjack) {
      return GameResult.dealerBlackjack;
    }

    // Player's turn
    if (useBasicStrategy) {
      _playBasicStrategy(playerHand, dealerHand.cards[0], deck);
    } else {
      _playSimpleStrategy(playerHand, deck);
    }

    if (playerHand.isBusted) {
      return GameResult.playerBust;
    }

    // Dealer's turn
    while (dealerHand.getValue() < 17) {
      dealerHand.addCard(deck.draw());
    }

    if (dealerHand.isBusted) {
      return GameResult.dealerBust;
    }

    // Compare hands
    final playerValue = playerHand.getValue();
    final dealerValue = dealerHand.getValue();

    if (playerValue > dealerValue) {
      return GameResult.playerWin;
    } else if (playerValue < dealerValue) {
      return GameResult.dealerWin;
    } else {
      return GameResult.push;
    }
  }

  /// Simple strategy: hit until 17 or higher
  void _playSimpleStrategy(Hand hand, Deck deck) {
    while (hand.getValue() < 17) {
      hand.addCard(deck.draw());
    }
  }

  /// Basic blackjack strategy (simplified)
  void _playBasicStrategy(Hand hand, Card dealerUpCard, Deck deck) {
    final dealerValue = dealerUpCard.getValue();
    
    while (!hand.isBusted) {
      final handValue = hand.getValue();
      final hasAce = hand.cards.any((c) => c.rank == 'A') && handValue <= 21;

      bool shouldHit = false;

      if (hasAce && handValue < 19) {
        // Soft hand strategy (simplified)
        shouldHit = true;
      } else if (handValue < 12) {
        shouldHit = true;
      } else if (handValue == 12) {
        shouldHit = dealerValue >= 2 && dealerValue <= 3 || dealerValue >= 7;
      } else if (handValue >= 13 && handValue <= 16) {
        shouldHit = dealerValue >= 7;
      } else {
        shouldHit = false; // Stand on 17+
      }

      if (shouldHit) {
        hand.addCard(deck.draw());
      } else {
        break;
      }
    }
  }

  /// Run multiple simulations and calculate odds
  SimulationResults runSimulations(int numSimulations, {bool useBasicStrategy = true}) {
    final results = <GameResult, int>{};
    
    for (int i = 0; i < numSimulations; i++) {
      final result = playHand(useBasicStrategy: useBasicStrategy);
      results[result] = (results[result] ?? 0) + 1;
    }

    return SimulationResults(results, numSimulations);
  }
}

/// Game result enum
enum GameResult {
  playerWin,
  playerBlackjack,
  dealerWin,
  dealerBlackjack,
  playerBust,
  dealerBust,
  push,
}

/// Simulation results
class SimulationResults {
  final Map<GameResult, int> results;
  final int totalGames;

  SimulationResults(this.results, this.totalGames);

  int get playerWins =>
      (results[GameResult.playerWin] ?? 0) +
      (results[GameResult.playerBlackjack] ?? 0) +
      (results[GameResult.dealerBust] ?? 0);

  int get dealerWins =>
      (results[GameResult.dealerWin] ?? 0) +
      (results[GameResult.dealerBlackjack] ?? 0) +
      (results[GameResult.playerBust] ?? 0);

  int get pushes => results[GameResult.push] ?? 0;

  double get playerWinRate => (playerWins / totalGames) * 100;
  double get dealerWinRate => (dealerWins / totalGames) * 100;
  double get pushRate => (pushes / totalGames) * 100;

  /// Calculate expected return (considering blackjack pays 3:2)
  double get expectedReturn {
    double totalReturn = 0;
    
    totalReturn += (results[GameResult.playerWin] ?? 0) * 1.0;
    totalReturn += (results[GameResult.playerBlackjack] ?? 0) * 1.5;
    totalReturn += (results[GameResult.dealerBust] ?? 0) * 1.0;
    totalReturn -= (results[GameResult.dealerWin] ?? 0) * 1.0;
    totalReturn -= (results[GameResult.dealerBlackjack] ?? 0) * 1.0;
    totalReturn -= (results[GameResult.playerBust] ?? 0) * 1.0;
    
    return (totalReturn / totalGames) * 100;
  }

  void printResults() {
    print('\n═══════════════════════════════════════════════════════');
    print('           BLACKJACK ODDS CALCULATOR RESULTS');
    print('═══════════════════════════════════════════════════════');
    print('Total simulations: ${totalGames.toString().padLeft(10)}');
    print('───────────────────────────────────────────────────────');
    
    print('\n📊 DETAILED BREAKDOWN:');
    print('  Player Wins:           ${playerWins.toString().padLeft(8)} (${playerWinRate.toStringAsFixed(2)}%)');
    print('    ├─ Regular Wins:     ${(results[GameResult.playerWin] ?? 0).toString().padLeft(8)}');
    print('    ├─ Blackjacks:       ${(results[GameResult.playerBlackjack] ?? 0).toString().padLeft(8)}');
    print('    └─ Dealer Busts:     ${(results[GameResult.dealerBust] ?? 0).toString().padLeft(8)}');
    
    print('\n  Dealer Wins:           ${dealerWins.toString().padLeft(8)} (${dealerWinRate.toStringAsFixed(2)}%)');
    print('    ├─ Regular Wins:     ${(results[GameResult.dealerWin] ?? 0).toString().padLeft(8)}');
    print('    ├─ Blackjacks:       ${(results[GameResult.dealerBlackjack] ?? 0).toString().padLeft(8)}');
    print('    └─ Player Busts:     ${(results[GameResult.playerBust] ?? 0).toString().padLeft(8)}');
    
    print('\n  Pushes (Ties):         ${pushes.toString().padLeft(8)} (${pushRate.toStringAsFixed(2)}%)');
    
    print('\n───────────────────────────────────────────────────────');
    print('💰 EXPECTED RETURN: ${expectedReturn >= 0 ? '+' : ''}${expectedReturn.toStringAsFixed(2)}%');
    print('   (Per \$100 bet: \$${(100 + expectedReturn).toStringAsFixed(2)})');
    print('═══════════════════════════════════════════════════════\n');
  }
}

void main() {
  print('╔═══════════════════════════════════════════════════════╗');
  print('║         BLACKJACK ODDS CALCULATOR                     ║');
  print('║         Monte Carlo Simulation                        ║');
  print('╚═══════════════════════════════════════════════════════╝\n');

  // Configuration (modify these values as needed)
  final numSimulations = 10000;  // Change this value
  final numDecks = 6;            // Change this value (1-8)
  final useBasicStrategy = true; // Change to false for simple strategy

  print('⚙️  Configuration:');
  print('   Simulations: $numSimulations');
  print('   Number of decks: $numDecks');
  print('   Strategy: ${useBasicStrategy ? "Basic Strategy" : "Simple Strategy (hit until 17)"}');
  print('\n⏳ Running simulations...\n');

  final simulator = BlackjackSimulator(numDecks: numDecks);
  final stopwatch = Stopwatch()..start();
  
  final results = simulator.runSimulations(numSimulations, useBasicStrategy: useBasicStrategy);
  
  stopwatch.stop();
  
  results.printResults();
  
  print('⏱️  Simulation completed in ${stopwatch.elapsedMilliseconds}ms\n');

  // Additional insights
  print('📝 INSIGHTS:');
  if (results.expectedReturn < 0) {
    print('   • The house has an edge of ${(-results.expectedReturn).toStringAsFixed(2)}%');
    print('   • Over time, you can expect to lose \$${(-results.expectedReturn).toStringAsFixed(2)} per \$100 bet');
  } else {
    print('   • You have an edge of ${results.expectedReturn.toStringAsFixed(2)}%');
  }
  
  if (useBasicStrategy) {
    print('   • Basic strategy significantly improves your odds');
  } else {
    print('   • Consider using basic strategy to improve your odds');
  }
  
  print('   • Blackjack typically has a house edge of 0.5% with perfect basic strategy');
  print('   • Your win rate: ${results.playerWinRate.toStringAsFixed(2)}%');
  print('   • Dealer win rate: ${results.dealerWinRate.toStringAsFixed(2)}%');
  print('\n✅ Done! Modify the configuration values in main() to run different scenarios.');
}
