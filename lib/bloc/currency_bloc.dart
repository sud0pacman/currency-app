import 'package:bloc/bloc.dart';
import 'package:valyuta_kursi/data/repository/currency_repository.dart';
import 'package:valyuta_kursi/data/repository/currency_repository_impl.dart';
import 'package:valyuta_kursi/data/source/remote/service/api_service.dart';
import '../data/source/model/response/currency_response.dart';
import '../util/status.dart';

part 'currency_event.dart';
part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository _repository = CurrencyRepositoryImpl();

  CurrencyBloc() : super(CurrencyState(currencies: [], status: Status.loading, isUzbTo: false, text1: "", text2: "", isSwap: false, initCalculate: false, isCalculate: false)) {
    on<LoadTodayCurrencyEvent>((event, emit) async{
      emit(state.copyWith(status: Status.loading));
      print("******************************* LoadTodayCurrencyEvent");

      var currencyList = await _repository.getCurrency();

      print("******************************* currencyList ${currencyList.length}");

      emit(state.copyWith(currencies: currencyList, status: Status.success));
    });

    on<SelectDateEvent>((event, emit) async{
      emit(state.copyWith(status: Status.loading));

      var date = event.date;

      print("******************************* SelectDateEvent $date");

      var currencyList = await ApiService().getCurrencyByDate(date);

      emit(state.copyWith(status: Status.success, currencies: currencyList,));
    });

    on<InitCalculate>((event, emit) {
      emit(state.copyWith(initCalculate: true, isSwap: false, isUzbTo: false, text1: "1.00", text2: event.currencyData.rate));
    });

    on<ClickSwapCalculateEvent>((event, emit){
      emit(state.copyWith(
        initCalculate: true,
        isSwap: true,
        isUzbTo: !state.isUzbTo,
        text1: state.text2,
        text2: state.text1,
      ));
    });

    on<ClickCalculateEvent>((event, emit) {

      print("************************** calculate qilish kerak ${event.value} ${event.text1} ${event.isUzbTo}");

      double usdToUzsRate = double.parse(event.value.replaceAll(",", "")); // Rate from the provided data

      double convertUsdToUzs(double usdAmount) {
        print("************************** $usdAmount * $usdToUzsRate=${usdAmount * usdToUzsRate}");
        return usdAmount * usdToUzsRate;
      }

      double convertUzsToUsd(double uzsAmount) {
        return uzsAmount / usdToUzsRate;
      }

      var inputMoney = double.parse(event.text1.replaceAll(",", ""));

      var res = event.isUzbTo ? convertUzsToUsd(inputMoney) : convertUsdToUzs(inputMoney);

      print("************************** calculate qilindi $res");

      emit(state.copyWith(text2: res.toString(), isSwap: false, initCalculate: false, isCalculate: true));
    });
  }
}