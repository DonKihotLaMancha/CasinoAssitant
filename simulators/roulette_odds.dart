import 'dart:io';
import 'dart:math';

/// Roulette Odds Calculator with Monte Carlo Simulation
/// Supports American (38 numbers) and European (37 numbers) roulette

enum RouletteType { american, european }

enum BetType {
  straight, // Single number
  split, // Two numbers
  street, // Three numbers
  corner, // Four numbers
  sixLine, // Six numbers
  red,
  black,
  odd,
  even,
  low, // 1-18
  high, // 19-36
  dozen1, // 1-12
  dozen2, // 13-24
  dozen3, // 25-36
  column1,
  column2,
  column3,
}

class RouletteBet {
  final BetType type;
  final List<int> numbers;
  final double payout;
  final String name;

  RouletteBet({
    required this.type,
    required this.numbers,
    required this.payout,
    required this.name,
  });
}

class RouletteWheel {
  final RouletteType type;
  final Random random = Random();
  
  // Red numbers in roulette
  static const redNumbers = [
    1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36
  ];

  RouletteWheel(this.type);

  int get totalNumbers => type == RouletteType.american ? 38 : 37;
  
  int spin() {
    // 0-36 for European, 0-37 for American (37 = 00)
    return random.nextInt(totalNumbers);
  }

  bool isRed(int number) {
    if (number == 0 || number == 37) return false; // 0 and 00 are green
    return redNumbers.contains(number);
  }

  bool isBlack(int number) {
    if (number == 0 || number == 37) return false;
    return !redNumbers.contains(number);
  }

  String numberToString(int number) {
    if (number == 37) return '00';
    return number.toString();
  }
}

class RouletteSimulator {
  final RouletteWheel wheel;

  RouletteSimulator(RouletteType type) : wheel = RouletteWheel(type);

  SimulationResult simulateBet(RouletteBet bet, int numSimulations, double betAmount) {
    int wins = 0;
    int losses = 0;
    double totalProfit = 0;
    
    final numberHits = <int, int>{};

    for (int i = 0; i < numSimulations; i++) {
      final result = wheel.spin();
      numberHits[result] = (numberHits[result] ?? 0) + 1;

      if (bet.numbers.contains(result)) {
        wins++;
        final profit = betAmount * bet.payout;
        totalProfit += profit;
      } else {
        losses++;
        totalProfit -= betAmount;
      }
    }

    return SimulationResult(
      wins: wins,
      losses: losses,
      totalSimulations: numSimulations,
      totalProfit: totalProfit,
      betAmount: betAmount,
      betName: bet.name,
      numberHits: numberHits,
      expectedPayout: bet.payout,
    );
  }

  Map<String, SimulationResult> simulateAllBetTypes(int numSimulations, double betAmount) {
    final results = <String, SimulationResult>{};
    
    final bets = [
      RouletteBet(type: BetType.straight, numbers: [17], payout: 35, name: 'Straight (17)'),
      RouletteBet(type: BetType.red, numbers: RouletteWheel.redNumbers, payout: 1, name: 'Red'),
      RouletteBet(type: BetType.black, numbers: _getBlackNumbers(), payout: 1, name: 'Black'),
      RouletteBet(type: BetType.odd, numbers: _getOddNumbers(), payout: 1, name: 'Odd'),
      RouletteBet(type: BetType.even, numbers: _getEvenNumbers(), payout: 1, name: 'Even'),
      RouletteBet(type: BetType.low, numbers: List.generate(18, (i) => i + 1), payout: 1, name: 'Low (1-18)'),
      RouletteBet(type: BetType.high, numbers: List.generate(18, (i) => i + 19), payout: 1, name: 'High (19-36)'),
      RouletteBet(type: BetType.dozen1, numbers: List.generate(12, (i) => i + 1), payout: 2, name: 'First Dozen'),
      RouletteBet(type: BetType.dozen2, numbers: List.generate(12, (i) => i + 13), payout: 2, name: 'Second Dozen'),
      RouletteBet(type: BetType.dozen3, numbers: List.generate(12, (i) => i + 25), payout: 2, name: 'Third Dozen'),
      RouletteBet(type: BetType.split, numbers: [17, 18], payout: 17, name: 'Split (17-18)'),
      RouletteBet(type: BetType.street, numbers: [13, 14, 15], payout: 11, name: 'Street (13-14-15)'),
      RouletteBet(type: BetType.corner, numbers: [17, 18, 20, 21], payout: 8, name: 'Corner (17-18-20-21)'),
    ];

    for (var bet in bets) {
      results[bet.name] = simulateBet(bet, numSimulations, betAmount);
    }

    return results;
  }

  List<int> _getBlackNumbers() {
    final black = <int>[];
    for (int i = 1; i <= 36; i++) {
      if (!RouletteWheel.redNumbers.contains(i)) {
        black.add(i);
      }
    }
    return black;
  }

  List<int> _getOddNumbers() {
    return List.generate(18, (i) => i * 2 + 1);
  }

  List<int> _getEvenNumbers() {
    return List.generate(18, (i) => (i + 1) * 2);
  }
}

class SimulationResult {
  final int wins;
  final int losses;
  final int totalSimulations;
  final double totalProfit;
  final double betAmount;
  final String betName;
  final Map<int, int> numberHits;
  final double expectedPayout;

  SimulationResult({
    required this.wins,
    required this.losses,
    required this.totalSimulations,
    required this.totalProfit,
    required this.betAmount,
    required this.betName,
    required this.numberHits,
    required this.expectedPayout,
  });

  double get winRate => (wins / totalSimulations) * 100;
  double get lossRate => (losses / totalSimulations) * 100;
  double get averageProfit => totalProfit / totalSimulations;
  double get returnOnInvestment => (totalProfit / (betAmount * totalSimulations)) * 100;
  double get totalWagered => betAmount * totalSimulations;

  void printResults() {
    print('\n╔═══════════════════════════════════════════════════════════════════╗');
    print('║         ROULETTE ODDS CALCULATOR RESULTS                          ║');
    print('╚═══════════════════════════════════════════════════════════════════╝');
    print('\n📈 SIMULATION PARAMETERS:');
    print('   Bet Type:          $betName');
    print('   Bet Amount:        \$${betAmount.toStringAsFixed(2)}');
    print('   Total Simulations: ${totalSimulations.toString().padLeft(10)}');
    print('   Expected Payout:   ${expectedPayout.toStringAsFixed(0)}:1');
    print('\n═══════════════════════════════════════════════════════════════════');
    
    print('\n📊 PRIMARY RESULTS:');
    print('   Wins:              ${wins.toString().padLeft(8)} (${winRate.toStringAsFixed(2)}%)');
    print('   Losses:            ${losses.toString().padLeft(8)} (${lossRate.toStringAsFixed(2)}%)');
    
    print('\n💰 FINANCIAL ANALYSIS:');
    print('   Total Wagered:     \$${totalWagered.toStringAsFixed(2)}');
    print('   Total Profit/Loss: ${totalProfit >= 0 ? '+' : ''}\$${totalProfit.toStringAsFixed(2)}');
    print('   Average per Spin:  ${averageProfit >= 0 ? '+' : ''}\$${averageProfit.toStringAsFixed(4)}');
    print('   ROI:               ${returnOnInvestment >= 0 ? '+' : ''}${returnOnInvestment.toStringAsFixed(3)}%');
    print('   House Edge:        ${(-returnOnInvestment).toStringAsFixed(3)}%');
    
    print('\n═══════════════════════════════════════════════════════════════════\n');
  }
}

void main() {
  print('╔═══════════════════════════════════════════════════════╗');
  print('║         ROULETTE ODDS CALCULATOR                      ║');
  print('║         Monte Carlo Simulation                        ║');
  print('╚═══════════════════════════════════════════════════════╝\n');

  // Choose roulette type
  print('Choose roulette type:');
  print('1. European (37 numbers: 0-36)');
  print('2. American (38 numbers: 0-36, 00)');
  stdout.write('\nEnter choice (1 or 2, default 1): ');
  final typeInput = stdin.readLineSync();
  final rouletteType = typeInput == '2' ? RouletteType.american : RouletteType.european;

  print('\nChoose mode:');
  print('1. Analyze specific bet');
  print('2. Compare all bet types');
  stdout.write('\nEnter choice (1 or 2): ');
  final modeChoice = stdin.readLineSync();

  stdout.write('\nNumber of simulations (default 100000): ');
  final simInput = stdin.readLineSync();
  final numSimulations = int.tryParse(simInput ?? '') ?? 100000;

  stdout.write('Bet amount per spin (default \$10): ');
  final betInput = stdin.readLineSync();
  final betAmount = double.tryParse(betInput ?? '') ?? 10.0;

  final simulator = RouletteSimulator(rouletteType);

  print('\n⏳ Running $numSimulations simulations...\n');
  final stopwatch = Stopwatch()..start();

  if (modeChoice == '2') {
    // Compare all bet types
    final results = simulator.simulateAllBetTypes(numSimulations, betAmount);
    stopwatch.stop();

    print('╔═══════════════════════════════════════════════════════════════════╗');
    print('║         COMPARISON OF ALL BET TYPES                               ║');
    print('╚═══════════════════════════════════════════════════════════════════╝\n');
    print('Roulette Type: ${rouletteType == RouletteType.european ? 'European' : 'American'}');
    print('Simulations: $numSimulations | Bet: \$${betAmount.toStringAsFixed(2)} per spin\n');

    print('   Bet Type              │ Win Rate │   ROI    │ House Edge │ Avg Profit/Spin');
    print('   ──────────────────────┼──────────┼──────────┼────────────┼────────────────');

    final sortedResults = results.entries.toList()
      ..sort((a, b) => b.value.returnOnInvestment.compareTo(a.value.returnOnInvestment));

    for (var entry in sortedResults) {
      final result = entry.value;
      print('   ${entry.key.padRight(21)} │ ${result.winRate.toStringAsFixed(2)}% │ '
            '${result.returnOnInvestment >= 0 ? '+' : ''}${result.returnOnInvestment.toStringAsFixed(2)}% │ '
            '${(-result.returnOnInvestment).toStringAsFixed(2)}%    │ '
            '${result.averageProfit >= 0 ? '+' : ''}\$${result.averageProfit.toStringAsFixed(4)}');
    }

    print('\n⏱️  Simulation time: ${stopwatch.elapsedMilliseconds}ms');
    print('   Spins per second: ${(numSimulations * results.length / (stopwatch.elapsedMilliseconds / 1000)).toStringAsFixed(0)}');

    print('\n💡 KEY INSIGHTS:');
    if (rouletteType == RouletteType.european) {
      print('   • European roulette house edge: ~2.70%');
      print('   • Single zero (0) gives house advantage');
    } else {
      print('   • American roulette house edge: ~5.26%');
      print('   • Double zero (00) increases house advantage');
      print('   • European roulette offers better odds');
    }
    print('   • All bets have similar house edge (except Five Number bet in American)');
    print('   • No betting system can overcome the house edge long-term');
    print('   • Higher payout bets (straight) have same expected value as even-money bets');

    print('\n═══════════════════════════════════════════════════════════════════\n');

  } else {
    // Specific bet analysis
    print('\nChoose bet type:');
    print('1. Straight (single number) - 35:1');
    print('2. Red - 1:1');
    print('3. Black - 1:1');
    print('4. Odd - 1:1');
    print('5. Even - 1:1');
    print('6. Low (1-18) - 1:1');
    print('7. High (19-36) - 1:1');
    print('8. First Dozen (1-12) - 2:1');
    print('9. Second Dozen (13-24) - 2:1');
    print('10. Third Dozen (25-36) - 2:1');
    
    stdout.write('\nEnter choice (1-10): ');
    final betChoice = stdin.readLineSync();

    RouletteBet? bet;
    switch (betChoice) {
      case '1':
        stdout.write('Enter number (0-36): ');
        final numInput = stdin.readLineSync();
        final num = int.tryParse(numInput ?? '') ?? 17;
        bet = RouletteBet(type: BetType.straight, numbers: [num], payout: 35, name: 'Straight ($num)');
        break;
      case '2':
        bet = RouletteBet(type: BetType.red, numbers: RouletteWheel.redNumbers, payout: 1, name: 'Red');
        break;
      case '3':
        bet = RouletteBet(type: BetType.black, numbers: simulator._getBlackNumbers(), payout: 1, name: 'Black');
        break;
      case '4':
        bet = RouletteBet(type: BetType.odd, numbers: simulator._getOddNumbers(), payout: 1, name: 'Odd');
        break;
      case '5':
        bet = RouletteBet(type: BetType.even, numbers: simulator._getEvenNumbers(), payout: 1, name: 'Even');
        break;
      case '6':
        bet = RouletteBet(type: BetType.low, numbers: List.generate(18, (i) => i + 1), payout: 1, name: 'Low (1-18)');
        break;
      case '7':
        bet = RouletteBet(type: BetType.high, numbers: List.generate(18, (i) => i + 19), payout: 1, name: 'High (19-36)');
        break;
      case '8':
        bet = RouletteBet(type: BetType.dozen1, numbers: List.generate(12, (i) => i + 1), payout: 2, name: 'First Dozen');
        break;
      case '9':
        bet = RouletteBet(type: BetType.dozen2, numbers: List.generate(12, (i) => i + 13), payout: 2, name: 'Second Dozen');
        break;
      case '10':
        bet = RouletteBet(type: BetType.dozen3, numbers: List.generate(12, (i) => i + 25), payout: 2, name: 'Third Dozen');
        break;
      default:
        bet = RouletteBet(type: BetType.red, numbers: RouletteWheel.redNumbers, payout: 1, name: 'Red');
    }

    final result = simulator.simulateBet(bet, numSimulations, betAmount);
    stopwatch.stop();

    result.printResults();

    print('⏱️  PERFORMANCE:');
    print('   Simulation time:   ${stopwatch.elapsedMilliseconds}ms');
    print('   Spins per second:  ${(numSimulations / (stopwatch.elapsedMilliseconds / 1000)).toStringAsFixed(0)}');

    print('\n💡 KEY INSIGHTS:');
    print('   • Theoretical win rate: ${(bet.numbers.length / simulator.wheel.totalNumbers * 100).toStringAsFixed(2)}%');
    print('   • Simulated win rate: ${result.winRate.toStringAsFixed(2)}%');
    print('   • Difference: ${(result.winRate - (bet.numbers.length / simulator.wheel.totalNumbers * 100)).toStringAsFixed(3)}%');
    
    final theoreticalHouseEdge = rouletteType == RouletteType.european ? 2.70 : 5.26;
    print('   • Theoretical house edge: ${theoreticalHouseEdge.toStringAsFixed(2)}%');
    print('   • Simulated house edge: ${(-result.returnOnInvestment).toStringAsFixed(2)}%');

    print('\n   📚 Strategy Tips:');
    print('   • Play European roulette when possible (lower house edge)');
    print('   • Set a budget and stick to it');
    print('   • No betting system can overcome house edge');
    print('   • All bets have same expected value (except Five Number in American)');

    print('\n═══════════════════════════════════════════════════════════════════\n');
  }
}
