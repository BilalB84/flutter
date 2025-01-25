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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wger/providers/routines.dart';
import 'package:wger/screens/routine_screen.dart';
import 'package:wger/widgets/core/text_prompt.dart';

class RoutinesList extends StatelessWidget {
  final RoutinesProvider _routineProvider;

  const RoutinesList(this._routineProvider);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _routineProvider.fetchAndSetAllRoutinesFull(),
      child: _routineProvider.items.isEmpty
          ? const TextPrompt()
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: _routineProvider.items.length,
              itemBuilder: (context, index) {
                final currentRoutine = _routineProvider.items[index];

                return Card(
                  child: ListTile(
                    onTap: () async {
                      _routineProvider.setCurrentPlan(currentRoutine.id!);
                      final routine =
                          await _routineProvider.fetchAndSetRoutineFull(currentRoutine.id!);

                      Navigator.of(context).pushNamed(
                        RoutineScreen.routeName,
                        arguments: routine,
                      );
                    },
                    title: Text(currentRoutine.name),
                    subtitle: Text(
                      '${DateFormat.yMd(Localizations.localeOf(context).languageCode).format(currentRoutine.start)}'
                      ' - ${DateFormat.yMd(Localizations.localeOf(context).languageCode).format(currentRoutine.end)}',
                    ),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      const VerticalDivider(),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: AppLocalizations.of(context).delete,
                        onPressed: () async {
                          // Delete workout from DB
                          await showDialog(
                            context: context,
                            builder: (BuildContext contextDialog) {
                              return AlertDialog(
                                content: Text(
                                  AppLocalizations.of(context).confirmDelete(currentRoutine.name),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      MaterialLocalizations.of(context).cancelButtonLabel,
                                    ),
                                    onPressed: () => Navigator.of(contextDialog).pop(),
                                  ),
                                  TextButton(
                                    child: Text(
                                      AppLocalizations.of(context).delete,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                    onPressed: () {
                                      // Confirmed, delete the workout
                                      Provider.of<RoutinesProvider>(
                                        context,
                                        listen: false,
                                      ).deleteRoutine(currentRoutine.id!);

                                      // Close the popup
                                      Navigator.of(contextDialog).pop();

                                      // and inform the user
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            AppLocalizations.of(context).successfullyDeleted,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}
