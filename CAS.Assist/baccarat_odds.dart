import 'dart:io';
import 'dart:math';

/// Baccarat Odds Calculator with Monte Carlo Simulation
/// Simulates Banker, Player, and Tie bets

enum GameResult { banker, player, tie }

class Card {
  final int rank; // 1-13 (A, 2-10, J, Q, K)
  final String suit;

  Card(this.rank, this.suit);

  int get baccaratValue {
    if (rank >= 10) return 0; // 10, J, Q, K = 0
    return rank; // A=1, 2-9 = face value
  }

  String get rankString {
    if (rank == 1) return 'A';
    if (rank == 11) return 'J';
    if (rank == 12) return 'Q';
    if (rank == 13) return 'K';
    return rank.toString();
  }

  @override
  String toString() => '$rankString$suit';
}

class Deck {
  final List<Card> cards = [];
  final Random random = Random();

  Deck({int numDecks = 8}) {
    final suits = ['♠', '♥', '♦', '♣'];
    for (int d = 0; d < numDecks; d++) {
      for (var suit in suits) {
        for (int rank = 1; rank <= 13; rank++) {
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
}

class Hand {
  final List<Card> cards = [];

  void addCard(Card card) {
    cards.add(card);
  }

  int get value {
    int total = 0;
    for (var card in cards) {
      total += card.baccaratValue;
    }
    return total % 10; // Baccarat uses modulo 10
  }

  @override
  String toString() => cards.map((c) => c.toString()).join(' ') + ' (${value})';
}

class BaccaratSimulator {
  final int numDecks;
  final Random random = Random();

  BaccaratSimulator({this.numDecks = 8});

  /// Simulate a single hand of baccarat
  GameResult playHand() {
    final deck = Deck(numDecks: numDecks);
    deck.shuffle();

    final playerHand = Hand();
    final bankerHand = Hand();

    // Initial deal - 2 cards each
    playerHand.addCard(deck.draw());
    bankerHand.addCard(deck.draw());
    playerHand.addCard(deck.draw());
    bankerHand.addCard(deck.draw());

    int playerValue = playerHand.value;
    int bankerValue = bankerHand.value;

    // Natural win (8 or 9)
    if (playerValue >= 8 || bankerValue >= 8) {
      return _determineWinner(playerValue, bankerValue);
    }

    // Player's third card rule
    Card? playerThirdCard;
    if (playerValue <= 5) {
      playerThirdCard = deck.draw();
      playerHand.addCard(playerThirdCard);
      playerValue = playerHand.value;
    }

    // Banker's third card rule
    if (playerThirdCard == null) {
      // Player stood, banker draws on 0-5
      if (bankerValue <= 5) {
        bankerHand.addCard(deck.draw());
        bankerValue = bankerHand.value;
      }
    } else {
      // Player drew, banker follows complex rules
      final playerThirdValue = playerThirdCard.baccaratValue;
      bool bankerDraws = false;

      if (bankerValue <= 2) {
        bankerDraws = true;
      } else if (bankerValue == 3) {
        bankerDraws = playerThirdValue != 8;
      } else if (bankerValue == 4) {
        bankerDraws = [2, 3, 4, 5, 6, 7].contains(playerThirdValue);
      } else if (bankerValue == 5) {
        bankerDraws = [4, 5, 6, 7].contains(playerThirdValue);
      } else if (bankerValue == 6) {
        bankerDraws = [6, 7].contains(playerThirdValue);
      }

      if (bankerDraws) {
        bankerHand.addCard(deck.draw());
        bankerValue = bankerHand.value;
      }
    }

    return _determineWinner(playerValue, bankerValue);
  }

  GameResult _determineWinner(int playerValue, int bankerValue) {
    if (playerValue > bankerValue) {
      return GameResult.player;
    } else if (bankerValue > playerValue) {
      return GameResult.banker;
    } else {
      return GameResult.tie;
    }
  }

  /// Run multiple simulations
  SimulationResults runSimulations(int numSimulations) {
    final results = <GameResult, int>{
      GameResult.banker: 0,
      GameResult.player: 0,
      GameResult.tie: 0,
    };

    for (int i = 0; i < numSimulations; i++) {
      final result = playHand();
      results[result] = results[result]! + 1;
    }

    return SimulationResults(results, numSimulations, numDecks);
  }
}

class SimulationResults {
  final Map<GameResult, int> results;
  final int totalGames;
  final int numDecks;

  SimulationResults(this.results, this.totalGames, this.numDecks);

  int get bankerWins => results[GameResult.banker]!;
  int get playerWins => results[GameResult.player]!;
  int get ties => results[GameResult.tie]!;

  double get bankerWinRate => (bankerWins / totalGames) * 100;
  double get playerWinRate => (playerWins / totalGames) * 100;
  double get tieRate => (ties / totalGames) * 100;

  // Banker bet pays 1:1 minus 5% commission
  double get bankerExpectedReturn {
    final bankerProb = bankerWins / totalGames;
    final playerProb = playerWins / totalGames;
    final tieProb = ties / totalGames;
    
    // On banker win: win 0.95 (1:1 minus 5% commission)
    // On player win: lose 1
    // On tie: push (no win/loss)
    return ((bankerProb * 0.95) - playerProb) * 100;
  }

  // Player bet pays 1:1
  double get playerExpectedReturn {
    final bankerProb = bankerWins / totalGames;
    final playerProb = playerWins / totalGames;
    
    return (playerProb - bankerProb) * 100;
  }

  // Tie bet pays 8:1 (sometimes 9:1)
  double get tieExpectedReturn8to1 {
    final tieProb = ties / totalGames;
    final noTieProb = 1 - tieProb;
    
    return ((tieProb * 8) - noTieProb) * 100;
  }

  double get tieExpectedReturn9to1 {
    final tieProb = ties / totalGames;
    final noTieProb = 1 - tieProb;
    
    return ((tieProb * 9) - noTieProb) * 100;
  }

  void printResults() {
    print('\n╔═══════════════════════════════════════════════════════════════════╗');
    print('║         BACCARAT ODDS CALCULATOR RESULTS                          ║');
    print('╚═══════════════════════════════════════════════════════════════════╝');
    print('\n📈 SIMULATION PARAMETERS:');
    print('   Total simulations: ${totalGames.toString().padLeft(10)}');
    print('   Number of decks:   ${numDecks.toString().padLeft(10)}');
    print('\n═══════════════════════════════════════════════════════════════════');
    
    print('\n📊 PRIMARY RESULTS:');
    print('   Banker Wins:       ${bankerWins.toString().padLeft(8)} (${bankerWinRate.toStringAsFixed(2)}%)');
    print('   Player Wins:       ${playerWins.toString().padLeft(8)} (${playerWinRate.toStringAsFixed(2)}%)');
    print('   Ties:              ${ties.toString().padLeft(8)} (${tieRate.toStringAsFixed(2)}%)');
    
    print('\n═══════════════════════════════════════════════════════════════════');
    print('💰 EXPECTED RETURN ANALYSIS:\n');
    
    print('   BANKER BET (pays 1:1, 5% commission):');
    print('     Expected Return:   ${bankerExpectedReturn >= 0 ? '+' : ''}${bankerExpectedReturn.toStringAsFixed(3)}%');
    print('     House Edge:        ${(-bankerExpectedReturn).toStringAsFixed(3)}%');
    print('     Per \$100 bet:     \$${(100 + bankerExpectedReturn).toStringAsFixed(2)}');
    
    print('\n   PLAYER BET (pays 1:1):');
    print('     Expected Return:   ${playerExpectedReturn >= 0 ? '+' : ''}${playerExpectedReturn.toStringAsFixed(3)}%');
    print('     House Edge:        ${(-playerExpectedReturn).toStringAsFixed(3)}%');
    print('     Per \$100 bet:     \$${(100 + playerExpectedReturn).toStringAsFixed(2)}');
    
    print('\n   TIE BET (pays 8:1):');
    print('     Expected Return:   ${tieExpectedReturn8to1 >= 0 ? '+' : ''}${tieExpectedReturn8to1.toStringAsFixed(3)}%');
    print('     House Edge:        ${(-tieExpectedReturn8to1).toStringAsFixed(3)}%');
    print('     Per \$100 bet:     \$${(100 + tieExpectedReturn8to1).toStringAsFixed(2)}');
    
    print('\n   TIE BET (pays 9:1):');
    print('     Expected Return:   ${tieExpectedReturn9to1 >= 0 ? '+' : ''}${tieExpectedReturn9to1.toStringAsFixed(3)}%');
    print('     House Edge:        ${(-tieExpectedReturn9to1).toStringAsFixed(3)}%');
    print('     Per \$100 bet:     \$${(100 + tieExpectedReturn9to1).toStringAsFixed(2)}');
    
    print('\n═══════════════════════════════════════════════════════════════════');
    print('📊 COMPARISON TABLE:\n');
    
    print('   Bet Type    │ Win Rate │ Payout │   ROI    │ House Edge');
    print('   ────────────┼──────────┼────────┼──────────┼───────────');
    print('   Banker      │ ${bankerWinRate.toStringAsFixed(2)}% │ 0.95:1 │ '
          '${bankerExpectedReturn >= 0 ? '+' : ''}${bankerExpectedReturn.toStringAsFixed(2)}% │ '
          '${(-bankerExpectedReturn).toStringAsFixed(2)}%');
    print('   Player      │ ${playerWinRate.toStringAsFixed(2)}% │  1:1   │ '
          '${playerExpectedReturn >= 0 ? '+' : ''}${playerExpectedReturn.toStringAsFixed(2)}% │ '
          '${(-playerExpectedReturn).toStringAsFixed(2)}%');
    print('   Tie (8:1)   │  ${tieRate.toStringAsFixed(2)}% │  8:1   │ '
          '${tieExpectedReturn8to1 >= 0 ? '+' : ''}${tieExpectedReturn8to1.toStringAsFixed(2)}% │ '
          '${(-tieExpectedReturn8to1).toStringAsFixed(2)}%');
    print('   Tie (9:1)   │  ${tieRate.toStringAsFixed(2)}% │  9:1   │ '
          '${tieExpectedReturn9to1 >= 0 ? '+' : ''}${tieExpectedReturn9to1.toStringAsFixed(2)}% │ '
          '${(-tieExpectedReturn9to1).toStringAsFixed(2)}%');
    
    print('\n═══════════════════════════════════════════════════════════════════');
    print('🎯 THEORETICAL PROBABILITIES:\n');
    
    print('   According to mathematical analysis:');
    print('   • Banker wins: ~45.86%');
    print('   • Player wins: ~44.62%');
    print('   • Tie:         ~9.52%');
    print('   • Banker house edge: ~1.06%');
    print('   • Player house edge: ~1.24%');
    print('   • Tie house edge (8:1): ~14.36%');
    
    print('\n   Simulation vs Theoretical:');
    print('   • Banker: ${bankerWinRate.toStringAsFixed(2)}% vs 45.86% (diff: ${(bankerWinRate - 45.86).toStringAsFixed(3)}%)');
    print('   • Player: ${playerWinRate.toStringAsFixed(2)}% vs 44.62% (diff: ${(playerWinRate - 44.62).toStringAsFixed(3)}%)');
    print('   • Tie:    ${tieRate.toStringAsFixed(2)}% vs 9.52% (diff: ${(tieRate - 9.52).toStringAsFixed(3)}%)');
    
    print('\n═══════════════════════════════════════════════════════════════════\n');
  }
}

void main() {
  print('╔═══════════════════════════════════════════════════════╗');
  print('║         BACCARAT ODDS CALCULATOR                      ║');
  print('║         Monte Carlo Simulation                        ║');
  print('╚═══════════════════════════════════════════════════════╝\n');

  stdout.write('Enter number of simulations (default 100000): ');
  final input = stdin.readLineSync();
  final numSimulations = int.tryParse(input ?? '') ?? 100000;

  stdout.write('Enter number of decks (default 8): ');
  final deckInput = stdin.readLineSync();
  final numDecks = int.tryParse(deckInput ?? '') ?? 8;

  print('\n⏳ Running $numSimulations simulations with $numDecks deck(s)...\n');

  final simulator = BaccaratSimulator(numDecks: numDecks);
  final stopwatch = Stopwatch()..start();
  
  final results = simulator.runSimulations(numSimulations);
  
  stopwatch.stop();
  
  results.printResults();
  
  print('⏱️  PERFORMANCE:');
  print('   Simulation time:       ${stopwatch.elapsedMilliseconds}ms');
  print('   Hands per second:      ${(numSimulations / (stopwatch.elapsedMilliseconds / 1000)).toStringAsFixed(0)}');

  print('\n═══════════════════════════════════════════════════════════════════');
  print('💡 KEY INSIGHTS & STRATEGY:\n');
  
  print('   📊 BEST BET:');
  print('   • Banker bet has the lowest house edge (~1.06%)');
  print('   • Despite 5% commission, it\'s still the best bet');
  print('   • Banker wins slightly more often due to drawing rules');
  
  print('\n   ⚠️  BETS TO AVOID:');
  print('   • Tie bet has extremely high house edge (~14%)');
  print('   • Even at 9:1 payout, tie bet is poor value');
  print('   • Avoid all side bets (Pair, Dragon, etc.)');
  
  print('\n   📚 OPTIMAL STRATEGY:');
  print('   • Always bet on Banker (lowest house edge)');
  print('   • Player bet is acceptable but slightly worse');
  print('   • Never bet on Tie (terrible odds)');
  print('   • No betting system can overcome house edge');
  print('   • Card counting is ineffective in baccarat');
  
  print('\n   🎲 GAME FACTS:');
  print('   • Baccarat is a pure game of chance');
  print('   • No skill or strategy affects outcome');
  print('   • Drawing rules are automatic and fixed');
  print('   • Popular in Asian casinos');
  print('   • Featured in James Bond films');
  
  print('\n   💰 BANKROLL MANAGEMENT:');
  print('   • Set a loss limit before playing');
  print('   • Baccarat has low volatility');
  print('   • Expect to lose ~\$1 per \$100 wagered on Banker');
  print('   • Minimum bets are often high (\$25-\$100)');
  
  print('\n   🎯 VARIATIONS:');
  print('   • Punto Banco (most common)');
  print('   • Chemin de Fer (player-banked)');
  print('   • Baccarat Banque (three-hand version)');
  print('   • Mini-Baccarat (lower stakes, faster)');
  
  print('\n═══════════════════════════════════════════════════════════════════');
  print('\n✅ Simulation complete! Banker bet is optimal.\n');
}
