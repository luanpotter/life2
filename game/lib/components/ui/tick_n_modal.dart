import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'base_modal.dart';

final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

class TickNModal extends BaseModal {

  const TickNModal({
    Key key,
    @required createCallback,
    @required cancelCallback,
  }) : super(key: key, createCallback: createCallback, cancelCallback: cancelCallback);

  @override
  GlobalKey<FormBuilderState> formKey() => _formKey;

  @override
  String createButtonText() =>  'Tick';

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Tick n'),
      titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      children: [
        FormBuilder(
          key: _formKey,
          initialValue: {
            'n': '1',
          },
          autovalidate: true,
          child: Column(
            children: [
              Text('Select how many ticks you would like to advance.'),
              FormBuilderTextField(
                attribute: 'n',
                decoration: InputDecoration(labelText: 'Number of Ticks'),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0),
                  FormBuilderValidators.max(100),
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
