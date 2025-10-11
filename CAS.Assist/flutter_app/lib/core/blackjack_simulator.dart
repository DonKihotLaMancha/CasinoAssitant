import 'dart:math';

// Copy the core logic from blackjack_odds.dart and blackjack_hand_analyzer.dart
// This file contains all the simulation and analysis logic

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

  int getValue() {
    int value = 0;
    int aces = 0;

    for (var card in cards) {
      value += card.getValue();
      if (card.rank == 'A') aces++;
    }

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

  GameData playHandDetailed({bool useBasicStrategy = true}) {
    final deck = Deck(numDecks: numDecks);
    deck.shuffle();

    final playerHand = Hand();
    final dealerHand = Hand();

    playerHand.addCard(deck.draw());
    dealerHand.addCard(deck.draw());
    playerHand.addCard(deck.draw());
    dealerHand.addCard(deck.draw());

    final dealerUpcard = dealerHand.cards[0].getValue();
    final playerInitialValue = playerHand.getValue();
    final playerHadBlackjack = playerHand.isBlackjack;
    final dealerHadBlackjack = dealerHand.isBlackjack;

    GameResult result;

    if (playerHand.isBlackjack && dealerHand.isBlackjack) {
      result = GameResult.push;
    } else if (playerHand.isBlackjack) {
      result = GameResult.playerBlackjack;
    } else if (dealerHand.isBlackjack) {
      result = GameResult.dealerBlackjack;
    } else {
      if (useBasicStrategy) {
        _playBasicStrategy(playerHand, dealerHand.cards[0], deck);
      } else {
        _playSimpleStrategy(playerHand, deck);
      }

      if (playerHand.isBusted) {
        result = GameResult.playerBust;
      } else {
        while (dealerHand.getValue() < 17) {
          dealerHand.addCard(deck.draw());
        }

        if (dealerHand.isBusted) {
          result = GameResult.dealerBust;
        } else {
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

  void _playSimpleStrategy(Hand hand, Deck deck) {
    while (hand.getValue() < 17) {
      hand.addCard(deck.draw());
    }
  }

  void _playBasicStrategy(Hand hand, Card dealerUpCard, Deck deck) {
    final dealerValue = dealerUpCard.getValue();
    
    while (!hand.isBusted) {
      final handValue = hand.getValue();
      final hasAce = hand.cards.any((c) => c.rank == 'A') && handValue <= 21;

      bool shouldHit = false;

      if (hasAce && handValue < 19) {
        shouldHit = true;
      } else if (handValue < 12) {
        shouldHit = true;
      } else if (handValue == 12) {
        shouldHit = dealerValue >= 2 && dealerValue <= 3 || dealerValue >= 7;
      } else if (handValue >= 13 && handValue <= 16) {
        shouldHit = dealerValue >= 7;
      } else {
        shouldHit = false;
      }

      if (shouldHit) {
        hand.addCard(deck.draw());
      } else {
        break;
      }
    }
  }

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

/// Enhanced simulation results
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

  Map<int, Map<String, double>> getDealerUpcardAnalysis() {
    final upcardStats = <int, Map<String, int>>{};
    
    for (var game in gameDataList) {
      final upcard = game.dealerUpcard;
      upcardStats[upcard] ??= {'wins': 0, 'losses': 0, 'pushes': 0, 'total': 0};
      
      if ([GameResult.dealerWin, GameResult.dealerBlackjack, GameResult.playerBust].contains(game.result)) {
        upcardStats[upcard]!['wins'] = (upcardStats[upcard]!['wins'] ?? 0) + 1;
      } else if ([GameResult.playerWin, GameResult.playerBlackjack, GameResult.dealerBust].contains(game.result)) {
        upcardStats[upcard]!['losses'] = (upcardStats[upcard]!['losses'] ?? 0) + 1;
      } else {
        upcardStats[upcard]!['pushes'] = (upcardStats[upcard]!['pushes'] ?? 0) + 1;
      }
      upcardStats[upcard]!['total'] = (upcardStats[upcard]!['total'] ?? 0) + 1;
    }

    final analysis = <int, Map<String, double>>{};
    upcardStats.forEach((upcard, stats) {
      final total = stats['total']!.toDouble();
      if (total > 0) {
        analysis[upcard] = {
          'dealerWinRate': (stats['wins']! / total) * 100,
          'playerWinRate': (stats['losses']! / total) * 100,
          'pushRate': (stats['pushes']! / total) * 100,
          'count': total,
        };
      }
    });

    return analysis;
  }

  Map<int, int> getPlayerHandDistribution() {
    final distribution = <int, int>{};
    for (var game in gameDataList) {
      final value = game.playerFinalValue > 21 ? 0 : game.playerFinalValue;
      distribution[value] = (distribution[value] ?? 0) + 1;
    }
    return distribution;
  }

  Map<int, int> getDealerHandDistribution() {
    final distribution = <int, int>{};
    for (var game in gameDataList) {
      final value = game.dealerFinalValue > 21 ? 0 : game.dealerFinalValue;
      distribution[value] = (distribution[value] ?? 0) + 1;
    }
    return distribution;
  }
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

  BlackjackHandAnalyzer({this.numDecks = 6});

  HandAnalysis analyzeHand(String playerCard1, String playerCard2, String dealerUpcard) {
    final card1Value = _getCardValue(playerCard1);
    final card2Value = _getCardValue(playerCard2);
    final dealerValue = _getCardValue(dealerUpcard);

    final hasAce = playerCard1 == 'A' || playerCard2 == 'A';
    final isPair = playerCard1 == playerCard2;
    
    int handValue = card1Value + card2Value;
    bool isSoft = hasAce && handValue <= 21;
    
    if (isSoft && handValue > 21) {
      handValue -= 10;
      isSoft = false;
    }

    final evs = _calculateExpectedValues(card1Value, card2Value, dealerValue, isSoft, isPair);
    String bestAction = _getBestAction(evs);
    final probs = _calculateProbabilities(handValue, dealerValue, isSoft);
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

  Map<String, double> _calculateExpectedValues(int card1, int card2, int dealerValue, bool isSoft, bool isPair) {
    final handValue = card1 + card2;
    final evs = <String, double>{};

    evs['Stand'] = _calculateStandEV(handValue, dealerValue, isSoft);
    evs['Hit'] = _calculateHitEV(handValue, dealerValue, isSoft);

    if (handValue >= 9 && handValue <= 11) {
      evs['Double'] = _calculateDoubleEV(handValue, dealerValue, isSoft);
    }

    if (isPair) {
      evs['Split'] = _calculateSplitEV(card1, dealerValue);
    }

    return evs;
  }

  double _calculateStandEV(int handValue, int dealerValue, bool isSoft) {
    if (handValue > 21) return -1.0;
    
    final dealerBustProb = _getDealerBustProbability(dealerValue);
    double ev = dealerBustProb * 1.0;
    
    for (int dv = 17; dv <= 21; dv++) {
      final prob = _getDealerFinalProb(dealerValue, dv);
      ev += prob * (handValue > dv ? 1.0 : handValue == dv ? 0.0 : -1.0);
    }
    
    return ev;
  }

  double _calculateHitEV(int handValue, int dealerValue, bool isSoft) {
    if (handValue >= 21) return -1.0;
    
    double ev = 0.0;
    final cardProb = 1.0 / 13.0;
    
    for (int cardValue in [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11]) {
      int newValue = handValue + cardValue;
      bool newSoft = isSoft;
      
      if (newValue > 21 && newSoft) {
        newValue -= 10;
        newSoft = false;
      }
      
      if (newValue > 21) {
        ev += cardProb * -1.0;
      } else {
        ev += cardProb * _calculateStandEV(newValue, dealerValue, newSoft);
      }
    }
    
    return ev;
  }

  double _calculateDoubleEV(int handValue, int dealerValue, bool isSoft) {
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
    
    return hitEV * 2.0;
  }

  double _calculateSplitEV(int cardValue, int dealerValue) {
    if (cardValue == 11) return 0.5;
    if (cardValue == 8) return 0.3;
    if (cardValue == 10) return -0.5;
    if (cardValue >= 2 && cardValue <= 7) {
      return (dealerValue >= 2 && dealerValue <= 7) ? 0.1 : -0.3;
    }
    return -0.2;
  }

  double _getDealerBustProbability(int upcard) {
    final bustProbs = {
      2: 0.3530, 3: 0.3756, 4: 0.4028, 5: 0.4289, 6: 0.4208,
      7: 0.2599, 8: 0.2386, 9: 0.2334, 10: 0.2143, 11: 0.1165,
    };
    return bustProbs[upcard] ?? 0.25;
  }

  double _getDealerFinalProb(int upcard, int finalValue) {
    final dealerBust = _getDealerBustProbability(upcard);
    final remaining = 1.0 - dealerBust;
    
    if (finalValue == 17) return remaining * 0.20;
    if (finalValue == 18) return remaining * 0.20;
    if (finalValue == 19) return remaining * 0.20;
    if (finalValue == 20) return remaining * 0.25;
    if (finalValue == 21) return remaining * 0.15;
    
    return 0.0;
  }

  Map<String, double> _calculateProbabilities(int handValue, int dealerValue, bool isSoft) {
    final dealerBust = _getDealerBustProbability(dealerValue);
    
    double winProb = dealerBust;
    double lossProb = 0.0;
    double pushProb = 0.0;
    
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

  String _generateReasoning(int handValue, int dealerValue, bool isSoft, bool isPair, String action, Map<String, double> evs) {
    final reasons = <String>[];
    
    if (isPair) {
      reasons.add('You have a pair');
    } else if (isSoft) {
      reasons.add('You have a soft hand (with Ace)');
    } else {
      reasons.add('You have a hard hand');
    }
    
    reasons.add('Your hand value is $handValue');
    
    final dealerBust = _getDealerBustProbability(dealerValue);
    if (dealerBust > 0.40) {
      reasons.add('Dealer shows $dealerValue (weak - ${(dealerBust * 100).toStringAsFixed(1)}% bust probability)');
    } else if (dealerBust < 0.25) {
      reasons.add('Dealer shows $dealerValue (strong - only ${(dealerBust * 100).toStringAsFixed(1)}% bust probability)');
    } else {
      reasons.add('Dealer shows $dealerValue (${(dealerBust * 100).toStringAsFixed(1)}% bust probability)');
    }
    
    final bestEV = evs[action]!;
    reasons.add('Expected value: ${(bestEV * 100).toStringAsFixed(2)}% return per dollar bet');
    
    return reasons.join('. ');
  }
}
