import 'dart:io';
import 'dart:math';

/// Texas Hold'em Poker Odds Calculator with Monte Carlo Simulation
/// Calculates winning probabilities for different starting hands

/// Represents a playing card
class Card {
  final int rank; // 2-14 (2-10, J=11, Q=12, K=13, A=14)
  final String suit; // H, D, C, S

  Card(this.rank, this.suit);

  String get rankString {
    if (rank == 14) return 'A';
    if (rank == 13) return 'K';
    if (rank == 12) return 'Q';
    if (rank == 11) return 'J';
    return rank.toString();
  }

  @override
  String toString() => '$rankString$suit';

  @override
  bool operator ==(Object other) =>
      other is Card && rank == other.rank && suit == other.suit;

  @override
  int get hashCode => rank.hashCode ^ suit.hashCode;
}

/// Represents a deck of cards
class Deck {
  final List<Card> cards = [];
  final Random random = Random();

  Deck() {
    final suits = ['H', 'D', 'C', 'S'];
    for (var suit in suits) {
      for (int rank = 2; rank <= 14; rank++) {
        cards.add(Card(rank, suit));
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

  void remove(Card card) {
    cards.removeWhere((c) => c == card);
  }
}

/// Hand rankings
enum HandRank {
  highCard,
  onePair,
  twoPair,
  threeOfKind,
  straight,
  flush,
  fullHouse,
  fourOfKind,
  straightFlush,
  royalFlush,
}

/// Evaluated poker hand
class HandEvaluation {
  final HandRank rank;
  final List<int> values; // Tiebreaker values

  HandEvaluation(this.rank, this.values);

  int compareTo(HandEvaluation other) {
    if (rank.index != other.rank.index) {
      return rank.index.compareTo(other.rank.index);
    }
    for (int i = 0; i < values.length && i < other.values.length; i++) {
      if (values[i] != other.values[i]) {
        return values[i].compareTo(other.values[i]);
      }
    }
    return 0;
  }
}

/// Hand evaluator
class HandEvaluator {
  static HandEvaluation evaluate(List<Card> cards) {
    if (cards.length != 7) {
      throw Exception('Must evaluate exactly 7 cards');
    }

    // Generate all 5-card combinations
    final combinations = _getCombinations(cards, 5);
    HandEvaluation? best;

    for (var combo in combinations) {
      final eval = _evaluateFiveCards(combo);
      if (best == null || eval.compareTo(best) > 0) {
        best = eval;
      }
    }

    return best!;
  }

  static List<List<Card>> _getCombinations(List<Card> cards, int k) {
    final result = <List<Card>>[];
    
    void combine(int start, List<Card> current) {
      if (current.length == k) {
        result.add(List.from(current));
        return;
      }
      for (int i = start; i < cards.length; i++) {
        current.add(cards[i]);
        combine(i + 1, current);
        current.removeLast();
      }
    }

    combine(0, []);
    return result;
  }

  static HandEvaluation _evaluateFiveCards(List<Card> cards) {
    final sorted = List<Card>.from(cards)..sort((a, b) => b.rank.compareTo(a.rank));
    
    final isFlush = cards.every((c) => c.suit == cards[0].suit);
    final isStraight = _isStraight(sorted);
    
    if (isFlush && isStraight) {
      if (sorted[0].rank == 14) {
        return HandEvaluation(HandRank.royalFlush, [14]);
      }
      return HandEvaluation(HandRank.straightFlush, [sorted[0].rank]);
    }

    final rankCounts = <int, int>{};
    for (var card in sorted) {
      rankCounts[card.rank] = (rankCounts[card.rank] ?? 0) + 1;
    }

    final counts = rankCounts.values.toList()..sort((a, b) => b.compareTo(a));
    final ranksOrdered = rankCounts.entries.toList()
      ..sort((a, b) {
        final countCompare = b.value.compareTo(a.value);
        if (countCompare != 0) return countCompare;
        return b.key.compareTo(a.key);
      });

    if (counts[0] == 4) {
      return HandEvaluation(HandRank.fourOfKind, 
        ranksOrdered.map((e) => e.key).toList());
    }

    if (counts[0] == 3 && counts[1] == 2) {
      return HandEvaluation(HandRank.fullHouse, 
        ranksOrdered.map((e) => e.key).toList());
    }

    if (isFlush) {
      return HandEvaluation(HandRank.flush, 
        sorted.map((c) => c.rank).toList());
    }

    if (isStraight) {
      return HandEvaluation(HandRank.straight, [sorted[0].rank]);
    }

    if (counts[0] == 3) {
      return HandEvaluation(HandRank.threeOfKind, 
        ranksOrdered.map((e) => e.key).toList());
    }

    if (counts[0] == 2 && counts[1] == 2) {
      return HandEvaluation(HandRank.twoPair, 
        ranksOrdered.map((e) => e.key).toList());
    }

    if (counts[0] == 2) {
      return HandEvaluation(HandRank.onePair, 
        ranksOrdered.map((e) => e.key).toList());
    }

    return HandEvaluation(HandRank.highCard, 
      sorted.map((c) => c.rank).toList());
  }

  static bool _isStraight(List<Card> sorted) {
    // Check for regular straight
    bool isRegular = true;
    for (int i = 0; i < sorted.length - 1; i++) {
      if (sorted[i].rank - sorted[i + 1].rank != 1) {
        isRegular = false;
        break;
      }
    }
    if (isRegular) return true;

    // Check for A-2-3-4-5 (wheel)
    if (sorted[0].rank == 14 && sorted[1].rank == 5 && 
        sorted[2].rank == 4 && sorted[3].rank == 3 && sorted[4].rank == 2) {
      return true;
    }

    return false;
  }
}

/// Poker simulator
class PokerSimulator {
  final Random random = Random();

  /// Simulate a hand with specific hole cards
  SimulationResult simulateHand(Card card1, Card card2, int numPlayers, int numSimulations) {
    int wins = 0;
    int losses = 0;
    int ties = 0;

    final handRankCounts = <HandRank, int>{};

    for (int i = 0; i < numSimulations; i++) {
      final deck = Deck();
      deck.shuffle();
      deck.remove(card1);
      deck.remove(card2);

      // Deal community cards
      final community = List.generate(5, (_) => deck.draw());

      // Deal opponent cards
      final opponents = <List<Card>>[];
      for (int p = 0; p < numPlayers - 1; p++) {
        opponents.add([deck.draw(), deck.draw()]);
      }

      // Evaluate hands
      final playerCards = [card1, card2, ...community];
      final playerHand = HandEvaluator.evaluate(playerCards);
      
      handRankCounts[playerHand.rank] = (handRankCounts[playerHand.rank] ?? 0) + 1;

      bool won = true;
      bool tied = false;

      for (var oppCards in opponents) {
        final oppHand = HandEvaluator.evaluate([...oppCards, ...community]);
        final compare = playerHand.compareTo(oppHand);
        
        if (compare < 0) {
          won = false;
          break;
        } else if (compare == 0) {
          tied = true;
        }
      }

      if (won && !tied) {
        wins++;
      } else if (tied) {
        ties++;
      } else {
        losses++;
      }
    }

    return SimulationResult(
      wins: wins,
      losses: losses,
      ties: ties,
      totalSimulations: numSimulations,
      handRankCounts: handRankCounts,
    );
  }

  /// Calculate pre-flop odds for common starting hands
  Map<String, double> calculatePreFlopOdds(int numPlayers, int numSimulations) {
    final results = <String, double>{};
    
    // Premium pairs
    final testHands = [
      ['AA', Card(14, 'H'), Card(14, 'D')],
      ['KK', Card(13, 'H'), Card(13, 'D')],
      ['QQ', Card(12, 'H'), Card(12, 'D')],
      ['JJ', Card(11, 'H'), Card(11, 'D')],
      ['TT', Card(10, 'H'), Card(10, 'D')],
      ['AKs', Card(14, 'H'), Card(13, 'H')],
      ['AKo', Card(14, 'H'), Card(13, 'D')],
      ['AQs', Card(14, 'H'), Card(12, 'H')],
      ['AJs', Card(14, 'H'), Card(11, 'H')],
      ['KQs', Card(13, 'H'), Card(12, 'H')],
    ];

    for (var hand in testHands) {
      final result = simulateHand(hand[1] as Card, hand[2] as Card, numPlayers, numSimulations);
      results[hand[0] as String] = result.winRate;
    }

    return results;
  }
}

/// Simulation result
class SimulationResult {
  final int wins;
  final int losses;
  final int ties;
  final int totalSimulations;
  final Map<HandRank, int> handRankCounts;

  SimulationResult({
    required this.wins,
    required this.losses,
    required this.ties,
    required this.totalSimulations,
    required this.handRankCounts,
  });

  double get winRate => (wins / totalSimulations) * 100;
  double get lossRate => (losses / totalSimulations) * 100;
  double get tieRate => (ties / totalSimulations) * 100;

  void printResults(String handName) {
    print('\n╔═══════════════════════════════════════════════════════════════════╗');
    print('║         TEXAS HOLD\'EM POKER ODDS CALCULATOR RESULTS               ║');
    print('╚═══════════════════════════════════════════════════════════════════╝');
    print('\n📈 SIMULATION PARAMETERS:');
    print('   Hand:              $handName');
    print('   Total simulations: ${totalSimulations.toString().padLeft(10)}');
    print('\n═══════════════════════════════════════════════════════════════════');
    
    print('\n📊 PRIMARY RESULTS:');
    print('   Wins:              ${wins.toString().padLeft(8)} (${winRate.toStringAsFixed(2)}%)');
    print('   Losses:            ${losses.toString().padLeft(8)} (${lossRate.toStringAsFixed(2)}%)');
    print('   Ties:              ${ties.toString().padLeft(8)} (${tieRate.toStringAsFixed(2)}%)');
    
    print('\n═══════════════════════════════════════════════════════════════════');
    print('🃏 HAND RANK DISTRIBUTION:');
    
    final sortedRanks = handRankCounts.entries.toList()
      ..sort((a, b) => b.key.index.compareTo(a.key.index));
    
    for (var entry in sortedRanks) {
      final count = entry.value;
      final pct = (count / totalSimulations * 100);
      final rankName = _handRankName(entry.key);
      final bar = '█' * (pct ~/ 2).clamp(0, 50);
      print('   ${rankName.padRight(15)}: ${count.toString().padLeft(6)} (${pct.toStringAsFixed(2)}%) $bar');
    }
    
    print('\n═══════════════════════════════════════════════════════════════════\n');
  }

  String _handRankName(HandRank rank) {
    switch (rank) {
      case HandRank.highCard: return 'High Card';
      case HandRank.onePair: return 'One Pair';
      case HandRank.twoPair: return 'Two Pair';
      case HandRank.threeOfKind: return 'Three of Kind';
      case HandRank.straight: return 'Straight';
      case HandRank.flush: return 'Flush';
      case HandRank.fullHouse: return 'Full House';
      case HandRank.fourOfKind: return 'Four of Kind';
      case HandRank.straightFlush: return 'Straight Flush';
      case HandRank.royalFlush: return 'Royal Flush';
    }
  }
}

void main() {
  print('╔═══════════════════════════════════════════════════════╗');
  print('║      TEXAS HOLD\'EM POKER ODDS CALCULATOR              ║');
  print('║      Monte Carlo Simulation                           ║');
  print('╚═══════════════════════════════════════════════════════╝\n');

  print('Choose mode:');
  print('1. Analyze specific hand');
  print('2. Calculate pre-flop odds for premium hands');
  stdout.write('\nEnter choice (1 or 2): ');
  final choice = stdin.readLineSync();

  if (choice == '2') {
    stdout.write('Number of players (2-10, default 6): ');
    final playersInput = stdin.readLineSync();
    final numPlayers = int.tryParse(playersInput ?? '') ?? 6;

    stdout.write('Number of simulations per hand (default 100000): ');
    final simInput = stdin.readLineSync();
    final numSimulations = int.tryParse(simInput ?? '') ?? 100000;

    print('\n⏳ Running simulations for premium starting hands...\n');

    final simulator = PokerSimulator();
    final stopwatch = Stopwatch()..start();
    final results = simulator.calculatePreFlopOdds(numPlayers, numSimulations);
    stopwatch.stop();

    print('╔═══════════════════════════════════════════════════════════════════╗');
    print('║         PRE-FLOP ODDS FOR PREMIUM HANDS ($numPlayers players)              ║');
    print('╚═══════════════════════════════════════════════════════════════════╝\n');

    final sortedHands = results.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    print('   Hand  │  Win Rate  │ Visual');
    print('   ──────┼────────────┼────────────────────────────────────');
    for (var entry in sortedHands) {
      final bar = '█' * (entry.value ~/ 2).clamp(0, 50);
      print('   ${entry.key.padRight(5)} │  ${entry.value.toStringAsFixed(2)}%   │ $bar');
    }

    print('\n⏱️  Simulation time: ${stopwatch.elapsedMilliseconds}ms');
    print('   Total hands simulated: ${results.length * numSimulations}');
    print('\n═══════════════════════════════════════════════════════════════════\n');

  } else {
    // Specific hand analysis
    print('\n📝 Enter your hole cards (e.g., A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, 2)');
    print('   Suits: H (Hearts), D (Diamonds), C (Clubs), S (Spades)');
    print('   Example: AH KD\n');

    stdout.write('First card (rank + suit, e.g., AH): ');
    final card1Input = stdin.readLineSync()?.toUpperCase();
    if (card1Input == null || card1Input.length < 2) {
      print('Invalid input');
      return;
    }

    stdout.write('Second card (rank + suit, e.g., KD): ');
    final card2Input = stdin.readLineSync()?.toUpperCase();
    if (card2Input == null || card2Input.length < 2) {
      print('Invalid input');
      return;
    }

    final card1 = _parseCard(card1Input);
    final card2 = _parseCard(card2Input);

    if (card1 == null || card2 == null) {
      print('Invalid card format');
      return;
    }

    stdout.write('Number of players (2-10, default 6): ');
    final playersInput = stdin.readLineSync();
    final numPlayers = int.tryParse(playersInput ?? '') ?? 6;

    stdout.write('Number of simulations (default 100000): ');
    final simInput = stdin.readLineSync();
    final numSimulations = int.tryParse(simInput ?? '') ?? 100000;

    print('\n⏳ Running $numSimulations simulations...\n');

    final simulator = PokerSimulator();
    final stopwatch = Stopwatch()..start();
    final result = simulator.simulateHand(card1, card2, numPlayers, numSimulations);
    stopwatch.stop();

    result.printResults('$card1 $card2');

    print('⏱️  PERFORMANCE:');
    print('   Simulation time:       ${stopwatch.elapsedMilliseconds}ms');
    print('   Hands per second:      ${(numSimulations / (stopwatch.elapsedMilliseconds / 1000)).toStringAsFixed(0)}');

    print('\n💡 KEY INSIGHTS:');
    print('   • Win rate: ${result.winRate.toStringAsFixed(2)}%');
    print('   • Against ${numPlayers - 1} opponent(s)');
    if (result.winRate > 50) {
      print('   • ✓ Strong hand - favorable to play');
    } else if (result.winRate > 30) {
      print('   • ⚠ Marginal hand - play cautiously');
    } else {
      print('   • ✗ Weak hand - consider folding');
    }

    print('\n═══════════════════════════════════════════════════════════════════\n');
  }
}

Card? _parseCard(String input) {
  if (input.length < 2) return null;
  
  final rankChar = input[0];
  final suitChar = input[1];

  int? rank;
  if (rankChar == 'A') rank = 14;
  else if (rankChar == 'K') rank = 13;
  else if (rankChar == 'Q') rank = 12;
  else if (rankChar == 'J') rank = 11;
  else if (rankChar == 'T') rank = 10;
  else rank = int.tryParse(rankChar);

  if (rank == null || rank < 2 || rank > 14) return null;
  if (!['H', 'D', 'C', 'S'].contains(suitChar)) return null;

  return Card(rank, suitChar);
}
