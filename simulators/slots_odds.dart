import 'dart:io';
import 'dart:math';

/// Slot Machine Odds Calculator with Monte Carlo Simulation
/// Simulates various slot machine configurations and payouts

enum Symbol {
  cherry,
  lemon,
  orange,
  plum,
  bell,
  bar,
  seven,
  diamond,
  wild,
}

class SlotMachine {
  final List<List<Symbol>> reels;
  final Map<String, int> payTable;
  final int numReels;
  final Random random = Random();

  SlotMachine({
    required this.reels,
    required this.payTable,
    required this.numReels,
  });

  /// Classic 3-reel slot machine
  factory SlotMachine.classic() {
    final reels = [
      // Reel 1 - 20 symbols
      [
        Symbol.cherry, Symbol.cherry, Symbol.cherry,
        Symbol.lemon, Symbol.lemon,
        Symbol.orange, Symbol.orange,
        Symbol.plum, Symbol.plum,
        Symbol.bell, Symbol.bell,
        Symbol.bar, Symbol.bar,
        Symbol.seven,
        Symbol.diamond, Symbol.diamond, Symbol.diamond,
        Symbol.wild,
      ],
      // Reel 2 - 20 symbols
      [
        Symbol.cherry, Symbol.cherry,
        Symbol.lemon, Symbol.lemon, Symbol.lemon,
        Symbol.orange, Symbol.orange,
        Symbol.plum, Symbol.plum,
        Symbol.bell, Symbol.bell,
        Symbol.bar, Symbol.bar,
        Symbol.seven,
        Symbol.diamond, Symbol.diamond,
        Symbol.wild,
      ],
      // Reel 3 - 20 symbols
      [
        Symbol.cherry, Symbol.cherry,
        Symbol.lemon, Symbol.lemon, Symbol.lemon,
        Symbol.orange, Symbol.orange, Symbol.orange,
        Symbol.plum, Symbol.plum,
        Symbol.bell,
        Symbol.bar, Symbol.bar,
        Symbol.seven,
        Symbol.diamond,
        Symbol.wild,
      ],
    ];

    final payTable = {
      'SEVEN-SEVEN-SEVEN': 1000,
      'DIAMOND-DIAMOND-DIAMOND': 500,
      'BAR-BAR-BAR': 100,
      'BELL-BELL-BELL': 50,
      'PLUM-PLUM-PLUM': 25,
      'ORANGE-ORANGE-ORANGE': 15,
      'LEMON-LEMON-LEMON': 10,
      'CHERRY-CHERRY-CHERRY': 5,
      'CHERRY-CHERRY-ANY': 2,
      'CHERRY-ANY-ANY': 1,
      'WILD-ANY-ANY': 2,
      'ANY-WILD-ANY': 2,
      'ANY-ANY-WILD': 2,
    };

    return SlotMachine(reels: reels, payTable: payTable, numReels: 3);
  }

  /// Modern 5-reel video slot
  factory SlotMachine.modern() {
    final baseReel = [
      Symbol.cherry, Symbol.cherry, Symbol.cherry,
      Symbol.lemon, Symbol.lemon, Symbol.lemon,
      Symbol.orange, Symbol.orange,
      Symbol.plum, Symbol.plum,
      Symbol.bell, Symbol.bell,
      Symbol.bar,
      Symbol.seven,
      Symbol.diamond,
      Symbol.wild,
    ];

    final reels = List.generate(5, (_) => List<Symbol>.from(baseReel));

    final payTable = {
      'SEVEN-SEVEN-SEVEN-SEVEN-SEVEN': 10000,
      'DIAMOND-DIAMOND-DIAMOND-DIAMOND-DIAMOND': 5000,
      'BAR-BAR-BAR-BAR-BAR': 1000,
      'BELL-BELL-BELL-BELL-BELL': 500,
      'PLUM-PLUM-PLUM-PLUM-PLUM': 250,
      'ORANGE-ORANGE-ORANGE-ORANGE-ORANGE': 150,
      'LEMON-LEMON-LEMON-LEMON-LEMON': 100,
      'CHERRY-CHERRY-CHERRY-CHERRY-CHERRY': 50,
      'SEVEN-SEVEN-SEVEN-SEVEN': 1000,
      'DIAMOND-DIAMOND-DIAMOND-DIAMOND': 500,
      'BAR-BAR-BAR-BAR': 100,
      'BELL-BELL-BELL-BELL': 50,
      'SEVEN-SEVEN-SEVEN': 100,
      'DIAMOND-DIAMOND-DIAMOND': 50,
      'BAR-BAR-BAR': 25,
      'BELL-BELL-BELL': 15,
    };

    return SlotMachine(reels: reels, payTable: payTable, numReels: 5);
  }

  List<Symbol> spin() {
    final result = <Symbol>[];
    for (var reel in reels) {
      result.add(reel[random.nextInt(reel.length)]);
    }
    return result;
  }

  int calculatePayout(List<Symbol> symbols) {
    // Check for exact matches first
    final key = symbols.map((s) => _symbolName(s)).join('-');
    if (payTable.containsKey(key)) {
      return payTable[key]!;
    }

    // Check for wild substitutions
    final hasWild = symbols.contains(Symbol.wild);
    if (hasWild) {
      // Try replacing wilds with each symbol type
      for (var testSymbol in Symbol.values) {
        if (testSymbol == Symbol.wild) continue;
        
        final testSymbols = symbols.map((s) => s == Symbol.wild ? testSymbol : s).toList();
        final testKey = testSymbols.map((s) => _symbolName(s)).join('-');
        if (payTable.containsKey(testKey)) {
          return payTable[testKey]!;
        }
      }
    }

    // Check for partial matches (3-reel specific)
    if (numReels == 3) {
      // Cherry special cases
      if (symbols[0] == Symbol.cherry && symbols[1] == Symbol.cherry) {
        return payTable['CHERRY-CHERRY-ANY'] ?? 0;
      }
      if (symbols[0] == Symbol.cherry) {
        return payTable['CHERRY-ANY-ANY'] ?? 0;
      }
      
      // Wild special cases
      if (symbols.contains(Symbol.wild)) {
        return payTable['WILD-ANY-ANY'] ?? 0;
      }
    }

    return 0;
  }

  String _symbolName(Symbol symbol) {
    return symbol.toString().split('.').last.toUpperCase();
  }

  String symbolToEmoji(Symbol symbol) {
    switch (symbol) {
      case Symbol.cherry: return '🍒';
      case Symbol.lemon: return '🍋';
      case Symbol.orange: return '🍊';
      case Symbol.plum: return '🍇';
      case Symbol.bell: return '🔔';
      case Symbol.bar: return '💎';
      case Symbol.seven: return '7️⃣';
      case Symbol.diamond: return '💠';
      case Symbol.wild: return '⭐';
    }
  }
}

class SlotSimulator {
  final SlotMachine machine;

  SlotSimulator(this.machine);

  SimulationResults runSimulations(int numSimulations, double betAmount) {
    int totalWins = 0;
    int totalLosses = 0;
    double totalPayout = 0;
    double totalWagered = numSimulations * betAmount;

    final payoutDistribution = <int, int>{};
    final symbolCombinations = <String, int>{};

    for (int i = 0; i < numSimulations; i++) {
      final symbols = machine.spin();
      final payout = machine.calculatePayout(symbols);
      
      final comboKey = symbols.map((s) => machine._symbolName(s)).join('-');
      symbolCombinations[comboKey] = (symbolCombinations[comboKey] ?? 0) + 1;

      if (payout > 0) {
        totalWins++;
        totalPayout += payout * betAmount;
        payoutDistribution[payout] = (payoutDistribution[payout] ?? 0) + 1;
      } else {
        totalLosses++;
      }
    }

    return SimulationResults(
      totalSpins: numSimulations,
      wins: totalWins,
      losses: totalLosses,
      totalPayout: totalPayout,
      totalWagered: totalWagered,
      betAmount: betAmount,
      payoutDistribution: payoutDistribution,
      symbolCombinations: symbolCombinations,
      numReels: machine.numReels,
    );
  }
}

class SimulationResults {
  final int totalSpins;
  final int wins;
  final int losses;
  final double totalPayout;
  final double totalWagered;
  final double betAmount;
  final Map<int, int> payoutDistribution;
  final Map<String, int> symbolCombinations;
  final int numReels;

  SimulationResults({
    required this.totalSpins,
    required this.wins,
    required this.losses,
    required this.totalPayout,
    required this.totalWagered,
    required this.betAmount,
    required this.payoutDistribution,
    required this.symbolCombinations,
    required this.numReels,
  });

  double get winRate => (wins / totalSpins) * 100;
  double get lossRate => (losses / totalSpins) * 100;
  double get netProfit => totalPayout - totalWagered;
  double get returnToPlayer => (totalPayout / totalWagered) * 100;
  double get houseEdge => 100 - returnToPlayer;
  double get averagePayoutPerSpin => totalPayout / totalSpins;

  void printResults() {
    print('\n╔═══════════════════════════════════════════════════════════════════╗');
    print('║         SLOT MACHINE ODDS CALCULATOR RESULTS                      ║');
    print('╚═══════════════════════════════════════════════════════════════════╝');
    print('\n📈 SIMULATION PARAMETERS:');
    print('   Machine Type:      ${numReels}-Reel ${numReels == 3 ? 'Classic' : 'Modern Video'} Slot');
    print('   Bet per Spin:      \$${betAmount.toStringAsFixed(2)}');
    print('   Total Spins:       ${totalSpins.toString().padLeft(10)}');
    print('\n═══════════════════════════════════════════════════════════════════');
    
    print('\n📊 PRIMARY RESULTS:');
    print('   Winning Spins:     ${wins.toString().padLeft(8)} (${winRate.toStringAsFixed(2)}%)');
    print('   Losing Spins:      ${losses.toString().padLeft(8)} (${lossRate.toStringAsFixed(2)}%)');
    
    print('\n💰 FINANCIAL ANALYSIS:');
    print('   Total Wagered:     \$${totalWagered.toStringAsFixed(2)}');
    print('   Total Payout:      \$${totalPayout.toStringAsFixed(2)}');
    print('   Net Profit/Loss:   ${netProfit >= 0 ? '+' : ''}\$${netProfit.toStringAsFixed(2)}');
    print('   Avg per Spin:      \$${averagePayoutPerSpin.toStringAsFixed(4)}');
    print('   Return to Player:  ${returnToPlayer.toStringAsFixed(3)}%');
    print('   House Edge:        ${houseEdge.toStringAsFixed(3)}%');
    
    print('\n═══════════════════════════════════════════════════════════════════');
    print('🎰 PAYOUT DISTRIBUTION (Top 10):\n');
    
    final sortedPayouts = payoutDistribution.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    
    print('   Multiplier │  Count  │ Frequency │  Total Won');
    print('   ───────────┼─────────┼───────────┼─────────────');
    
    for (var i = 0; i < sortedPayouts.length && i < 10; i++) {
      final entry = sortedPayouts[i];
      final freq = (entry.value / totalSpins * 100);
      final totalWon = entry.key * betAmount * entry.value;
      print('     ${entry.key.toString().padLeft(4)}x    │ ${entry.value.toString().padLeft(7)} │ '
            '${freq.toStringAsFixed(3)}%   │ \$${totalWon.toStringAsFixed(2)}');
    }
    
    print('\n═══════════════════════════════════════════════════════════════════');
    print('🎲 MOST COMMON COMBINATIONS (Top 10):\n');
    
    final sortedCombos = symbolCombinations.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    print('   Combination                    │  Count  │ Frequency');
    print('   ───────────────────────────────┼─────────┼──────────');
    
    for (var i = 0; i < sortedCombos.length && i < 10; i++) {
      final entry = sortedCombos[i];
      final freq = (entry.value / totalSpins * 100);
      print('   ${entry.key.padRight(30)} │ ${entry.value.toString().padLeft(7)} │ ${freq.toStringAsFixed(3)}%');
    }
    
    print('\n═══════════════════════════════════════════════════════════════════\n');
  }
}

void main() {
  print('╔═══════════════════════════════════════════════════════╗');
  print('║         SLOT MACHINE ODDS CALCULATOR                  ║');
  print('║         Monte Carlo Simulation                        ║');
  print('╚═══════════════════════════════════════════════════════╝\n');

  print('Choose slot machine type:');
  print('1. Classic 3-Reel Slot');
  print('2. Modern 5-Reel Video Slot');
  stdout.write('\nEnter choice (1 or 2, default 1): ');
  final typeInput = stdin.readLineSync();
  
  final machine = typeInput == '2' 
      ? SlotMachine.modern() 
      : SlotMachine.classic();

  stdout.write('\nNumber of spins to simulate (default 100000): ');
  final simInput = stdin.readLineSync();
  final numSimulations = int.tryParse(simInput ?? '') ?? 100000;

  stdout.write('Bet amount per spin (default \$1.00): ');
  final betInput = stdin.readLineSync();
  final betAmount = double.tryParse(betInput ?? '') ?? 1.0;

  print('\n⏳ Running $numSimulations spins...\n');

  final simulator = SlotSimulator(machine);
  final stopwatch = Stopwatch()..start();
  final results = simulator.runSimulations(numSimulations, betAmount);
  stopwatch.stop();

  results.printResults();

  print('⏱️  PERFORMANCE:');
  print('   Simulation time:   ${stopwatch.elapsedMilliseconds}ms');
  print('   Spins per second:  ${(numSimulations / (stopwatch.elapsedMilliseconds / 1000)).toStringAsFixed(0)}');

  print('\n═══════════════════════════════════════════════════════════════════');
  print('💡 KEY INSIGHTS & FACTS:\n');

  print('   📊 YOUR RESULTS:');
  print('   • RTP (Return to Player): ${results.returnToPlayer.toStringAsFixed(2)}%');
  print('   • House Edge: ${results.houseEdge.toStringAsFixed(2)}%');
  print('   • Hit Frequency: ${results.winRate.toStringAsFixed(2)}%');
  print('   • Expected loss per \$100: \$${(results.houseEdge).toStringAsFixed(2)}');

  print('\n   🎰 TYPICAL SLOT MACHINE STATS:');
  print('   • RTP Range: 85% - 98% (varies by casino/jurisdiction)');
  print('   • Penny slots: Usually 88-92% RTP');
  print('   • Dollar slots: Usually 93-96% RTP');
  print('   • High-limit slots: Usually 94-98% RTP');
  print('   • Online slots: Usually 95-97% RTP');

  print('\n   ⚠️  IMPORTANT FACTS:');
  print('   • Slots have the highest house edge of any casino game');
  print('   • Each spin is independent (no "hot" or "cold" machines)');
  print('   • RTP is calculated over millions of spins');
  print('   • Progressive jackpots reduce base game RTP');
  print('   • Casinos can adjust RTP within legal limits');

  print('\n   📚 STRATEGY TIPS:');
  print('   • Higher denomination = Higher RTP (usually)');
  print('   • Play maximum coins for best payouts');
  print('   • Set a budget and stick to it');
  print('   • Slots are pure luck - no skill involved');
  print('   • Never chase losses');
  print('   • Join players club for comps/rewards');

  print('\n   🎲 VOLATILITY:');
  if (results.winRate < 20) {
    print('   • High volatility - rare but big wins');
    print('   • Requires larger bankroll');
    print('   • Higher risk, higher reward');
  } else if (results.winRate < 35) {
    print('   • Medium volatility - balanced gameplay');
    print('   • Moderate bankroll needed');
    print('   • Mix of small and medium wins');
  } else {
    print('   • Low volatility - frequent small wins');
    print('   • Smaller bankroll acceptable');
    print('   • Longer playing time per dollar');
  }

  print('\n   💰 BANKROLL MANAGEMENT:');
  final spinsPerHour = 600; // Typical for slots
  final expectedLossPerHour = (betAmount * spinsPerHour * results.houseEdge / 100);
  print('   • Expected loss per hour: \$${expectedLossPerHour.toStringAsFixed(2)}');
  print('   • (Assuming ${spinsPerHour} spins/hour at \$${betAmount.toStringAsFixed(2)}/spin)');
  print('   • For 3 hours play: Budget ~\$${(expectedLossPerHour * 3 * 2).toStringAsFixed(2)}');

  print('\n   🏆 JACKPOT PROBABILITY:');
  if (machine.numReels == 3) {
    print('   • 3-reel classic: ~1 in 8,000 - 32,000');
    print('   • Top jackpot is rare but achievable');
  } else {
    print('   • 5-reel video: ~1 in 50,000 - 300,000');
    print('   • Progressive jackpots: 1 in millions');
  }

  print('\n   🎯 COMPARISON TO OTHER GAMES:');
  print('   • Blackjack (basic strategy): ~0.5% house edge');
  print('   • Baccarat (banker): ~1.06% house edge');
  print('   • Craps (pass line): ~1.41% house edge');
  print('   • Roulette (European): ~2.70% house edge');
  print('   • Slots: ${results.houseEdge.toStringAsFixed(2)}% house edge (this simulation)');

  print('\n═══════════════════════════════════════════════════════════════════');
  print('\n✅ Simulation complete! Remember: Slots are entertainment, not income.\n');
}
