import 'package:bloc/bloc.dart';
import 'package:valyuta_kursi/data/repository/currency_repository.dart';
import 'package:valyuta_kursi/data/repository/currency_repository_impl.dart';
import '../data/source/model/response/currency_response.dart';
import '../util/status.dart';

part 'currency_event.dart';
part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository _repository = CurrencyRepositoryImpl();

  CurrencyBloc() : super(CurrencyState(currencies: [], status: Status.loading)) {
    on<LoadTodayCurrencyEvent>((event, emit) async{
      emit(state.copyWith(status: Status.loading));
      print("******************************* LoadTodayCurrencyEvent");

      var currencyList = await _repository.getCurrency();

      print("******************************* currencyList ${currencyList.length}");

      emit(state.copyWith(currencies: currencyList, status: Status.success));
    });
  }
}