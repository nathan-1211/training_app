import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  String confirm = 'Confirmar',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: Theme.of(ctx).colorScheme.error,
                  foregroundColor: Theme.of(ctx).colorScheme.onError,
                  minimumSize: const Size(64, 48),
                )
              : FilledButton.styleFrom(minimumSize: const Size(64, 48)),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirm),
        ),
      ],
    ),
  );
  return result ?? false;
}

void showSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

/// Campo numérico grande. [decimal] habilita vírgula.
class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.controller,
    required this.label,
    this.decimal = false,
    this.suffix,
    this.autofocus = false,
    this.big = false,
    this.hint,
  });

  final TextEditingController controller;
  final String label;
  final bool decimal;
  final String? suffix;
  final bool autofocus;
  final bool big;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final style = big
        ? Theme.of(context).textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.w700)
        : Theme.of(context).textTheme.titleLarge;
    return TextField(
      controller: controller,
      autofocus: autofocus,
      style: style,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          decimal ? RegExp(r'[0-9.,]') : RegExp(r'[0-9]'),
        ),
      ],
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        hintText: hint,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 24, 4, 10),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleMedium
          ?.copyWith(color: Theme.of(context).colorScheme.primary),
    ),
  );
}

class EmptyHint extends StatelessWidget {
  const EmptyHint(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge
          ?.copyWith(color: Theme.of(context).colorScheme.outline),
    ),
  );
}
