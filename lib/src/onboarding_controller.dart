import 'package:flutter/cupertino.dart';

import 'step.dart';

class OnboardingController with ChangeNotifier {
  final List<OnboardingStep> steps;

  OnboardingController({required this.steps});

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  void setCurrentIndex(int index) {
    _currentIndex = index;
    _currentStep = steps[index];
    notifyListeners();
  }

  bool _isVisible = false;
  bool get isVisible => _isVisible;
  void setIsVisible(bool isVisible) {
    _isVisible = isVisible;
    notifyListeners();
  }

  OnboardingStep? _currentStep;
  OnboardingStep? get currentStep => _currentStep;
  void setCurrentStep(OnboardingStep? step) {
    _currentStep = step;
    notifyListeners();
  }
}
