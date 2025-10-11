import 'dart:io';
import 'dart:math';

/// Craps Odds Calculator with Monte Carlo Simulation
/// Simulates various craps bets and calculates probabilities

enum BetType {
  passLine,
  dontPass,
  come,
  dontCome,
  field,
  any7,
  any11,
  anyCraps,
  hardway4,
  hardway6,
  hardway8,
  hardway10,
  place4,
  place5,
  place6,
  place8,
  place9,
  place10,
}

class CrapsBet {
  final BetType type;
  final String name;
  final double payout;
  final bool isOneRoll;

  CrapsBet({
    required this.type,
    required this.name,
    required this.payout,
    this.isOneRoll = false,
  });
}

class DiceRoll {
  final int die1;
  final int die2;

  DiceRoll(this.die1, this.die2);

  int get total => die1 + die2;
  bool get isHard => die1 == die2;
  
  @override
  String toString() => '[$die1, $die2] = $total';
}

class CrapsSimulator {
  final Random random = Random();

  DiceRoll rollDice() {
    return DiceRoll(random.nextInt(6) + 1, random.nextInt(6) + 1);
  }

  /// Simulate Pass Line bet
  PassLineResult simulatePassLine() {
    final comeOutRoll = rollDice();
    int rollCount = 1;

    // Come out roll
    if ([7, 11].contains(comeOutRoll.total)) {
      return PassLineResult(won: true, rollCount: rollCount, point: null);
    }
    if ([2, 3, 12].contains(comeOutRoll.total)) {
      return PassLineResult(won: false, rollCount: rollCount, point: null);
    }

    // Point established
    final point = comeOutRoll.total;
    
    while (true) {
      final roll = rollDice();
      rollCount++;

      if (roll.total == point) {
        return PassLineResult(won: true, rollCount: rollCount, point: point);
      }
      if (roll.total == 7) {
        return PassLineResult(won: false, rollCount: rollCount, point: point);
      }
    }
  }

  /// Simulate Don't Pass bet
  PassLineResult simulateDontPass() {
    final comeOutRoll = rollDice();
    int rollCount = 1;

    // Come out roll
    if ([2, 3].contains(comeOutRoll.total)) {
      return PassLineResult(won: true, rollCount: rollCount, point: null);
    }
    if ([7, 11].contains(comeOutRoll.total)) {
      return PassLineResult(won: false, rollCount: rollCount, point: null);
    }
    if (comeOutRoll.total == 12) {
      return PassLineResult(won: false, rollCount: rollCount, point: null, isPush: true);
    }

    // Point established
    final point = comeOutRoll.total;
    
    while (true) {
      final roll = rollDice();
      rollCount++;

      if (roll.total == 7) {
        return PassLineResult(won: true, rollCount: rollCount, point: point);
      }
      if (roll.total == point) {
        return PassLineResult(won: false, rollCount: rollCount, point: point);
      }
    }
  }

  /// Simulate one-roll bets
  bool simulateOneRollBet(BetType type) {
    final roll = rollDice();
    
    switch (type) {
      case BetType.any7:
        return roll.total == 7;
      case BetType.any11:
        return roll.total == 11;
      case BetType.anyCraps:
        return [2, 3, 12].contains(roll.total);
      case BetType.field:
        return [2, 3, 4, 9, 10, 11, 12].contains(roll.total);
      default:
        return false;
    }
  }

  /// Simulate hardway bets
  HardwayResult simulateHardway(int target) {
    int rollCount = 0;
    
    while (true) {
      final roll = rollDice();
      rollCount++;

      // Win on hard way
      if (roll.total == target && roll.isHard) {
        return HardwayResult(won: true, rollCount: rollCount);
      }

      // Lose on easy way or 7
      if (roll.total == target && !roll.isHard) {
        return HardwayResult(won: false, rollCount: rollCount);
      }
      if (roll.total == 7) {
        return HardwayResult(won: false, rollCount: rollCount);
      }
    }
  }

  /// Simulate place bets
  PlaceResult simulatePlace(int number) {
    int rollCount = 0;
    
    while (true) {
      final roll = rollDice();
      rollCount++;

      if (roll.total == number) {
        return PlaceResult(won: true, rollCount: rollCount);
      }
      if (roll.total == 7) {
        return PlaceResult(won: false, rollCount: rollCount);
      }
    }
  }

  /// Run comprehensive simulations
  Map<String, SimulationResult> simulateAllBets(int numSimulations) {
    final results = <String, SimulationResult>{};

    // Pass Line
    int passWins = 0, passLosses = 0, passPushes = 0;
    int totalPassRolls = 0;
    for (int i = 0; i < numSimulations; i++) {
      final result = simulatePassLine();
      if (result.won) passWins++;
      else passLosses++;
      totalPassRolls += result.rollCount;
    }
    results['Pass Line'] = SimulationResult(
      wins: passWins,
      losses: passLosses,
      pushes: passPushes,
      totalSimulations: numSimulations,
      payout: 1.0,
      averageRolls: totalPassRolls / numSimulations,
    );

    // Don't Pass
    int dontPassWins = 0, dontPassLosses = 0, dontPassPushes = 0;
    int totalDontPassRolls = 0;
    for (int i = 0; i < numSimulations; i++) {
      final result = simulateDontPass();
      if (result.isPush) {
        dontPassPushes++;
      } else if (result.won) {
        dontPassWins++;
      } else {
        dontPassLosses++;
      }
      totalDontPassRolls += result.rollCount;
    }
    results['Don\'t Pass'] = SimulationResult(
      wins: dontPassWins,
      losses: dontPassLosses,
      pushes: dontPassPushes,
      totalSimulations: numSimulations,
      payout: 1.0,
      averageRolls: totalDontPassRolls / numSimulations,
    );

    // Field
    int fieldWins = 0;
    for (int i = 0; i < numSimulations; i++) {
      if (simulateOneRollBet(BetType.field)) fieldWins++;
    }
    results['Field'] = SimulationResult(
      wins: fieldWins,
      losses: numSimulations - fieldWins,
      pushes: 0,
      totalSimulations: numSimulations,
      payout: 1.0,
      averageRolls: 1.0,
    );

    // Any 7
    int any7Wins = 0;
    for (int i = 0; i < numSimulations; i++) {
      if (simulateOneRollBet(BetType.any7)) any7Wins++;
    }
    results['Any 7'] = SimulationResult(
      wins: any7Wins,
      losses: numSimulations - any7Wins,
      pushes: 0,
      totalSimulations: numSimulations,
      payout: 4.0,
      averageRolls: 1.0,
    );

    // Any 11
    int any11Wins = 0;
    for (int i = 0; i < numSimulations; i++) {
      if (simulateOneRollBet(BetType.any11)) any11Wins++;
    }
    results['Any 11'] = SimulationResult(
      wins: any11Wins,
      losses: numSimulations - any11Wins,
      pushes: 0,
      totalSimulations: numSimulations,
      payout: 15.0,
      averageRolls: 1.0,
    );

    // Any Craps
    int anyCrapsWins = 0;
    for (int i = 0; i < numSimulations; i++) {
      if (simulateOneRollBet(BetType.anyCraps)) anyCrapsWins++;
    }
    results['Any Craps'] = SimulationResult(
      wins: anyCrapsWins,
      losses: numSimulations - anyCrapsWins,
      pushes: 0,
      totalSimulations: numSimulations,
      payout: 7.0,
      averageRolls: 1.0,
    );

    // Hardway 4
    int hard4Wins = 0;
    int totalHard4Rolls = 0;
    for (int i = 0; i < numSimulations; i++) {
      final result = simulateHardway(4);
      if (result.won) hard4Wins++;
      totalHard4Rolls += result.rollCount;
    }
    results['Hardway 4'] = SimulationResult(
      wins: hard4Wins,
      losses: numSimulations - hard4Wins,
      pushes: 0,
      totalSimulations: numSimulations,
      payout: 7.0,
      averageRolls: totalHard4Rolls / numSimulations,
    );

    // Hardway 10
    int hard10Wins = 0;
    int totalHard10Rolls = 0;
    for (int i = 0; i < numSimulations; i++) {
      final result = simulateHardway(10);
      if (result.won) hard10Wins++;
      totalHard10Rolls += result.rollCount;
    }
    results['Hardway 10'] = SimulationResult(
      wins: hard10Wins,
      losses: numSimulations - hard10Wins,
      pushes: 0,
      totalSimulations: numSimulations,
      payout: 7.0,
      averageRolls: totalHard10Rolls / numSimulations,
    );

    // Place 6
    int place6Wins = 0;
    int totalPlace6Rolls = 0;
    for (int i = 0; i < numSimulations; i++) {
      final result = simulatePlace(6);
      if (result.won) place6Wins++;
      totalPlace6Rolls += result.rollCount;
    }
    results['Place 6'] = SimulationResult(
      wins: place6Wins,
      losses: numSimulations - place6Wins,
      pushes: 0,
      totalSimulations: numSimulations,
      payout: 1.167, // 7:6
      averageRolls: totalPlace6Rolls / numSimulations,
    );

    // Place 8
    int place8Wins = 0;
    int totalPlace8Rolls = 0;
    for (int i = 0; i < numSimulations; i++) {
      final result = simulatePlace(8);
      if (result.won) place8Wins++;
      totalPlace8Rolls += result.rollCount;
    }
    results['Place 8'] = SimulationResult(
      wins: place8Wins,
      losses: numSimulations - place8Wins,
      pushes: 0,
      totalSimulations: numSimulations,
      payout: 1.167, // 7:6
      averageRolls: totalPlace8Rolls / numSimulations,
    );

    return results;
  }
}

class PassLineResult {
  final bool won;
  final int rollCount;
  final int? point;
  final bool isPush;

  PassLineResult({
    required this.won,
    required this.rollCount,
    this.point,
    this.isPush = false,
  });
}

class HardwayResult {
  final bool won;
  final int rollCount;

  HardwayResult({required this.won, required this.rollCount});
}

class PlaceResult {
  final bool won;
  final int rollCount;

  PlaceResult({required this.won, required this.rollCount});
}

class SimulationResult {
  final int wins;
  final int losses;
  final int pushes;
  final int totalSimulations;
  final double payout;
  final double averageRolls;

  SimulationResult({
    required this.wins,
    required this.losses,
    required this.pushes,
    required this.totalSimulations,
    required this.payout,
    required this.averageRolls,
  });

  double get winRate => (wins / totalSimulations) * 100;
  double get lossRate => (losses / totalSimulations) * 100;
  double get pushRate => (pushes / totalSimulations) * 100;
  
  double get expectedReturn {
    final totalReturn = (wins * payout) - losses;
    return (totalReturn / totalSimulations) * 100;
  }

  double get houseEdge => -expectedReturn;
}

void main() {
  print('╔═══════════════════════════════════════════════════════╗');
  print('║         CRAPS ODDS CALCULATOR                         ║');
  print('║         Monte Carlo Simulation                        ║');
  print('╚═══════════════════════════════════════════════════════╝\n');

  stdout.write('Number of simulations (default 100000): ');
  final simInput = stdin.readLineSync();
  final numSimulations = int.tryParse(simInput ?? '') ?? 100000;

  print('\n⏳ Running $numSimulations simulations for all bet types...\n');

  final simulator = CrapsSimulator();
  final stopwatch = Stopwatch()..start();
  final results = simulator.simulateAllBets(numSimulations);
  stopwatch.stop();

  print('╔═══════════════════════════════════════════════════════════════════╗');
  print('║         CRAPS SIMULATION RESULTS                                  ║');
  print('╚═══════════════════════════════════════════════════════════════════╝\n');
  print('Total Simulations: $numSimulations per bet type\n');

  print('   Bet Type        │ Win Rate │ Payout │   ROI    │ House Edge │ Avg Rolls');
  print('   ────────────────┼──────────┼────────┼──────────┼────────────┼──────────');

  final sortedResults = results.entries.toList()
    ..sort((a, b) => b.value.expectedReturn.compareTo(a.value.expectedReturn));

  for (var entry in sortedResults) {
    final result = entry.value;
    final pushInfo = result.pushes > 0 ? ' (${result.pushRate.toStringAsFixed(1)}% push)' : '';
    print('   ${entry.key.padRight(15)} │ ${result.winRate.toStringAsFixed(2)}% │ '
          '${result.payout.toStringAsFixed(1)}:1  │ '
          '${result.expectedReturn >= 0 ? '+' : ''}${result.expectedReturn.toStringAsFixed(2)}% │ '
          '${result.houseEdge.toStringAsFixed(2)}%    │ '
          '${result.averageRolls.toStringAsFixed(2)}$pushInfo');
  }

  print('\n⏱️  PERFORMANCE:');
  print('   Simulation time:   ${stopwatch.elapsedMilliseconds}ms');
  print('   Total simulations: ${numSimulations * results.length}');
  print('   Sims per second:   ${(numSimulations * results.length / (stopwatch.elapsedMilliseconds / 1000)).toStringAsFixed(0)}');

  print('\n═══════════════════════════════════════════════════════════════════');
  print('💡 KEY INSIGHTS & STRATEGY:\n');

  final passLine = results['Pass Line']!;
  final dontPass = results['Don\'t Pass']!;

  print('   📊 BEST BETS (Lowest House Edge):');
  print('   • Pass Line: ${passLine.houseEdge.toStringAsFixed(3)}% house edge');
  print('   • Don\'t Pass: ${dontPass.houseEdge.toStringAsFixed(3)}% house edge');
  print('   • Place 6/8: ~1.5% house edge (best place bets)');
  
  print('\n   ⚠️  WORST BETS (Highest House Edge):');
  final worstBet = sortedResults.last;
  print('   • ${worstBet.key}: ${worstBet.value.houseEdge.toStringAsFixed(2)}% house edge');
  print('   • Avoid proposition bets (Any 7, Any 11, Any Craps)');
  print('   • These have house edges of 10-16%');

  print('\n   📚 OPTIMAL STRATEGY:');
  print('   • Stick to Pass/Don\'t Pass line bets');
  print('   • Take/Lay odds (0% house edge on odds portion)');
  print('   • Place 6 and 8 are acceptable secondary bets');
  print('   • Avoid all proposition bets in the center of the table');
  print('   • Don\'t Pass has slightly better odds than Pass Line');

  print('\n   🎲 PROBABILITY FACTS:');
  print('   • 7 is most common roll (16.67% probability)');
  print('   • Average Pass Line decision: ${passLine.averageRolls.toStringAsFixed(2)} rolls');
  print('   • Point numbers: 4,5,6,8,9,10');
  print('   • Natural winners on come-out: 7, 11');
  print('   • Craps on come-out: 2, 3, 12');

  print('\n   💰 EXPECTED VALUE (per \$100 bet):');
  print('   • Pass Line: \$${(100 + passLine.expectedReturn).toStringAsFixed(2)}');
  print('   • Don\'t Pass: \$${(100 + dontPass.expectedReturn).toStringAsFixed(2)}');
  print('   • Any 7: \$${(100 + results['Any 7']!.expectedReturn).toStringAsFixed(2)}');

  print('\n═══════════════════════════════════════════════════════════════════\n');
}
