import 'package:valyuta_kursi/data/repository/currency_repository.dart';
import 'package:valyuta_kursi/data/source/model/response/currency_response.dart';
import 'package:valyuta_kursi/data/source/remote/service/api_service.dart';

class CurrencyRepositoryImpl extends CurrencyRepository {
  final ApiService _api = ApiService();
  @override
  Future<List<CurrencyModel>> getCurrency() async{
    return await _api.getCurrency();
  }

  @override
  Future<List<CurrencyModel>> getCurrencyByDate(String date) async {
    return await _api.getCurrencyByDate(date);
  }

}