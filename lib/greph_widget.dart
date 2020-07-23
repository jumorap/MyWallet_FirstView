import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class PieGraphWidget extends StatefulWidget {
  final List<double> data;

  const PieGraphWidget({Key key, this.data}) : super(key: key);

  @override
  _PieGraphWidgetState createState() => _PieGraphWidgetState();
}

class _PieGraphWidgetState extends State<PieGraphWidget> {
  @override
  Widget build(BuildContext context) {
    List<Series<double, num>> series = [
      Series<double, int>(
        id: 'Gasto',
        //colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (value, index) => index,
        measureFn: (value, _) => value,
        data: widget.data,
        strokeWidthPxFn: (_, __) => 3,
      )
    ];

    return PieChart(series);
  }
}

class LinesGraphWidget extends StatefulWidget {
  final List<double> data;

  const LinesGraphWidget({Key key, this.data}) : super(key: key);

  @override
  _LinesGraphWidgetState createState() => _LinesGraphWidgetState();
}

class _LinesGraphWidgetState extends State<LinesGraphWidget> {

  _onSelectionChanged(SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    var time;
    final measures = <String, double>{};

    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum;
      selectedDatum.forEach((SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum;
      });
    }

    print(time);
    print(measures);
  }

  @override
  Widget build(BuildContext context) {
    List<Series<double, num>> series = [
      Series<double, int>(
        id: 'Gasto',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (value, index) => index,
        measureFn: (value, _) => value,
        data: widget.data,
        strokeWidthPxFn: (_, __) => 3,
      )
    ];

    return LineChart(series,
      animate: true,
      selectionModels: [
        SelectionModelConfig(
          type: SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
      domainAxis: NumericAxisSpec(
          tickProviderSpec: StaticNumericTickProviderSpec(
              [
                TickSpec(0, label: '01'),
                TickSpec(5, label: '06'),
                TickSpec(10, label: '11'),
                TickSpec(15, label: '16'),
                TickSpec(20, label: '21'),
                TickSpec(25, label: '26'),
                TickSpec(30, label: '31'),
              ]
          )
      ),
      primaryMeasureAxis: NumericAxisSpec(
        tickProviderSpec: BasicNumericTickProviderSpec(
          //Define the number of boxes in axis Y (eje Y)
          desiredTickCount: 7,
        ),
      ),
    );
  }
}