part of 'currency_bloc.dart';


abstract class CurrencyEvent {}

class LoadTodayCurrencyEvent extends CurrencyEvent {}

class SelectDateEvent extends CurrencyEvent {
  final String date;

  SelectDateEvent({required this.date});
}

class InitCalculate extends CurrencyEvent {
  final CurrencyModel currencyData;

  InitCalculate({required this.currencyData});
}

class ClickCalculateEvent extends CurrencyEvent {
  final String text1;
  final String text2;
  final bool isUzbTo;
  final String value;

  ClickCalculateEvent({required this.text1, required this.text2, required this.isUzbTo, required this.value});
}

class ClickSwapCalculateEvent extends CurrencyEvent {
  final bool isUzbTo;

  ClickSwapCalculateEvent({required this.isUzbTo});
}
