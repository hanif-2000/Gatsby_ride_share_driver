import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/dimens.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? title;
  final int? maxLength;
  final String placeholder;
  final bool isSecure;
  final bool isError;
  final TextEditingController controller;
  final FormFieldValidator? fieldValidator;
  final TextInputType inputType;
  final bool refresh;
  final Function? onTap;
  final String? suffixText;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final bool border;
  final Function? onChanged;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final bool enablePadding;
  final bool isRounded;
  final EdgeInsets padding;
  final int maxLine;
  final Color backgroundColor;

  const CustomTextField(
      {Key? key,
      this.placeholder = '',
      this.title,
      this.maxLength,
      this.isSecure = false,
      this.isError = false,
      required this.controller,
      required this.fieldValidator,
      this.inputType = TextInputType.text,
      this.refresh = false,
      this.onTap,
      this.suffixText,
      this.border = false,
      this.onChanged,
      this.enabled = true,
      this.inputFormatters,
      this.enablePadding = false,
      this.isRounded = false,
      this.maxLine = 1,
      this.backgroundColor = shadowColor,
      this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      this.suffixWidget,
      this.prefixWidget})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _passwordVisible;

  late OutlineInputBorder normalBorder;

  late OutlineInputBorder errorBorder;

  late OutlineInputBorder roundErrorBorder;

  late OutlineInputBorder roundBorder;

  @override
  void initState() {
    _passwordVisible = widget.isSecure;
    normalBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      ),
      borderSide: BorderSide(
        color: widget.border ? Colors.grey : Colors.white,
      ),
    );
    errorBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      borderSide: BorderSide(
        color: errorRedColor,
      ),
    );
    roundBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
      borderSide: BorderSide(style: BorderStyle.none),
    );
    roundErrorBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ),
      borderSide: BorderSide(
        color: errorRedColor,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      height: 48,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: const TextSelectionThemeData(
                selectionColor: Colors.yellow,
              ),
            ),
            child: TextFormField(
              maxLength: widget.maxLength,
              maxLines: widget.maxLine,
              inputFormatters: widget.inputFormatters,
              enabled: widget.enabled,
              onTap: () {
                if (widget.refresh) {
                  widget.onTap!();
                }
              },
              onChanged: (str) {
                if (widget.onChanged != null) widget.onChanged!();
              },
              obscureText: _passwordVisible,
              controller: widget.controller,
              keyboardType: widget.inputType,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: sizeMedium),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: widget.placeholder,
                counterText: "",
                prefixIcon: widget.prefixWidget == null
                    ? null
                    : SizedBox(
                        width: 24, height: 24, child: widget.prefixWidget),
                suffixIcon: widget.isSecure
                    ? Material(
                        color: Colors.transparent,
                        child: IconButton(
                            splashRadius: 20.0,
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: Icon(_passwordVisible
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded)),
                      )
                    : widget.suffixText != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.suffixText!,
                                textAlign: TextAlign.center,
                                style: formTextFieldStyle,
                              ),
                            ],
                          )
                        : widget.suffixWidget,
              ),
              validator: widget.fieldValidator,
            ),
          )
          // Title section
          // widget.title != null
          //     ? Text(
          //         widget.title ?? "",
          //         style: formLabelStyle,
          //       )
          //     : const SizedBox.shrink(),
          // const SizedBox(height: 4.0),

          // Input field section
          // TextFormField(
          //   maxLines: widget.maxLine,
          //   inputFormatters: widget.inputFormatters,
          //   enabled: widget.enabled,
          //   maxLength: widget.maxLength,
          //   onTap: () {
          //     if (widget.refresh) {
          //       widget.onTap!();
          //     }
          //   },
          //   onChanged: (str) {
          //     if (widget.onChanged != null) widget.onChanged!();
          //   },
          //   obscureText: _passwordVisible,
          //   controller: widget.controller,
          //   keyboardType: widget.inputType,
          //   style: formTextFieldStyle,
          //   decoration: InputDecoration(
          //     focusColor: Colors.white,
          //     hintText: widget.placeholder,
          //     counterText: "",
          //     border: InputBorder.none,
          //     enabledBorder: widget.isRounded ? roundBorder : normalBorder,
          //     disabledBorder: widget.isRounded ? roundBorder : normalBorder,
          //     focusedBorder: widget.isRounded ? roundBorder : normalBorder,
          //     errorBorder: widget.isRounded ? roundErrorBorder : errorBorder,
          //     focusedErrorBorder:
          //         widget.isRounded ? roundErrorBorder : errorBorder,
          //     filled: true,
          //     fillColor: widget.isError ? Colors.white : widget.backgroundColor,
          //     contentPadding: widget.padding,
          //     suffixIcon: widget.isSecure
          //         ? Material(
          //             color: Colors.transparent,
          //             child: IconButton(
          //                 splashRadius: 20.0,
          //                 onPressed: () {
          //                   setState(() {
          //                     _passwordVisible = !_passwordVisible;
          //                   });
          //                 },
          //                 icon: Icon(_passwordVisible
          //                     ? Icons.visibility_off_rounded
          //                     : Icons.visibility_rounded)),
          //           )
          //         : widget.suffixText != null
          //             ? Column(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Text(
          //                     widget.suffixText!,
          //                     textAlign: TextAlign.center,
          //                     style: formTextFieldStyle,
          //                   ),
          //                 ],
          //               )
          //             : widget.suffixWidget,
          //   ),
          //   validator: widget.fieldValidator,
          // ),
        ],
      ),
    );
  }
}
