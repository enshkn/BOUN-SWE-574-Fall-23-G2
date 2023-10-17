import 'package:flutter/material.dart';

class MaskedTextController extends TextEditingController {
  MaskedTextController({
    required this.mask,
    super.text,
    Map<String, RegExp>? translator,
  }) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    addListener(() {
      final previous = _lastUpdatedText;
      if (beforeChange(previous, text)) {
        updateText(text);
        afterChange(previous, text);
      } else {
        updateText(_lastUpdatedText);
      }
    });

    updateText(text);
  }

  late String mask;

  late Map<String, RegExp> translator;

  void afterChange(String previous, String next) {}

  bool beforeChange(String previous, String next) {
    return true;
  }

  String _lastUpdatedText = '';

  void updateText(String text) {
    this.text = _applyMask(mask, text);

    _lastUpdatedText = this.text;
  }

  void updateMask(String mask, {bool moveCursorToEnd = true}) {
    this.mask = mask;
    updateText(text);

    if (moveCursorToEnd) {
      this.moveCursorToEnd();
    }
  }

  void moveCursorToEnd() {
    final text = _lastUpdatedText;
    selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      moveCursorToEnd();
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return {
      'A': RegExp('[A-Za-z]'),
      '0': RegExp('[0-9]'),
      '@': RegExp('[A-Za-z0-9]'),
      '*': RegExp('.*')
    };
  }

  String _applyMask(String mask, String value) {
    var result = '';

    var maskCharIndex = 0;
    var valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      final maskChar = mask[maskCharIndex];
      final valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (translator.containsKey(maskChar)) {
        if (translator[maskChar]!.hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      final buffer = StringBuffer();
      buffer.writeAll([result, maskChar]);
      result = buffer.toString();
      maskCharIndex += 1;
      continue;
    }

    return result;
  }
}
