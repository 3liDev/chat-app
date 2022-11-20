import 'package:chat_app2/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  String? hintName;
  bool? obscureText;
  Function(String)? onChanged;
  CustomTextFormField({
    Key? key,
    this.onChanged,
    this.hintName,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
        init: ChatController(),
        builder: (controller) {
          return TextFormField(
              obscureText: hintName == "password"
                  ? controller.hidePassword!
                  : obscureText!,
              // ignore: body_might_complete_normally_nullable
              validator: (data) {
                if (data!.isEmpty) {
                  return "field is required";
                }
              },
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintName,
                suffixIcon: hintName == "password"
                    ? IconButton(
                        icon: const Icon(
                          Icons.hide_source,
                        ),
                        onPressed: () {
                          controller.showPassword();
                        },
                      )
                    : null,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                border: const OutlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                label: Text('$hintName'),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ));
        });
  }
}
