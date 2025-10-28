import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PlatformButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoButton.filled(onPressed: onPressed, child: Text(text));
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text(text),
      );
    }
  }
}

class PlatformTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData? icon;

  const PlatformTextField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.icon,
    super.key,
  });

  @override
  _PlatformTextFieldState createState() => _PlatformTextFieldState();
}

class _PlatformTextFieldState extends State<PlatformTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoTextField(
        controller: widget.controller,
        placeholder: widget.hintText,
        obscureText: _obscure,
        prefix: widget.icon != null
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(widget.icon, color: CupertinoColors.systemGrey),
        )
            : null,
        suffix: widget.obscureText
            ? GestureDetector(
          onTap: () => setState(() => _obscure = !_obscure),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              _obscure ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
              color: CupertinoColors.systemGrey,
            ),
          ),
        )
            : null,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      );
    } else {
      return TextField(
        controller: widget.controller,
        obscureText: _obscure,
        decoration: InputDecoration(
          prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
          hintText: widget.hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscure = !_obscure),
          )
              : null,
        ),
      );
    }
  }
}

class PlatformScaffold extends StatelessWidget {
  final Widget body;
  final Widget? appBar;

  const PlatformScaffold({required this.body, this.appBar, super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoPageScaffold(
        navigationBar: appBar as ObstructingPreferredSizeWidget?,
        child: body,
      );
    } else {
      return Scaffold(appBar: appBar as PreferredSizeWidget?, body: body);
    }
  }
}
