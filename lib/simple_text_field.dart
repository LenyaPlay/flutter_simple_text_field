import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleTextField extends StatefulWidget {
  const SimpleTextField({super.key});

  @override
  State<SimpleTextField> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField>
    with TextInputClient {
  TextInputConnection? _connection;
  var _value = TextEditingValue.empty;

  void _onTap() {
    if (_connection == null || _connection!.attached == false) {
      print('open');
      _connection = TextInput.attach(this, const TextInputConfiguration());

      // important, it won't work without it
      _connection!.setEditingState(currentTextEditingValue!);

      // Show keyboard and something else
      _connection!.show();
    } else {
      print('close');
      _connection!.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        color: Colors.grey[500],
        child: Text(_value.text),
      ),
    );
  }

  @override
  void connectionClosed() {
    print('closed');
  }

  @override
  AutofillScope? get currentAutofillScope => null;

  @override
  TextEditingValue? get currentTextEditingValue => _value;

  @override
  void performAction(TextInputAction action) {
    print("action $action");
  }

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {
    print("performPrivateCommand\n $action\n $data");
  }

  @override
  void showAutocorrectionPromptRect(int start, int end) {
    print("showAutocorrectionPromptRect $start $end");
  }

  @override
  void updateEditingValue(TextEditingValue value) {
    print("updateEditingValue $value");
    // Move cursor to end
    _value = value.copyWith(
      selection: TextSelection(
        baseOffset: value.text.length,
        extentOffset: value.text.length,
      ),
    );
    _connection!.setEditingState(_value);
    setState(() {});
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {
    print("updateEditingValue $point");
  }
}
