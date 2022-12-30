import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zzzleep/functions/sleepdatachart.dart';
import 'package:zzzleep/providers/animationprovider.dart';
import 'package:zzzleep/providers/sleepdataprovider.dart';
import '../functions/sleepconverter.dart';

class SleepChart extends StatefulWidget {
  SleepChart({Key? key, @required this.wholeList}) : super(key: key);

  List? wholeList;
  @override
  _SleepChartState createState() => _SleepChartState();
}

class _SleepChartState extends State<SleepChart> {
  Color indigo = Colors.indigo[900]!;
  late TooltipBehavior _tooltipBehavior;
  List average = [];
  double max = 0;
  // double min = 0;
  String dateMax = '';
  String dateMin = '';
  List<SleepChartData> chartData = [];
  double fontSize = 21;
  Map data = {};

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        shared: true,
        animationDuration: 2,
        tooltipPosition: TooltipPosition.pointer,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          if (point.y is String) {
            point.y = point.y;
          } else {
            point.y = SleepInput.pointY(pointY: point.y);
          }
          if (point.x is String) {
            point.x = point.x;
          } else {
            point.x = SleepInput.pointX(pointX: point.x);
          }

          return TooltipAppearence(
            pointY: point.y,
            pointX: point.x,
          );
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var animationProvider = Provider.of<AnimationProvider>(context);
    var sleepDataProvider = Provider.of<SleepDataProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    if (animationProvider.getShowChartData) {
      chartData = sleepDataProvider.getChartData;
      data = SleepInput.calculateData();
      max = data['max'];
      average = data['average'];
    }
    return !animationProvider.getShowChartData
        ? const SizedBox()
        : Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SfCartesianChart(
                      enableAxisAnimation: true,
                      tooltipBehavior: _tooltipBehavior,
                      primaryXAxis: DateTimeCategoryAxis(
                          axisLine:
                              const AxisLine(color: Colors.white, width: 2.5),
                          labelRotation: 35,
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize - 6,
                          ),
                          labelPlacement: LabelPlacement.onTicks,
                          majorGridLines: const MajorGridLines(width: 0),
                          tickPosition: TickPosition.inside,
                          dateFormat: SleepInput.dateFormater(false, true),
                          visibleMaximum:
                              chartData.isNotEmpty ? chartData.last.date : null,
                          visibleMinimum: chartData.isNotEmpty
                              ? chartData.length < 8
                                  ? chartData.first.date
                                  : chartData.last.date!.add(Duration(
                                      days: -(screenWidth / 100).round() * 2))
                              : null,
                          maximumLabels: (screenWidth / 100).round() * 2),
                      primaryYAxis: NumericAxis(
                          title: AxisTitle(
                              text: 'Hours',
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: fontSize - 5,
                              )),
                          axisLine:
                              const AxisLine(color: Colors.white, width: 2.5),
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize - 6,
                          ),
                          majorTickLines: const MajorTickLines(width: 0),
                          tickPosition: TickPosition.inside,
                          majorGridLines: const MajorGridLines(width: 0),
                          interval: 2,
                          visibleMaximum: max + 3,
                          visibleMinimum: 0,
                          decimalPlaces: 0,
                          edgeLabelPlacement: EdgeLabelPlacement.hide,
                          maximumLabels: 8),
                      series: <ChartSeries>[
                        SplineAreaSeries<SleepChartData, DateTime>(
                          enableTooltip: true,
                          name: 'hours',
                          animationDuration: 1500,
                          color: indigo.withOpacity(0.7),
                          borderColor: Colors.white,
                          borderWidth: 2,
                          borderDrawMode: BorderDrawMode.top,
                          dataSource: chartData,
                          xValueMapper: (SleepChartData date, _) => date.date,
                          yValueMapper: (SleepChartData hours, _) =>
                              hours.hours,
                        )
                      ],
                      plotAreaBorderWidth: 2,
                      plotAreaBorderColor: Colors.transparent,
                      zoomPanBehavior: ZoomPanBehavior(
                          enablePanning: true, zoomMode: ZoomMode.x),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Average(color: indigo, hrs: average),
                    const SizedBox(
                      height: 110,
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

class TooltipAppearence extends StatelessWidget {
  const TooltipAppearence(
      {Key? key, @required this.pointY, @required this.pointX})
      : super(key: key);

  final String? pointY;
  final String? pointX;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        height: 78,
        width: 145,
        child: Column(
          children: [
            Text(
              pointX!,
              style: const TextStyle(
                color: Colors.indigo,
                fontSize: 16,
              ),
            ),
            const Divider(
              color: Colors.white54,
              thickness: 1,
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                      colors: [Colors.indigo[900]!, Colors.indigo[700]!])),
              child: Text(
                'Sleep time: $pointY',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ));
  }
}

class Average extends StatelessWidget {
  const Average({Key? key, @required this.color, @required this.hrs})
      : super(key: key);
  final Color? color;
  final List? hrs;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 205,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 2.5,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Average:',
            style: TextStyle(fontSize: 21, color: Colors.white),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 100,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              hrs![0] == 0 && hrs![1]! > 0
                  ? '${hrs![1]} min'
                  : hrs![0] > 0 && hrs![1] == 0
                      ? '${hrs![0]}'
                      : hrs![0]! > 0 && hrs![1] > 0
                          ? hrs![1] < 10
                              ? '${hrs![0]}:0${hrs![1]}'
                              : '${hrs![0]}:${hrs![1]}'
                          : '--:--',
              style: TextStyle(fontSize: 18, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
