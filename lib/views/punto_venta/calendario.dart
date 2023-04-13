import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarioWidget extends StatefulWidget {
  const CalendarioWidget({Key? key}) : super(key: key);

  @override
  State<CalendarioWidget> createState() => _CalendarioWidgetState();
}

class _CalendarioWidgetState extends State<CalendarioWidget> {
  String _range = '';
  @override
  Widget build(BuildContext context) {
    /// called whenever a selection changed on the date picker widget.
    void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      /// The argument value will return the changed date as [DateTime] when the
      /// widget [SfDateRangeSelectionMode] set as single.
      ///
      /// The argument value will return the changed dates as [List<DateTime>]
      /// when the widget [SfDateRangeSelectionMode] set as multiple.
      ///
      /// The argument value will return the changed range as [PickerDateRange]
      /// when the widget [SfDateRangeSelectionMode] set as range.
      ///
      /// The argument value will return the changed ranges as
      //
      /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
      /// multi range.
      setState(() {
        if (args.value is PickerDateRange) {
          _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
              // ignore: lines_longer_than_80_chars
              ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
        }
      });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            leading: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Selecciona una fecha',
              style: GoogleFonts.quicksand(
                color: Colors.black.withOpacity(.8),
              ),
            )),
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SfDateRangePicker(
                  monthFormat: 'MMMM',
                  view: DateRangePickerView.month,
                  minDate: DateTime(2022, 0, 0, 0, 0),
                  selectionTextStyle:
                      GoogleFonts.quicksand(color: Colors.white),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                      weekendTextStyle: GoogleFonts.quicksand(
                          color: Colors.black.withOpacity(.8)),
                      blackoutDateTextStyle:
                          GoogleFonts.quicksand(color: Colors.grey),
                      disabledDatesTextStyle:
                          GoogleFonts.quicksand(color: Colors.grey),
                      leadingDatesTextStyle:
                          GoogleFonts.quicksand(color: Colors.grey),
                      trailingDatesTextStyle:
                          GoogleFonts.quicksand(color: Colors.grey),
                      todayTextStyle: GoogleFonts.quicksand(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(1)),
                      textStyle: GoogleFonts.quicksand(
                          color: Colors.black.withOpacity(.8))),
                  rangeTextStyle: GoogleFonts.quicksand(color: Colors.blueGrey),
                  headerStyle: DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle: GoogleFonts.quicksand(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(1))),
                  rangeSelectionColor:
                      Theme.of(context).colorScheme.secondary.withOpacity(.1),
                  headerHeight: 60,
                  yearCellStyle: DateRangePickerYearCellStyle(
                      disabledDatesTextStyle: GoogleFonts.quicksand(
                          color: Colors.grey.withOpacity(.5), fontSize: 20),
                      todayCellDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: const Color.fromRGBO(41, 199, 184, 0),
                              width: 0)),
                      todayTextStyle: GoogleFonts.quicksand(
                        fontSize: 20,
                        color: Colors.black.withOpacity(.8),
                      ),
                      textStyle: GoogleFonts.quicksand(
                        color: Colors.black.withOpacity(.8),
                        fontSize: 20,
                      )),
                  selectionColor:
                      Theme.of(context).colorScheme.primary.withOpacity(1),
                  todayHighlightColor:
                      Theme.of(context).colorScheme.primary.withOpacity(1),
                  endRangeSelectionColor:
                      Theme.of(context).colorScheme.primary.withOpacity(1),
                  startRangeSelectionColor:
                      Theme.of(context).colorScheme.primary.withOpacity(1),
                  onSelectionChanged: onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  backgroundColor: Colors.white,
                  maxDate: DateTime.now(),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                      dayFormat: 'EE',
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          textStyle:
                              GoogleFonts.quicksand(color: Colors.black))),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 35, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.pop(context, null);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: Text('Cancelar',
                          style: GoogleFonts.quicksand(color: Colors.grey)),
                    ),
                  ),
                  GestureDetector(
                    onTap: _range == ''
                        ? null
                        : () {
                            Navigator.pop(context, _range);
                          },
                    child: AnimatedContainer(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      decoration: BoxDecoration(
                          color: _range == ''
                              ? Colors.grey.withOpacity(.1)
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(1),
                          borderRadius: BorderRadius.circular(20)),
                      duration: const Duration(microseconds: 500),
                      child: Text('Continuar',
                          style: GoogleFonts.quicksand(
                              color:
                                  _range == '' ? Colors.black : Colors.white)),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
