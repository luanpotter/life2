import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'base_modal.dart';

final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

class NewLifeModal extends BaseModal {

  const NewLifeModal({
    Key key,
    @required createCallback,
    @required cancelCallback,
  }) : super(key: key, createCallback: createCallback, cancelCallback: cancelCallback);

  @override
  GlobalKey<FormBuilderState> formKey() => _formKey;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('New Life'),
      titlePadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      children: [
        FormBuilder(
          key: _formKey,
          initialValue: {
            'size': '5.0',
          },
          autovalidate: true,
          child: Column(
            children: [
              Text('For now Life only has property size.'),
              FormBuilderTextField(
                attribute: 'size',
                decoration: InputDecoration(labelText: 'Size', hintText: 'Size of the creature (0-10)'),
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
