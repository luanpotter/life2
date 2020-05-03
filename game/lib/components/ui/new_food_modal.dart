import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'base_modal.dart';

final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

class NewFoodModal extends BaseModal {

  const NewFoodModal({
    Key key,
    @required createCallback,
    @required cancelCallback,
  }) : super(key: key, createCallback: createCallback, cancelCallback: cancelCallback);

  @override
  GlobalKey<FormBuilderState> formKey() => _formKey;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('New Food'),
      titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      children: [
        FormBuilder(
          key: _formKey,
          initialValue: {
            'growthRate': '1.0',
            'currentNutrients': '0',
            'maxNutrients': '8.0',
          },
          autovalidate: true,
          child: Column(
            children: [
              Text('Food Sources have nutrients (their size) that grows per tick. Nutrient is a number between 1 and 10 always.'),
              FormBuilderTextField(
                attribute: 'growthRate',
                decoration: InputDecoration(labelText: 'Growth Rate', hintText: 'Nutrient growth per tick (0-10)'),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0),
                  FormBuilderValidators.max(10),
                ],
              ),
              FormBuilderTextField(
                attribute: 'currentNutrients',
                decoration: InputDecoration(labelText: 'Current Nutrients', hintText: 'Starting nutrients (0-10)'),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0),
                  FormBuilderValidators.max(10),
                ],
              ),
              FormBuilderTextField(
                attribute: 'maxNutrients',
                decoration: InputDecoration(labelText: 'Max Nutrients', hintText: 'Maximum nutrients this food source can ever have (0-10)'),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0),
                  FormBuilderValidators.max(10),
                ],
              ),
              buttonRow(),
            ],
          ),
        ),
      ],
    );
  }
}
