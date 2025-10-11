import 'dart:io';
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

/// Extended game result with additional tracking data
class GameData {
  final GameResult result;
  final int playerFinalValue;
  final int dealerFinalValue;
  final int dealerUpcard;
  final int playerInitialValue;
  final bool playerHadBlackjack;
  final bool dealerHadBlackjack;
  final int playerCardCount;
  final int dealerCardCount;

  GameData({
    required this.result,
    required this.playerFinalValue,
    required this.dealerFinalValue,
    required this.dealerUpcard,
    required this.playerInitialValue,
    required this.playerHadBlackjack,
    required this.dealerHadBlackjack,
    required this.playerCardCount,
    required this.dealerCardCount,
  });
}

/// Blackjack game simulator
class BlackjackSimulator {
  final int numDecks;
  final Random random = Random();

  BlackjackSimulator({this.numDecks = 6});

  /// Simulate a single hand of blackjack with detailed tracking
  GameData playHandDetailed({bool useBasicStrategy = true}) {
    final deck = Deck(numDecks: numDecks);
    deck.shuffle();

    final playerHand = Hand();
    final dealerHand = Hand();

    // Initial deal
    playerHand.addCard(deck.draw());
    dealerHand.addCard(deck.draw());
    playerHand.addCard(deck.draw());
    dealerHand.addCard(deck.draw());

    final dealerUpcard = dealerHand.cards[0].getValue();
    final playerInitialValue = playerHand.getValue();
    final playerHadBlackjack = playerHand.isBlackjack;
    final dealerHadBlackjack = dealerHand.isBlackjack;

    GameResult result;

    // Check for blackjacks
    if (playerHand.isBlackjack && dealerHand.isBlackjack) {
      result = GameResult.push;
    } else if (playerHand.isBlackjack) {
      result = GameResult.playerBlackjack;
    } else if (dealerHand.isBlackjack) {
      result = GameResult.dealerBlackjack;
    } else {
      // Player's turn
      if (useBasicStrategy) {
        _playBasicStrategy(playerHand, dealerHand.cards[0], deck);
      } else {
        _playSimpleStrategy(playerHand, deck);
      }

      if (playerHand.isBusted) {
        result = GameResult.playerBust;
      } else {
        // Dealer's turn
        while (dealerHand.getValue() < 17) {
          dealerHand.addCard(deck.draw());
        }

        if (dealerHand.isBusted) {
          result = GameResult.dealerBust;
        } else {
          // Compare hands
          final playerValue = playerHand.getValue();
          final dealerValue = dealerHand.getValue();

          if (playerValue > dealerValue) {
            result = GameResult.playerWin;
          } else if (playerValue < dealerValue) {
            result = GameResult.dealerWin;
          } else {
            result = GameResult.push;
          }
        }
      }
    }

    return GameData(
      result: result,
      playerFinalValue: playerHand.getValue(),
      dealerFinalValue: dealerHand.getValue(),
      dealerUpcard: dealerUpcard,
      playerInitialValue: playerInitialValue,
      playerHadBlackjack: playerHadBlackjack,
      dealerHadBlackjack: dealerHadBlackjack,
      playerCardCount: playerHand.cards.length,
      dealerCardCount: dealerHand.cards.length,
    );
  }

  /// Simulate a single hand of blackjack
  GameResult playHand({bool useBasicStrategy = true}) {
    return playHandDetailed(useBasicStrategy: useBasicStrategy).result;
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

  /// Run multiple simulations and calculate comprehensive odds
  EnhancedSimulationResults runSimulations(int numSimulations, {bool useBasicStrategy = true}) {
    final results = <GameResult, int>{};
    final gameDataList = <GameData>[];
    
    for (int i = 0; i < numSimulations; i++) {
      final gameData = playHandDetailed(useBasicStrategy: useBasicStrategy);
      results[gameData.result] = (results[gameData.result] ?? 0) + 1;
      gameDataList.add(gameData);
    }

    return EnhancedSimulationResults(results, gameDataList, numSimulations);
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

/// Theoretical probability calculator
class TheoreticalOdds {
  /// Calculate probability of getting blackjack
  static double blackjackProbability(int numDecks) {
    final totalCards = 52 * numDecks;
    final aces = 4 * numDecks;
    final tens = 16 * numDecks; // 10, J, Q, K
    
    // Probability of Ace then 10-value card OR 10-value card then Ace
    final aceFirst = (aces / totalCards) * (tens / (totalCards - 1));
    final tenFirst = (tens / totalCards) * (aces / (totalCards - 1));
    
    return (aceFirst + tenFirst) * 100;
  }

  /// Calculate probability of dealer busting with specific upcard
  static Map<int, double> dealerBustProbabilities() {
    return {
      2: 35.30,
      3: 37.56,
      4: 40.28,
      5: 42.89,
      6: 42.08,
      7: 25.99,
      8: 23.86,
      9: 23.34,
      10: 21.43,
      11: 11.65, // Ace
    };
  }

  /// Calculate probability of player busting when hitting on specific hand value
  static Map<int, double> playerBustProbabilities() {
    return {
      11: 0.0,
      12: 31.0,
      13: 39.0,
      14: 46.0,
      15: 54.0,
      16: 62.0,
      17: 69.0,
      18: 77.0,
      19: 85.0,
      20: 92.0,
      21: 100.0,
    };
  }
}

/// Enhanced simulation results with comprehensive analytics
class EnhancedSimulationResults {
  final Map<GameResult, int> results;
  final List<GameData> gameDataList;
  final int totalGames;

  EnhancedSimulationResults(this.results, this.gameDataList, this.totalGames);

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

  /// Calculate dealer upcard win rates
  Map<int, Map<String, double>> getDealerUpcardAnalysis() {
    final upcardStats = <int, Map<String, int>>{};
    
    for (var game in gameDataList) {
      final upcard = game.dealerUpcard;
      upcardStats[upcard] ??= {'wins': 0, 'losses': 0, 'pushes': 0, 'total': 0};
      
      if ([GameResult.dealerWin, GameResult.dealerBlackjack, GameResult.playerBust].contains(game.result)) {
        upcardStats[upcard]!['wins'] = upcardStats[upcard]!['wins']! + 1;
      } else if ([GameResult.playerWin, GameResult.playerBlackjack, GameResult.dealerBust].contains(game.result)) {
        upcardStats[upcard]!['losses'] = upcardStats[upcard]!['losses']! + 1;
      } else {
        upcardStats[upcard]!['pushes'] = upcardStats[upcard]!['pushes']! + 1;
      }
      upcardStats[upcard]!['total'] = upcardStats[upcard]!['total']! + 1;
    }

    final analysis = <int, Map<String, double>>{};
    upcardStats.forEach((upcard, stats) {
      final total = stats['total']!.toDouble();
      analysis[upcard] = {
        'dealerWinRate': (stats['wins']! / total) * 100,
        'playerWinRate': (stats['losses']! / total) * 100,
        'pushRate': (stats['pushes']! / total) * 100,
        'count': total,
      };
    });

    return analysis;
  }

  /// Calculate player final hand value distribution
  Map<int, int> getPlayerHandDistribution() {
    final distribution = <int, int>{};
    for (var game in gameDataList) {
      final value = game.playerFinalValue > 21 ? 0 : game.playerFinalValue; // 0 for bust
      distribution[value] = (distribution[value] ?? 0) + 1;
    }
    return distribution;
  }

  /// Calculate dealer final hand value distribution
  Map<int, int> getDealerHandDistribution() {
    final distribution = <int, int>{};
    for (var game in gameDataList) {
      final value = game.dealerFinalValue > 21 ? 0 : game.dealerFinalValue; // 0 for bust
      distribution[value] = (distribution[value] ?? 0) + 1;
    }
    return distribution;
  }

  /// Calculate average cards per hand
  Map<String, double> getAverageCardCounts() {
    double totalPlayerCards = 0;
    double totalDealerCards = 0;
    
    for (var game in gameDataList) {
      totalPlayerCards += game.playerCardCount;
      totalDealerCards += game.dealerCardCount;
    }

    return {
      'player': totalPlayerCards / totalGames,
      'dealer': totalDealerCards / totalGames,
    };
  }

  void printResults({required int numDecks}) {
    print('\n╔═══════════════════════════════════════════════════════════════════╗');
    print('║         COMPREHENSIVE BLACKJACK ODDS CALCULATOR RESULTS           ║');
    print('╚═══════════════════════════════════════════════════════════════════╝');
    print('\n📈 SIMULATION PARAMETERS:');
    print('   Total simulations: ${totalGames.toString().padLeft(10)}');
    print('   Number of decks:   ${numDecks.toString().padLeft(10)}');
    print('\n═══════════════════════════════════════════════════════════════════');
    
    print('\n📊 PRIMARY RESULTS:');
    print('   Player Wins:           ${playerWins.toString().padLeft(8)} (${playerWinRate.toStringAsFixed(2)}%)');
    print('     ├─ Regular Wins:     ${(results[GameResult.playerWin] ?? 0).toString().padLeft(8)} (${((results[GameResult.playerWin] ?? 0) / totalGames * 100).toStringAsFixed(2)}%)');
    print('     ├─ Blackjacks:       ${(results[GameResult.playerBlackjack] ?? 0).toString().padLeft(8)} (${((results[GameResult.playerBlackjack] ?? 0) / totalGames * 100).toStringAsFixed(2)}%)');
    print('     └─ Dealer Busts:     ${(results[GameResult.dealerBust] ?? 0).toString().padLeft(8)} (${((results[GameResult.dealerBust] ?? 0) / totalGames * 100).toStringAsFixed(2)}%)');
    
    print('\n   Dealer Wins:           ${dealerWins.toString().padLeft(8)} (${dealerWinRate.toStringAsFixed(2)}%)');
    print('     ├─ Regular Wins:     ${(results[GameResult.dealerWin] ?? 0).toString().padLeft(8)} (${((results[GameResult.dealerWin] ?? 0) / totalGames * 100).toStringAsFixed(2)}%)');
    print('     ├─ Blackjacks:       ${(results[GameResult.dealerBlackjack] ?? 0).toString().padLeft(8)} (${((results[GameResult.dealerBlackjack] ?? 0) / totalGames * 100).toStringAsFixed(2)}%)');
    print('     └─ Player Busts:     ${(results[GameResult.playerBust] ?? 0).toString().padLeft(8)} (${((results[GameResult.playerBust] ?? 0) / totalGames * 100).toStringAsFixed(2)}%)');
    
    print('\n   Pushes (Ties):         ${pushes.toString().padLeft(8)} (${pushRate.toStringAsFixed(2)}%)');
    
    print('\n═══════════════════════════════════════════════════════════════════');
    print('💰 FINANCIAL ANALYSIS:');
    print('   Expected Return:       ${expectedReturn >= 0 ? '+' : ''}${expectedReturn.toStringAsFixed(3)}%');
    print('   House Edge:            ${expectedReturn >= 0 ? '-' : '+'}${(-expectedReturn).toStringAsFixed(3)}%');
    print('   Per \$100 bet:         \$${(100 + expectedReturn).toStringAsFixed(2)}');
    print('   Per \$1000 bet:        \$${(1000 + expectedReturn * 10).toStringAsFixed(2)}');
    
    final blackjackOdds = ((results[GameResult.playerBlackjack] ?? 0) / totalGames * 100);
    final theoreticalBJOdds = TheoreticalOdds.blackjackProbability(numDecks);
    print('\n═══════════════════════════════════════════════════════════════════');
    print('🎲 PROBABILITY ANALYSIS:');
    print('   Blackjack Probability:');
    print('     Simulated:          ${blackjackOdds.toStringAsFixed(3)}%');
    print('     Theoretical:        ${theoreticalBJOdds.toStringAsFixed(3)}%');
    print('     Difference:         ${(blackjackOdds - theoreticalBJOdds).toStringAsFixed(3)}%');
    
    print('\n   Bust Probabilities:');
    final playerBustRate = ((results[GameResult.playerBust] ?? 0) / totalGames * 100);
    final dealerBustRate = ((results[GameResult.dealerBust] ?? 0) / totalGames * 100);
    print('     Player Bust Rate:   ${playerBustRate.toStringAsFixed(2)}%');
    print('     Dealer Bust Rate:   ${dealerBustRate.toStringAsFixed(2)}%');
    
    print('\n═══════════════════════════════════════════════════════════════════');
    print('🃏 DEALER UPCARD ANALYSIS:');
    final upcardAnalysis = getDealerUpcardAnalysis();
    final sortedUpcards = upcardAnalysis.keys.toList()..sort();
    
    print('   Upcard │ Dealer Wins │ Player Wins │  Push  │ Sample Size');
    print('   ───────┼─────────────┼─────────────┼────────┼─────────────');
    for (var upcard in sortedUpcards) {
      final stats = upcardAnalysis[upcard]!;
      final upcardStr = upcard == 11 ? 'A ' : upcard.toString().padLeft(2);
      print('     $upcardStr   │   ${stats['dealerWinRate']!.toStringAsFixed(2)}%   │   ${stats['playerWinRate']!.toStringAsFixed(2)}%   │ ${stats['pushRate']!.toStringAsFixed(2)}% │    ${stats['count']!.toInt()}');
    }
    
    print('\n═══════════════════════════════════════════════════════════════════');
    print('📊 HAND VALUE DISTRIBUTIONS:');
    
    final playerDist = getPlayerHandDistribution();
    final dealerDist = getDealerHandDistribution();
    
    print('\n   Player Final Hands:');
    final sortedPlayerValues = playerDist.keys.toList()..sort();
    for (var value in sortedPlayerValues) {
      final count = playerDist[value]!;
      final pct = (count / totalGames * 100);
      final valueStr = value == 0 ? 'BUST' : value.toString().padLeft(2);
      final bar = '█' * (pct ~/ 2).clamp(0, 50);
      print('     $valueStr: ${count.toString().padLeft(6)} (${pct.toStringAsFixed(2)}%) $bar');
    }
    
    print('\n   Dealer Final Hands:');
    final sortedDealerValues = dealerDist.keys.toList()..sort();
    for (var value in sortedDealerValues) {
      final count = dealerDist[value]!;
      final pct = (count / totalGames * 100);
      final valueStr = value == 0 ? 'BUST' : value.toString().padLeft(2);
      final bar = '█' * (pct ~/ 2).clamp(0, 50);
      print('     $valueStr: ${count.toString().padLeft(6)} (${pct.toStringAsFixed(2)}%) $bar');
    }
    
    final avgCards = getAverageCardCounts();
    print('\n═══════════════════════════════════════════════════════════════════');
    print('📈 ADDITIONAL STATISTICS:');
    print('   Average cards per hand:');
    print('     Player:             ${avgCards['player']!.toStringAsFixed(2)} cards');
    print('     Dealer:             ${avgCards['dealer']!.toStringAsFixed(2)} cards');
    
    print('\n   Win/Loss Ratios:');
    final winLossRatio = playerWins / dealerWins;
    print('     Player/Dealer:      ${winLossRatio.toStringAsFixed(3)}:1');
    print('     Dealer/Player:      ${(1/winLossRatio).toStringAsFixed(3)}:1');
    
    print('\n═══════════════════════════════════════════════════════════════════\n');
  }
}

void main() {
  print('╔═══════════════════════════════════════════════════════╗');
  print('║         BLACKJACK ODDS CALCULATOR                     ║');
  print('║         Monte Carlo Simulation                        ║');
  print('╚═══════════════════════════════════════════════════════╝\n');

  // Get number of simulations
  stdout.write('Enter number of simulations (default 100000): ');
  final input = stdin.readLineSync();
  final numSimulations = int.tryParse(input ?? '') ?? 100000;

  // Get number of decks
  stdout.write('Enter number of decks (default 6): ');
  final deckInput = stdin.readLineSync();
  final numDecks = int.tryParse(deckInput ?? '') ?? 6;

  // Get strategy choice
  stdout.write('Use basic strategy? (y/n, default y): ');
  final strategyInput = stdin.readLineSync()?.toLowerCase() ?? 'y';
  final useBasicStrategy = strategyInput != 'n';

  print('\n⏳ Running $numSimulations simulations with $numDecks deck(s)...');
  print('   Strategy: ${useBasicStrategy ? "Basic Strategy" : "Simple Strategy (hit until 17)"}');

  final simulator = BlackjackSimulator(numDecks: numDecks);
  final stopwatch = Stopwatch()..start();
  
  print('\n🎰 Simulating $numSimulations hands...');
  final results = simulator.runSimulations(numSimulations, useBasicStrategy: useBasicStrategy);
  
  stopwatch.stop();
  
  results.printResults(numDecks: numDecks);
  
  print('⏱️  PERFORMANCE:');
  print('   Simulation time:       ${stopwatch.elapsedMilliseconds}ms');
  print('   Hands per second:      ${(numSimulations / (stopwatch.elapsedMilliseconds / 1000)).toStringAsFixed(0)}');

  // Additional insights
  print('\n═══════════════════════════════════════════════════════════════════');
  print('💡 KEY INSIGHTS & RECOMMENDATIONS:\n');
  
  if (results.expectedReturn < 0) {
    print('   • The house has an edge of ${(-results.expectedReturn).toStringAsFixed(3)}%');
    print('   • Over time, expect to lose \$${(-results.expectedReturn).toStringAsFixed(2)} per \$100 bet');
    print('   • Over 1000 hands at \$10/hand, expected loss: \$${((-results.expectedReturn / 100) * 10000).toStringAsFixed(2)}');
  } else {
    print('   • You have an edge of ${results.expectedReturn.toStringAsFixed(3)}%');
    print('   • This is unusual - verify simulation parameters');
  }
  
  if (useBasicStrategy) {
    print('\n   • ✓ Using basic strategy (optimal play)');
    print('   • Your simulated house edge: ${(-results.expectedReturn).toStringAsFixed(3)}%');
    print('   • Typical casino house edge: 0.5% (with perfect basic strategy)');
    
    if ((-results.expectedReturn) > 1.0) {
      print('   • ⚠ Higher than expected - may need more simulations for accuracy');
    }
  } else {
    print('\n   • ⚠ Not using basic strategy (suboptimal play)');
    print('   • Consider using basic strategy to reduce house edge by ~3-4%');
  }
  
  print('\n   📚 Strategy Tips:');
  print('   • Always split Aces and 8s');
  print('   • Never split 10s or 5s');
  print('   • Double down on 11 (unless dealer shows Ace)');
  print('   • Stand on hard 17 or higher');
  print('   • Hit on soft 17 or lower');
  print('   • Avoid insurance bets (high house edge ~7%)');
  
  print('\n   🎯 Optimal Conditions:');
  print('   • Fewer decks = Better odds (single deck best)');
  print('   • Dealer stands on soft 17 = Better for player');
  print('   • Blackjack pays 3:2 (avoid 6:5 tables)');
  print('   • Late surrender allowed = Reduces house edge by ~0.08%');
  
  print('\n═══════════════════════════════════════════════════════════════════');
  print('\n✅ Simulation complete! Run again with different parameters to compare.\n');
}
