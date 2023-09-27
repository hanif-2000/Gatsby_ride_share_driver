import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/history/data/models/history_response_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../pages/detail_history_page.dart';

class HistoryItem extends StatefulWidget {
  final HistoryOrder data;

  const HistoryItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _HistoryItemState createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  @override
  Widget build(BuildContext context) {
    String orderDate = getDateString(widget.data.orderTime!);

    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, DetailHistoryPage.routeName,
              arguments: widget.data);
        },
        child: Container(
          height: 200,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(0, 7), // changes position of shadow
            ),
          ]),
          child: LayoutBuilder(builder: (context, constraint) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    height: constraint.maxHeight * 0.25,
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 2,
                                child: AutoSizeText(
                                  orderDate,
                                  maxLines: 1,
                                  style: const TextStyle(color: whiteColor),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: AutoSizeText(
                                  getHistoryStatus(
                                      widget.data.status.toString()),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(color: whiteColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                Container(
                    height: constraint.maxHeight * 0.4,
                    decoration: const BoxDecoration(
                      color: whiteColor,
                      border: Border(
                          bottom:
                              BorderSide(color: secondaryColor, width: 0.5)),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: [
                            SizedBox(
                              height: constraint.maxHeight,
                              width: constraint.maxWidth * 0.7,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Icon(
                                          Icons.my_location,
                                          color: primaryColor,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          widget.data.startAddress!,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Icon(
                                          Icons.location_on,
                                          color: primaryColor,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(widget.data.endAddress!,
                                            overflow: TextOverflow.ellipsis),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: constraint.maxHeight,
                              width: constraint.maxWidth * 0.3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: AutoSizeText(
                                      mergePriceTxt(
                                          widget.data.total.toString()),
                                      maxLines: 1,
                                      style: const TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    )),
                Container(
                    height: constraint.maxHeight * 0.35,
                    decoration: const BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: [
                            SizedBox(
                              height: constraint.maxHeight,
                              width: constraint.maxWidth * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        appLoc.taxitype,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        appLoc.paymentmethod,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: constraint.maxHeight,
                              width: constraint.maxWidth * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: AutoSizeText(
                                        mergeTypeTaxi(
                                            widget.data.vehicleCategory),
                                        // overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Flexible(
                                      child: AutoSizeText(
                                        getPaymentMethod(widget.data),
                                        maxLines: 1,
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    )),
              ],
            );
          }),
        )
        // child: Container(
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20),
        //             topRight: Radius.circular(20))),
        //     child: Text('asd'))),
        );
  }
}
