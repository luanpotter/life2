import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'new_food_modal.dart';
import 'new_life_modal.dart';
import 'new_world_modal.dart';
import 'tick_n_modal.dart';

abstract class BaseModal extends StatelessWidget {
  final void Function(Map<String, dynamic>) createCallback;
  final void Function() cancelCallback;

  const BaseModal({
    Key key,
    @required this.createCallback,
    @required this.cancelCallback,
  }) : super(key: key);

  static BaseModal create(
      String modal,
      void Function(Map<String, dynamic>) createCallback,
      void Function() cancelCallback) {
    switch (modal) {
      case 'NewWorldModal':
        return NewWorldModal(createCallback: createCallback, cancelCallback: cancelCallback);
      case 'NewFoodModal':
        return NewFoodModal(createCallback: createCallback, cancelCallback: cancelCallback);
      case 'NewLifeModal':
        return NewLifeModal(createCallback: createCallback, cancelCallback: cancelCallback);
      case 'TickNModal':
        return TickNModal(createCallback: createCallback, cancelCallback: cancelCallback);
      default:
        throw 'Invalid modal name $modal';
    }
  }

  GlobalKey<FormBuilderState> formKey();

  String createButtonText() =>  'Create';

  Row buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
          child: Text('Create'),
          onPressed: () {
            if (formKey().currentState.saveAndValidate()) {
              createCallback(formKey().currentState.value);
            }
          },
        ),
        MaterialButton(
          child: Text('Cancel'),
          onPressed: () {
            formKey().currentState.reset();
            cancelCallback();
          },
        ),
      ],
    );
  }
}
