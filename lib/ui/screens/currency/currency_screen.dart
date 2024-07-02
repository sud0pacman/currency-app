import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:valyuta_kursi/bloc/currency_bloc.dart';
import 'package:valyuta_kursi/ui/theme/light_colors.dart';
import 'package:valyuta_kursi/util/status.dart';
import 'package:valyuta_kursi/util/ui_components.dart';

import '../../../data/source/model/response/currency_response.dart';
import '../../../util/imgs.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final CurrencyBloc _bloc = CurrencyBloc();
  bool isUzbTo = false;
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController label1 = TextEditingController();
  final TextEditingController label2 = TextEditingController();

  @override
  void initState() {
    _bloc.add(LoadTodayCurrencyEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: LightColors.background,
        appBar: myAppBar(),
        body: BlocProvider.value(
          value: _bloc,
          child: BlocConsumer<CurrencyBloc, CurrencyState>(
            listener: (context, state) {
              print("******************************** $state");
              if (state.status == Status.success && state.initCalculate) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (controller1.text != state.text1) {
                    controller1.text = state.text1;
                  }
                  if (controller2.text != state.text2) {
                    controller2.text = state.text2;
                  }
                  if(isUzbTo) {
                    label1.text = "UZS";
                  }
                });
              }
              if(state.isSwap)isUzbTo = state.isUzbTo;
              if(state.isCalculate) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // controller1.text = state.text1;
                  controller2.text = state.text2;
                });
              }
            },
            builder: (context, state) {
              if (state.status == Status.loading) {
                return Center(
                  child: Image.asset(
                    Images.loader_indicator,
                    height: 42,
                    width: 42,
                  ),
                );
              } else if (state.status == Status.success) {
                return listSection(state.currencies);
              } else {
                print("****************************** xatolik ${state}");
                return Center(
                  child: BoldText(text: "Aniqlanmagan xatolik"),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  AppBar myAppBar() {
    return AppBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      backgroundColor: Colors.deepPurple,
      title: Row(
        children: [
          NormalText(
            text: "Valyuta",
            fontSize: 20,
            color: Colors.white,
          ),
          const Spacer(),
          appBarIcons(CupertinoIcons.calendar, () {
            _selectDate();
          }),
          const SizedBox(
            width: 10,
          ),
          appBarIcons(Icons.language, () {}),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked =  await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime.now()

    );

    if(picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      print("********************* selectData ${formattedDate}");
      _bloc.add(SelectDateEvent(date: formattedDate));
    }
  }

  Widget listSection(List<CurrencyModel> currencyList) {
    return ListView.builder(
      itemCount: currencyList.length,
      itemBuilder: (context, index) => currencyItem(currencyList[index],));
  }

  Future<void> showCalculateDialog(CurrencyModel currencyData) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 50,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(80),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  BoldText(
                    text: currencyData.ccyNmUz ?? "Not",
                    fontSize: 18,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  myTextField(controller1, isUzbTo ? "UZS" : currencyData.ccy ?? "", true, (msg) {
                    print("******************* textfield ${msg}");
                    if(msg.trim().isNotEmpty) {
                      _bloc.add(ClickCalculateEvent(text1: msg,
                          text2: controller2.text,
                          isUzbTo: isUzbTo,
                          value: currencyData.rate ?? "1.0"));
                    }
                  }),
                  const SizedBox(height: 16,),
                  myTextField(controller2, !isUzbTo ? "UZS" : currencyData.ccy ?? "", false, (msg) {

                  }),
                  const SizedBox(height: 8,),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        _bloc.add(ClickSwapCalculateEvent(isUzbTo: isUzbTo));

                        setState(() {
                          isUzbTo = !isUzbTo; // Toggle the isUzbTo flag
                        });
                      },
                      child: Container(
                        height: 42,
                        width: 42,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: const Icon(
                          Icons.swap_vert_sharp,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget myTextField(TextEditingController controller, String labelText, bool canChange, void Function(String) listener) {
    return SizedBox(
      height: 54,
      child: StatefulBuilder(
        builder: (context, setState) {
          return TextField(
            readOnly: !canChange,
            keyboardType: TextInputType.number,
            cursorColor: Colors.grey,
            inputFormatters: [CommaTextInputFormatter()],
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            controller: controller,
            onChanged: (text) => listener(text),
          );
        },
      ),
    );
  }


  Widget currencyItem(CurrencyModel currencyData) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              offset: Offset(2, 4), // Shadow position
            ),
          ]),
      child: Theme(
        data: Theme.of(context)
            .copyWith(dividerColor: Colors.transparent, splashColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Builder(builder: (context) {
                double diff = double.parse(currencyData.diff ?? "0.0");
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: currencyData.ccyNmUz,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: .0)),
                        TextSpan(
                            text:
                            "  ${diff < 0.0 ? "" : "+"}${currencyData.diff ?? "Not"}",
                            style: TextStyle(
                                color: diff < 0
                                    ? Colors.red
                                    : Colors.greenAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                height: .0))
                      ]),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text:
                            "${currencyData.nominal} ${currencyData.ccy}=> ${currencyData.rate} UZS | ",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              height: .0,
                              fontWeight: FontWeight.normal,
                            )),
                        WidgetSpan(
                            child: Image.asset(
                              Images.date,
                              height: 16,
                              width: 16,
                              fit: BoxFit.cover,
                            )),
                        TextSpan(
                            text: " ${currencyData.date}",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              height: .0,
                              fontWeight: FontWeight.normal,
                            )),
                      ]),
                    ),
                  ],
                );
              }),
            ],
          ),
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  _bloc.add(InitCalculate(currencyData: currencyData));
                  showCalculateDialog(currencyData);
                },
                child: Container(
                    margin: const EdgeInsets.only(
                      right: 15,
                      bottom: 5,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.deepPurple,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calculate,
                          size: 20,
                          color: Colors.white,
                        ),
                        NormalText(
                          text: "Hisoblash",
                          color: Colors.white,
                          fontSize: 14,
                        )
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

