part of 'currency_bloc.dart';


abstract class CurrencyEvent {}

class LoadTodayCurrencyEvent extends CurrencyEvent {}

class SelectDateEvent extends CurrencyEvent {
  final String date;

  SelectDateEvent({required this.date});
}

class ClickCalculate extends CurrencyEvent {

}
