import 'package:flutter/foundation.dart';
import '../core/blackjack_simulator.dart';

class AppState extends ChangeNotifier {
  // Simulation parameters
  int _numSimulations = 10000;
  int _numDecks = 6;
  bool _useBasicStrategy = true;
  
  // Simulation results
  EnhancedSimulationResults? _results;
  bool _isSimulating = false;
  
  // Hand analyzer parameters
  String _playerCard1 = 'A';
  String _playerCard2 = '6';
  String _dealerUpcard = '10';
  
  // Hand analysis results
  HandAnalysis? _handAnalysis;
  
  // Getters
  int get numSimulations => _numSimulations;
  int get numDecks => _numDecks;
  bool get useBasicStrategy => _useBasicStrategy;
  EnhancedSimulationResults? get results => _results;
  bool get isSimulating => _isSimulating;
  
  String get playerCard1 => _playerCard1;
  String get playerCard2 => _playerCard2;
  String get dealerUpcard => _dealerUpcard;
  HandAnalysis? get handAnalysis => _handAnalysis;
  
  // Setters
  void setNumSimulations(int value) {
    _numSimulations = value;
    notifyListeners();
  }
  
  void setNumDecks(int value) {
    _numDecks = value;
    notifyListeners();
  }
  
  void setUseBasicStrategy(bool value) {
    _useBasicStrategy = value;
    notifyListeners();
  }
  
  void setPlayerCard1(String value) {
    _playerCard1 = value;
    notifyListeners();
  }
  
  void setPlayerCard2(String value) {
    _playerCard2 = value;
    notifyListeners();
  }
  
  void setDealerUpcard(String value) {
    _dealerUpcard = value;
    notifyListeners();
  }
  
  // Run simulation
  Future<void> runSimulation() async {
    _isSimulating = true;
    notifyListeners();
    
    try {
      final simulator = BlackjackSimulator(numDecks: _numDecks);
      _results = await compute(
        _runSimulationIsolate,
        SimulationParams(_numSimulations, _numDecks, _useBasicStrategy),
      );
    } catch (e) {
      debugPrint('Simulation error: $e');
    } finally {
      _isSimulating = false;
      notifyListeners();
    }
  }
  
  // Analyze hand
  void analyzeHand() {
    try {
      final analyzer = BlackjackHandAnalyzer(numDecks: _numDecks);
      _handAnalysis = analyzer.analyzeHand(_playerCard1, _playerCard2, _dealerUpcard);
      notifyListeners();
    } catch (e) {
      debugPrint('Hand analysis error: $e');
    }
  }
  
  // Clear results
  void clearResults() {
    _results = null;
    _handAnalysis = null;
    notifyListeners();
  }
}

// Helper for isolate computation
class SimulationParams {
  final int numSimulations;
  final int numDecks;
  final bool useBasicStrategy;
  
  SimulationParams(this.numSimulations, this.numDecks, this.useBasicStrategy);
}

EnhancedSimulationResults _runSimulationIsolate(SimulationParams params) {
  final simulator = BlackjackSimulator(numDecks: params.numDecks);
  return simulator.runSimulations(
    params.numSimulations,
    useBasicStrategy: params.useBasicStrategy,
  );
}
