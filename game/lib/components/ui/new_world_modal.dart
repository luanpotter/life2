import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../constants.dart';

enum NewWorldType { EMPTY, BORDERED }

final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

class NewWorldModal extends StatelessWidget {
  final void Function(Map<String, dynamic>) createCallback;
  final void Function() cancelCallback;

  const NewWorldModal({
    Key key,
    @required this.createCallback,
    @required this.cancelCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('New World'),
      titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      children: [
        FormBuilder(
          key: _formKey,
          initialValue: {
            'width': '$GRID_WIDTH',
            'height': '$GRID_HEIGHT',
            'worldType': NewWorldType.EMPTY,
            'randomFood': '20',
            'randomBarrier': '20',
          },
          autovalidate: true,
          child: Column(
            children: <Widget>[
              FormBuilderTextField(
                attribute: 'width',
                decoration: InputDecoration(labelText: 'Width'),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(1),
                ],
              ),
              FormBuilderTextField(
                attribute: 'height',
                decoration: InputDecoration(labelText: 'Height'),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(1),
                ],
              ),
              FormBuilderDropdown(
                attribute: 'worldType',
                decoration: InputDecoration(labelText: 'World Type'),
                hint: Text('Choose World Type'),
                validators: [FormBuilderValidators.required()],
                items: NewWorldType.values
                    .map((value) =>
                        DropdownMenuItem(value: value, child: Text('$value')))
                    .toList(),
              ),
              FormBuilderTextField(
                attribute: 'randomFood',
                decoration: InputDecoration(labelText: 'Random Food Sources'),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0),
                ],
              ),
              FormBuilderTextField(
                attribute: 'randomBarrier',
                decoration: InputDecoration(labelText: 'Random Barriers'),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    child: Text('Create'),
                    onPressed: () {
                      if (_formKey.currentState.saveAndValidate()) {
                        createCallback(_formKey.currentState.value);
                      }
                    },
                  ),
                  MaterialButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      _formKey.currentState.reset();
                      cancelCallback();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
