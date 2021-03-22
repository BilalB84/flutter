/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (C) 2020 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * wger Workout Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:wger/helpers/json.dart';
import 'package:wger/models/nutrition/ingredient.dart';
import 'package:wger/models/nutrition/ingredient_weight_unit.dart';

import 'nutritrional_values.dart';

part 'meal_item.g.dart';

@JsonSerializable()
class MealItem {
  @JsonKey(required: true)
  int? id;

  @JsonKey(required: false, name: 'ingredient')
  int? ingredientId;

  @JsonKey(required: false, name: 'ingredient_obj')
  late Ingredient ingredientObj;

  @JsonKey(required: false)
  late int meal;

  @JsonKey(required: false, name: 'weight_unit')
  IngredientWeightUnit? weightUnit;

  @JsonKey(required: true, fromJson: toNum, toJson: toString)
  late num amount;

  MealItem({
    this.id,
    int? meal,
    //this.ingredientObj,
    ingredientId,
    this.weightUnit,
    num? amount,
  }) {
    if (meal != null) {
      this.meal = meal;
    }

    if (ingredientId != null) {
      this.ingredientId = ingredientId;
    }
    if (amount != null) {
      this.amount = amount;
    }
  }

  // Boilerplate
  factory MealItem.fromJson(Map<String, dynamic> json) => _$MealItemFromJson(json);

  Map<String, dynamic> toJson() => _$MealItemToJson(this);

  /// Calculations
  NutritionalValues get nutritionalValues {
    // This is already done on the server. It might be better to read it from there.
    var out = NutritionalValues();

    //final weight = this.weightUnit == null ? amount : amount * weightUnit.amount * weightUnit.grams;
    final weight = amount;

    out.energy = ingredientObj.energy * weight / 100;
    out.protein = ingredientObj.protein * weight / 100;
    out.carbohydrates = ingredientObj.carbohydrates * weight / 100;
    out.fat = ingredientObj.fat * weight / 100;
    out.fatSaturated = ingredientObj.fatSaturated * weight / 100;
    out.fibres = ingredientObj.fibres * weight / 100;
    out.sodium = ingredientObj.sodium * weight / 100;

    return out;
  }
}
