import 'package:valyuta_kursi/data/source/model/response/currency_response.dart';

abstract class CurrencyRepository {
  Future<List<CurrencyModel>> getCurrency();
  Future<List<CurrencyModel>> getCurrencyByDate(String date);
}