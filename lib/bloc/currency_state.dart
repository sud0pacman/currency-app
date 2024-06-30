part of 'currency_bloc.dart';


class CurrencyState {
  final List<CurrencyModel> currencies;
  final Status status;

  CurrencyState({required this.currencies, required this.status});

  CurrencyState copyWith({List<CurrencyModel>? currencies, Status? status}) {
    return CurrencyState(
        currencies: currencies ?? this.currencies,
        status: status ?? this.status
    );
  }

  @override
  String toString() {
    return 'CurrencyState{currencies: $currencies, status: $status}';
  }
}
