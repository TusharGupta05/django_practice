import 'package:flutter/material.dart';
import 'package:notes_app/providers/selector.dart';
import 'package:provider/provider.dart';

class AuthTextFormField extends StatelessWidget {
  final String hinttext;
  final IconData prefixIcon;
  final String? initialValue;
  final void Function(String? str) onChanged;
  const AuthTextFormField({
    Key? key,
    required this.onChanged,
    required this.hinttext,
    required this.prefixIcon,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      child: Theme(
        data: ThemeData(
            colorScheme:
                ThemeData().colorScheme.copyWith(primary: Colors.black)),
        child: TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelStyle: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(letterSpacing: 1),
            labelText: hinttext,
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            prefixIcon: Icon(prefixIcon),
          ),
        ),
      ),
    );
  }
}

class PasswordTextFormField extends StatelessWidget {
  final void Function(String? str)? onChanged;
  final String? Function(String? str)? validator;
  final String hintText;
  final GlobalKey<FormState> passwordKey;
  const PasswordTextFormField(
      {Key? key,
      required this.passwordKey,
      this.hintText = "PASSWORD",
      required this.onChanged,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      child: Theme(
        data: ThemeData(
            colorScheme:
                ThemeData().colorScheme.copyWith(primary: Colors.black)),
        child: ChangeNotifierProvider<SelectorProvider<bool>>(
          create: (_) => SelectorProvider(true),
          builder: (_, __) => Consumer<SelectorProvider<bool>>(
            builder: (_, selectorProvider, ___) => Form(
              key: passwordKey,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.disabled,
                validator: validator,
                obscureText: !selectorProvider.val,
                onChanged: onChanged,
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelStyle: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(letterSpacing: 1),
                  labelText: hintText,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    splashRadius: 20,
                    icon: selectorProvider.val
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                    onPressed: () {
                      selectorProvider.change(!selectorProvider.val);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
