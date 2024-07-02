part of 'currency_bloc.dart';

class CurrencyState {
  final List<CurrencyModel> currencies;
  final Status status;
  final bool isSwap;
  final bool initCalculate;
  final bool isUzbTo;
  final String text1;
  final String text2;
  final bool isCalculate;

  CurrencyState({
    required this.currencies,
    required this.status,
    required this.isSwap,
    required this.isUzbTo,
    required this.text1,
    required this.text2,
    required this.initCalculate,
    required this.isCalculate
  });

  CurrencyState copyWith(
      {List<CurrencyModel>? currencies,
      Status? status,
      bool? isUzbTo,
      bool? isSwap,
      String? text1,
      String? text2,
      bool? initCalculate,
      bool? isCalculate}) {
    return CurrencyState(
      currencies: currencies ?? this.currencies,
      status: status ?? this.status,
      isUzbTo: isUzbTo ?? this.isUzbTo,
      isSwap: isUzbTo ?? this.isUzbTo,
      text1: text1 ?? this.text1,
      text2: text2 ?? this.text2,
      initCalculate: initCalculate ?? this.initCalculate,
      isCalculate: isCalculate ?? this.isCalculate
    );
  }

  @override
  String toString() {
    return 'CurrencyState{currencies: ${currencies.length}, status: $status, isSwap: $isSwap, initCalculate: $initCalculate, isUzbTo: $isUzbTo, text1: $text1, text2: $text2}';
  }
}
