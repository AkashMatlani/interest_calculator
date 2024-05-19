import 'package:flutter/material.dart';
import 'dart:math';

class FormStateProvider with ChangeNotifier {
  double _rateOfInterest = 1;
  double? _principalAmount;
  int _compoundFrequency = 1;
  int _years = 1;
  double? _result;

  double get rateOfInterest => _rateOfInterest;

  double? get principalAmount => _principalAmount;

  int get compoundFrequency => _compoundFrequency;

  int get years => _years;

  double? get result => _result;

  void setRateOfInterest(double value) {
    _rateOfInterest = value;
    _updateMinPrincipalAmount();
    _updateCompoundFrequency();
    _updateYears();
    calculate();
    notifyListeners();
  }

  void setPrincipalAmount(double value) {
    _principalAmount = value;
    calculate();
    notifyListeners();
  }

  void setCompoundFrequency(int value) {
    _compoundFrequency = value;
    _updateYears();
    calculate();
    notifyListeners();
  }

  void setYears(int value) {
    _years = value;
    calculate();
    notifyListeners();
  }

  void calculate() {
    if (_principalAmount != null) {
      _result = _principalAmount! *
          pow((1 + (_rateOfInterest / 100) / _compoundFrequency),
              _compoundFrequency * _years);
      notifyListeners();
    }
  }

  void _updateMinPrincipalAmount() {
    if (_rateOfInterest >= 1 && _rateOfInterest <= 3) {
      _principalAmount = 10000;
    } else if (_rateOfInterest >= 4 && _rateOfInterest <= 7) {
      _principalAmount = 50000;
    } else if (_rateOfInterest >= 8 && _rateOfInterest <= 12) {
      _principalAmount = 75000;
    } else {
      _principalAmount = 100000;
    }
  }

  void _updateCompoundFrequency() {
    if (_rateOfInterest >= 1 && _rateOfInterest <= 3) {
      _compoundFrequency = 4;
    } else if (_rateOfInterest >= 4 && _rateOfInterest <= 7) {
      _compoundFrequency = 2;
    } else if (_rateOfInterest >= 8 && _rateOfInterest <= 12) {
      _compoundFrequency = 1;
    } else {
      _compoundFrequency = 1;
    }
  }

  void _updateYears() {
    if (_compoundFrequency == 1) {
      _years = 10;
    } else if (_compoundFrequency == 2) {
      _years = 20;
    } else if (_compoundFrequency == 4) {
      _years = 30;
    } else {
      _years = 10;
    }
  }
}
