import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zzzleep/functions/sleepdatachart.dart';
import 'package:zzzleep/providers/sleepdataprovider.dart';

import '../functions/sleepconverter.dart';

class SleepChart extends StatefulWidget {
  const SleepChart({Key? key}) : super(key: key);

  @override
  _SleepChartState createState() => _SleepChartState();
}

class _SleepChartState extends State<SleepChart> {
  Color indigo = Colors.indigo[900]!;
  late TooltipBehavior _tooltipBehavior;
  double average = 0;
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

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, shared: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var sleepDataProvider = Provider.of<SleepDataProvider>(context);
    chartData = SleepInput.chartData();
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

class Average extends StatelessWidget {
  Average({Key? key, @required this.color, @required this.hrs})
      : super(key: key);
  final Color? color;
  final double? hrs;
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
              '10:39',
              style: TextStyle(fontSize: 18, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
