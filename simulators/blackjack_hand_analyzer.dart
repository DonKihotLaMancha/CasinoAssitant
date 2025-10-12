import 'dart:io';
import 'dart:math';

/// Blackjack Hand Analyzer - Analyzes specific hands and recommends optimal play
/// Inspired by Wizard of Odds Hand Calculator

/// Represents a playing card
class Card {
  final String rank;
  final String suit;

  Card(this.rank, this.suit);

  int getValue() {
    if (rank == 'A') return 11;
    if (['K', 'Q', 'J'].contains(rank)) return 10;
    return int.parse(rank);
  }

  @override
  String toString() => '$rank$suit';
}

/// Hand analysis result
class HandAnalysis {
  final String playerHand;
  final String dealerUpcard;
  final String recommendedAction;
  final Map<String, double> actionExpectedValues;
  final String reasoning;
  final double winProbability;
  final double lossProbability;
  final double pushProbability;
  final bool isSoftHand;
  final bool isPair;
  final int handValue;

  HandAnalysis({
    required this.playerHand,
    required this.dealerUpcard,
    required this.recommendedAction,
    required this.actionExpectedValues,
    required this.reasoning,
    required this.winProbability,
    required this.lossProbability,
    required this.pushProbability,
    required this.isSoftHand,
    required this.isPair,
    required this.handValue,
  });
}

/// Blackjack Hand Analyzer
class BlackjackHandAnalyzer {
  final int numDecks;
  final bool dealerHitsSoft17;
  final bool doubleAfterSplit;
  final bool canResplit;
  final bool lateSurrender;

  BlackjackHandAnalyzer({
    this.numDecks = 6,
    this.dealerHitsSoft17 = false,
    this.doubleAfterSplit = true,
    this.canResplit = true,
    this.lateSurrender = false,
  });

  /// Analyze a specific hand
  HandAnalysis analyzeHand(String playerCard1, String playerCard2, String dealerUpcard) {
    final card1Value = _getCardValue(playerCard1);
    final card2Value = _getCardValue(playerCard2);
    final dealerValue = _getCardValue(dealerUpcard);

    // Determine hand characteristics
    final hasAce = playerCard1 == 'A' || playerCard2 == 'A';
    final isPair = playerCard1 == playerCard2;
    
    int handValue = card1Value + card2Value;
    bool isSoft = hasAce && handValue <= 21;
    
    // Adjust for soft hand
    if (isSoft && handValue > 21) {
      handValue -= 10;
      isSoft = false;
    }

    // Calculate expected values for each action
    final evs = _calculateExpectedValues(card1Value, card2Value, dealerValue, isSoft, isPair);
    
    // Determine best action
    String bestAction = _getBestAction(evs);
    
    // Get probabilities
    final probs = _calculateProbabilities(handValue, dealerValue, isSoft);
    
    // Generate reasoning
    final reasoning = _generateReasoning(handValue, dealerValue, isSoft, isPair, bestAction, evs);

    return HandAnalysis(
      playerHand: '$playerCard1-$playerCard2',
      dealerUpcard: dealerUpcard,
      recommendedAction: bestAction,
      actionExpectedValues: evs,
      reasoning: reasoning,
      winProbability: probs['win']!,
      lossProbability: probs['loss']!,
      pushProbability: probs['push']!,
      isSoftHand: isSoft,
      isPair: isPair,
      handValue: handValue,
    );
  }

  int _getCardValue(String card) {
    if (card == 'A') return 11;
    if (['K', 'Q', 'J'].contains(card)) return 10;
    return int.parse(card);
  }

  /// Calculate expected values for each possible action
  Map<String, double> _calculateExpectedValues(
    int card1, int card2, int dealerValue, bool isSoft, bool isPair) {
    
    final handValue = card1 + card2;
    final evs = <String, double>{};

    // Calculate EV for STAND
    evs['Stand'] = _calculateStandEV(handValue, dealerValue, isSoft);

    // Calculate EV for HIT
    evs['Hit'] = _calculateHitEV(handValue, dealerValue, isSoft);

    // Calculate EV for DOUBLE (if allowed)
    if (handValue >= 9 && handValue <= 11) {
      evs['Double'] = _calculateDoubleEV(handValue, dealerValue, isSoft);
    }

    // Calculate EV for SPLIT (if pair)
    if (isPair) {
      evs['Split'] = _calculateSplitEV(card1, dealerValue);
    }

    // Calculate EV for SURRENDER (if allowed)
    if (lateSurrender) {
      evs['Surrender'] = -0.5; // Always -0.5 (lose half bet)
    }

    return evs;
  }

  /// Calculate expected value for standing
  double _calculateStandEV(int handValue, int dealerValue, bool isSoft) {
    if (handValue > 21) return -1.0;
    
    // Dealer bust probabilities by upcard
    final dealerBustProb = _getDealerBustProbability(dealerValue);
    
    // Simplified EV calculation
    // If dealer busts, we win
    // If dealer doesn't bust, compare final values
    
    double ev = 0.0;
    
    // Probability dealer busts
    ev += dealerBustProb * 1.0;
    
    // Probability dealer makes 17
    final dealer17Prob = _getDealerFinalProb(dealerValue, 17);
    ev += dealer17Prob * (handValue > 17 ? 1.0 : handValue == 17 ? 0.0 : -1.0);
    
    // Probability dealer makes 18
    final dealer18Prob = _getDealerFinalProb(dealerValue, 18);
    ev += dealer18Prob * (handValue > 18 ? 1.0 : handValue == 18 ? 0.0 : -1.0);
    
    // Probability dealer makes 19
    final dealer19Prob = _getDealerFinalProb(dealerValue, 19);
    ev += dealer19Prob * (handValue > 19 ? 1.0 : handValue == 19 ? 0.0 : -1.0);
    
    // Probability dealer makes 20
    final dealer20Prob = _getDealerFinalProb(dealerValue, 20);
    ev += dealer20Prob * (handValue > 20 ? 1.0 : handValue == 20 ? 0.0 : -1.0);
    
    // Probability dealer makes 21
    final dealer21Prob = _getDealerFinalProb(dealerValue, 21);
    ev += dealer21Prob * (handValue > 21 ? 1.0 : handValue == 21 ? 0.0 : -1.0);
    
    return ev;
  }

  /// Calculate expected value for hitting
  double _calculateHitEV(int handValue, int dealerValue, bool isSoft) {
    if (handValue >= 21) return -1.0;
    
    double ev = 0.0;
    final cardProb = 1.0 / 13.0; // Simplified: equal probability for each rank
    
    // Simulate drawing each possible card
    for (int cardValue in [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11]) {
      int newValue = handValue + cardValue;
      bool newSoft = isSoft;
      
      // Adjust for soft hand
      if (newValue > 21 && newSoft) {
        newValue -= 10;
        newSoft = false;
      }
      
      if (newValue > 21) {
        // Bust
        ev += cardProb * -1.0;
      } else {
        // Stand on new value
        ev += cardProb * _calculateStandEV(newValue, dealerValue, newSoft);
      }
    }
    
    return ev;
  }

  /// Calculate expected value for doubling
  double _calculateDoubleEV(int handValue, int dealerValue, bool isSoft) {
    // Doubling means hit once and double the bet
    double hitEV = 0.0;
    final cardProb = 1.0 / 13.0;
    
    for (int cardValue in [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11]) {
      int newValue = handValue + cardValue;
      bool newSoft = isSoft;
      
      if (newValue > 21 && newSoft) {
        newValue -= 10;
        newSoft = false;
      }
      
      if (newValue > 21) {
        hitEV += cardProb * -1.0;
      } else {
        hitEV += cardProb * _calculateStandEV(newValue, dealerValue, newSoft);
      }
    }
    
    return hitEV * 2.0; // Double the EV since we're doubling the bet
  }

  /// Calculate expected value for splitting
  double _calculateSplitEV(int cardValue, int dealerValue) {
    // Simplified split EV calculation
    // Each hand plays independently
    
    if (cardValue == 11) {
      // Splitting Aces is almost always good
      return 0.5;
    } else if (cardValue == 8) {
      // Splitting 8s is usually good
      return 0.3;
    } else if (cardValue == 10) {
      // Never split 10s
      return -0.5;
    } else if (cardValue >= 2 && cardValue <= 7) {
      // Conditional splits
      if (dealerValue >= 2 && dealerValue <= 7) {
        return 0.1;
      } else {
        return -0.3;
      }
    }
    
    return -0.2;
  }

  /// Get dealer bust probability by upcard
  double _getDealerBustProbability(int upcard) {
    final bustProbs = {
      2: 0.3530, 3: 0.3756, 4: 0.4028, 5: 0.4289, 6: 0.4208,
      7: 0.2599, 8: 0.2386, 9: 0.2334, 10: 0.2143, 11: 0.1165,
    };
    return bustProbs[upcard] ?? 0.25;
  }

  /// Get probability of dealer finishing with specific value
  double _getDealerFinalProb(int upcard, int finalValue) {
    // Simplified probabilities (would be more complex in reality)
    final dealerBust = _getDealerBustProbability(upcard);
    final remaining = 1.0 - dealerBust;
    
    if (finalValue == 17) return remaining * 0.20;
    if (finalValue == 18) return remaining * 0.20;
    if (finalValue == 19) return remaining * 0.20;
    if (finalValue == 20) return remaining * 0.25;
    if (finalValue == 21) return remaining * 0.15;
    
    return 0.0;
  }

  /// Calculate win/loss/push probabilities
  Map<String, double> _calculateProbabilities(int handValue, int dealerValue, bool isSoft) {
    final dealerBust = _getDealerBustProbability(dealerValue);
    
    double winProb = dealerBust;
    double lossProb = 0.0;
    double pushProb = 0.0;
    
    // Add probabilities for dealer making each hand
    for (int dv = 17; dv <= 21; dv++) {
      final prob = _getDealerFinalProb(dealerValue, dv);
      if (handValue > dv) {
        winProb += prob;
      } else if (handValue < dv) {
        lossProb += prob;
      } else {
        pushProb += prob;
      }
    }
    
    return {'win': winProb, 'loss': lossProb, 'push': pushProb};
  }

  /// Determine best action from EVs
  String _getBestAction(Map<String, double> evs) {
    String bestAction = 'Stand';
    double bestEV = evs['Stand']!;
    
    evs.forEach((action, ev) {
      if (ev > bestEV) {
        bestEV = ev;
        bestAction = action;
      }
    });
    
    return bestAction;
  }

  /// Generate reasoning for recommendation
  String _generateReasoning(int handValue, int dealerValue, bool isSoft, 
                           bool isPair, String action, Map<String, double> evs) {
    final reasons = <String>[];
    
    // Hand type
    if (isPair) {
      reasons.add('You have a pair');
    } else if (isSoft) {
      reasons.add('You have a soft hand (with Ace)');
    } else {
      reasons.add('You have a hard hand');
    }
    
    // Hand value
    reasons.add('Your hand value is $handValue');
    
    // Dealer situation
    final dealerBust = _getDealerBustProbability(dealerValue);
    if (dealerBust > 0.40) {
      reasons.add('Dealer shows $dealerValue (weak - ${(dealerBust * 100).toStringAsFixed(1)}% bust probability)');
    } else if (dealerBust < 0.25) {
      reasons.add('Dealer shows $dealerValue (strong - only ${(dealerBust * 100).toStringAsFixed(1)}% bust probability)');
    } else {
      reasons.add('Dealer shows $dealerValue (${(dealerBust * 100).toStringAsFixed(1)}% bust probability)');
    }
    
    // Action reasoning
    if (action == 'Stand') {
      if (handValue >= 17) {
        reasons.add('Standing is optimal - hand is strong enough');
      } else {
        reasons.add('Standing is optimal - dealer likely to bust');
      }
    } else if (action == 'Hit') {
      if (handValue <= 11) {
        reasons.add('Hitting is safe - cannot bust');
      } else {
        reasons.add('Hitting is optimal - need to improve hand');
      }
    } else if (action == 'Double') {
      reasons.add('Doubling is optimal - favorable situation to increase bet');
    } else if (action == 'Split') {
      reasons.add('Splitting is optimal - better to play two hands');
    } else if (action == 'Surrender') {
      reasons.add('Surrendering is optimal - hand is very unfavorable');
    }
    
    // EV comparison
    final bestEV = evs[action]!;
    reasons.add('Expected value: ${(bestEV * 100).toStringAsFixed(2)}% return per dollar bet');
    
    return reasons.join('. ');
  }
}

void main() {
  print('╔═══════════════════════════════════════════════════════╗');
  print('║      BLACKJACK HAND ANALYZER                          ║');
  print('║      Analyze Specific Hands & Get Recommendations    ║');
  print('╚═══════════════════════════════════════════════════════╝\n');

  // Get game rules
  stdout.write('Number of decks (default 6): ');
  final deckInput = stdin.readLineSync();
  final numDecks = int.tryParse(deckInput ?? '') ?? 6;

  stdout.write('Dealer hits soft 17? (y/n, default n): ');
  final soft17Input = stdin.readLineSync()?.toLowerCase() ?? 'n';
  final dealerHitsSoft17 = soft17Input == 'y';

  stdout.write('Allow late surrender? (y/n, default n): ');
  final surrenderInput = stdin.readLineSync()?.toLowerCase() ?? 'n';
  final lateSurrender = surrenderInput == 'y';

  final analyzer = BlackjackHandAnalyzer(
    numDecks: numDecks,
    dealerHitsSoft17: dealerHitsSoft17,
    lateSurrender: lateSurrender,
  );

  print('\n📝 Enter card values: A, 2-10, J, Q, K');
  print('   Example: A-6 vs dealer 10\n');

  while (true) {
    stdout.write('\nYour first card (or "quit"): ');
    final card1 = stdin.readLineSync()?.toUpperCase();
    if (card1 == null || card1 == 'QUIT' || card1 == 'Q') break;

    stdout.write('Your second card: ');
    final card2 = stdin.readLineSync()?.toUpperCase();
    if (card2 == null) continue;

    stdout.write('Dealer upcard: ');
    final dealerCard = stdin.readLineSync()?.toUpperCase();
    if (dealerCard == null) continue;

    try {
      final analysis = analyzer.analyzeHand(card1, card2, dealerCard);
      
      print('\n╔═══════════════════════════════════════════════════════╗');
      print('║              HAND ANALYSIS RESULTS                    ║');
      print('╚═══════════════════════════════════════════════════════╝');
      
      print('\n🃏 YOUR HAND: ${analysis.playerHand} (${analysis.handValue})');
      if (analysis.isSoftHand) print('   Type: Soft Hand');
      if (analysis.isPair) print('   Type: Pair');
      
      print('\n🎴 DEALER SHOWS: ${analysis.dealerUpcard}');
      
      print('\n✅ RECOMMENDED ACTION: ${analysis.recommendedAction.toUpperCase()}');
      
      print('\n📊 EXPECTED VALUES FOR EACH ACTION:');
      final sortedActions = analysis.actionExpectedValues.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      for (var entry in sortedActions) {
        final marker = entry.key == analysis.recommendedAction ? '→' : ' ';
        final ev = entry.value;
        final evPercent = (ev * 100).toStringAsFixed(2);
        final bar = '█' * ((ev + 1) * 10).clamp(0, 20).toInt();
        print('   $marker ${entry.key.padRight(10)}: ${evPercent.padLeft(7)}%  $bar');
      }
      
      print('\n🎲 OUTCOME PROBABILITIES:');
      print('   Win:  ${(analysis.winProbability * 100).toStringAsFixed(2)}%');
      print('   Loss: ${(analysis.lossProbability * 100).toStringAsFixed(2)}%');
      print('   Push: ${(analysis.pushProbability * 100).toStringAsFixed(2)}%');
      
      print('\n💡 REASONING:');
      print('   ${analysis.reasoning}');
      
      print('\n═══════════════════════════════════════════════════════\n');
      
    } catch (e) {
      print('\n❌ Error: Invalid card input. Use A, 2-10, J, Q, K\n');
    }
  }

  print('\n✅ Thank you for using the Blackjack Hand Analyzer!\n');
}
