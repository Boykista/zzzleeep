import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zzzleep/functions/sleepdatachart.dart';
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
  double min = 0;
  String dateMax = '';
  String dateMin = '';
  String firstDate = '';
  double firstKg = 0;
  double opacity = 1;
  List<SleepChartData> chartData = [];
  double fontSize = 21;
// Future getChartData()async{

// }

  void updateTooltip({@required List? hours, List? minutes}) {
    _tooltipBehavior =
        TooltipBehavior(enable: true, shared: true, format: ' $hours:$minutes');
  }

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

          return TooltipAppearence(
            pointY: point.y,
            pointX: point.x,
          );
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var sleepDataProvider = Provider.of<SleepDataProvider>(context);
    chartData = SleepInput.chartData();
    average = SleepInput.calculateAverage();
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SfCartesianChart(
                enableAxisAnimation: true,
                tooltipBehavior: _tooltipBehavior,
                primaryXAxis: CategoryAxis(
                    axisLine: AxisLine(color: Colors.white, width: 2.5),
                    arrangeByIndex: true,
                    labelRotation: 35,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize - 6,
                    ),
                    labelPlacement: LabelPlacement.onTicks,
                    majorGridLines: const MajorGridLines(width: 0),
                    tickPosition: TickPosition.inside,
                    visibleMaximum: chartData.length.toDouble() - 1,
                    visibleMinimum: 0),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(
                      text: 'hours',
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize - 5,
                      )),
                  axisLine: AxisLine(color: Colors.white, width: 2.5),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize - 6,
                  ),
                  tickPosition: TickPosition.inside,
                  majorGridLines: const MajorGridLines(width: 0),
                  interval: 2,
                  visibleMaximum: 12,
                  visibleMinimum: 0,
                  decimalPlaces: 0,
                  edgeLabelPlacement: EdgeLabelPlacement.hide,
                ),
                series: <ChartSeries>[
                  SplineAreaSeries<SleepChartData, String>(
                    enableTooltip: true,
                    name: 'hours',
                    animationDuration: 1500,
                    color: indigo.withOpacity(0.7),
                    borderColor: Colors.white,
                    borderWidth: 2,
                    borderDrawMode: BorderDrawMode.top,
                    dataSource: chartData,
                    xValueMapper: (SleepChartData date, _) => date.date,
                    yValueMapper: (SleepChartData hours, _) => hours.hours,
                    // markerSettings:
                    //     MarkerSettings(isVisible: true, color: indigo)
                  )
                ],
                plotAreaBorderWidth: 2,
                plotAreaBorderColor: Colors.transparent,
                zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 2750),
                  child: Average(color: indigo, hrs: average)),
              SizedBox(
                height: 25,
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
        padding: EdgeInsets.all(8),
        height: 77,
        width: 138,
        child: Column(
          children: [
            Text(
              '$pointX',
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 16,
              ),
            ),
            Divider(
              color: Colors.white54,
              thickness: 1,
            ),
            Container(
              // margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // color: Colors.black12,
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: Colors.black38, blurRadius: 3, spreadRadius: 3)
                  // ]
                  gradient: LinearGradient(
                      colors: [Colors.indigo[900]!, Colors.indigo[700]!])),
              child: Text(
                'Sleep time: $pointY',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ));
  }
}

class Average extends StatelessWidget {
  Average({Key? key, @required this.color, @required this.hrs})
      : super(key: key);
  final Color? color;
  final List? hrs;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
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
          Text(
            'Average:',
            style: TextStyle(fontSize: 21, color: Colors.white),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 100,
            padding: EdgeInsets.all(8),
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
