enum Difficulty { easy, medium, hard }

extension DifficultyExtension on Difficulty {
  double get speed {
    switch (this) {
      case Difficulty.easy:
        return 100;
      case Difficulty.medium:
        return 300;
      case Difficulty.hard:
        return 500;
    }
  }

  String get label {
    switch (this) {
      case Difficulty.easy:
        return '쉬움 🐌';
      case Difficulty.medium:
        return '중간 🐝';
      case Difficulty.hard:
        return '어려움 🦟';
    }
  }
}
