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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wger/models/workouts/routine.dart';
import 'package:wger/screens/routine_edit_screen.dart';
import 'package:wger/widgets/routines/day.dart';

class RoutineDetail extends StatelessWidget {
  final Routine _routine;
  final bool viewMode;

  const RoutineDetail(this._routine, {this.viewMode = false, super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);

    return Column(
      children: [
        const SizedBox(height: 10),
        if (_routine.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(_routine.description),
          ),
        if (!viewMode && _routine.days.isEmpty)
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutineEditScreen.routeName, arguments: _routine.id);
              },
              child: Text(i18n.edit),
            ),
          ),
        ..._routine.dayDataCurrentIteration
            // TODO: we should probably add a block at the end of the days telling
            //       the user that there are no more days in the routine till next week
            // .where((dayData) => dayData.day != null)
            .map((dayData) => RoutineDayWidget(dayData, _routine.id!, viewMode)),
      ],
    );
  }
}
