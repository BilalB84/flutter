/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (C) 2020, 2021 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * wger Workout Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wger/helpers/colors.dart';

/// Sample time series data type.
class TimeSeriesLog {
  final DateTime time;
  final double weight;

  TimeSeriesLog(this.time, this.weight);
}

class LogChartWidgetFl extends StatefulWidget {
  final Map _data;
  final DateTime _currentDate;

  const LogChartWidgetFl(this._data, this._currentDate);

  @override
  State<LogChartWidgetFl> createState() => _LogChartWidgetFlState();
}

class _LogChartWidgetFlState extends State<LogChartWidgetFl> {
  final interval = 15 * Duration.millisecondsPerDay / 1000 / 60;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          mainData(),
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        //horizontalInterval: 1,
        //verticalInterval: interval,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000 * 60);
              return Text(
                DateFormat.yMd(Localizations.localeOf(context).languageCode).format(date),
              );
            },
            interval: interval,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: (value, meta) {
              return Text(value.toString());
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      lineBarsData: [
        ...widget._data['chart_data'].map(
          (e) {
            return LineChartBarData(
              spots: [
                ...e.map((entry) => FlSpot(
                      DateTime.parse(entry['date']).millisecondsSinceEpoch / 1000 / 60,
                      double.parse(entry['weight']),
                    ))
              ],
              isCurved: false,
              color: getRandomColor(widget._data['chart_data'].length, e.first['reps']),
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
            );
          },
        )
      ],
    );
  }
}
