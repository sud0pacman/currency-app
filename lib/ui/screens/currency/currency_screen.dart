import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            listener: (context, state) {},
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

  Widget listSection(List<CurrencyModel> currencyList) {
    return ListView.builder(
        itemBuilder: (context, index) => currencyItem(currencyList[index]));
  }

  // Container(
  // width: double.infinity,
  // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  // padding: const EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 15),
  // alignment: Alignment.centerLeft,
  // decoration: const BoxDecoration(
  // color: Colors.white,
  // borderRadius: BorderRadius.all(Radius.circular(15)),
  // boxShadow: [
  // BoxShadow(
  // color: Colors.grey,
  // blurRadius: 4,
  // offset: Offset(2, 4), // Shadow position
  // ),
  // ]),

  Widget currencyItem(CurrencyModel currencyData) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.only(bottom: 8,),
      // alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(2, 4), // Shadow position
          ),
        ]
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent, splashColor: Colors.transparent),
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
                    const SizedBox(height: 5,),
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
                                color: diff < 0 ? Colors.red : Colors.greenAccent,
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
              child: Container(
                margin: EdgeInsets.only(
                  right: 15,
                  bottom: 5,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.deepPurple,
                ),
                child: Row(
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
                )
              ),
            )
          ],
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
          appBarIcons(CupertinoIcons.calendar, () {}),
          const SizedBox(
            width: 10,
          ),
          appBarIcons(Icons.language, () {}),
        ],
      ),
    );
  }
}

Widget appBarIcons(IconData icon, VoidCallback onTap) {
  return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Icon(
        icon,
        size: 24,
        color: Colors.white,
      ));
}

/*
* return Container(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/cupertino_activity_indicator.gif",
                height: 42,
                width: 42,
              ),
            );
            * */
