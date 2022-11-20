import 'package:chat_app2/controller/chat_controller.dart';
import 'package:chat_app2/view/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show_snack_bar.dart';
import '../widgets/custo_bottom.dart';
import '../widgets/custom_text_field.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class RegisterPage extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
        init: ChatController(),
        builder: (controller) {
          return ModalProgressHUD(
            inAsyncCall: controller.isLoading,
            child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                    child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                          width: 200,
                          height: 150,
                          child: Image.asset('assets/images/scholar.png')),
                      const Text(
                        'Chat App',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Pacifico',
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 12),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: CustomTextFormField(
                          onChanged: (data) {
                            controller.email = data;
                          },
                          hintName: "user name",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: CustomTextFormField(
                          obscureText: true,
                          onChanged: (data) {
                            controller.password = data;
                          },
                          hintName: "password",
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: CustomButton(
                          onPressed: (() async {
                            if (formKey.currentState!.validate()) {
                              controller.check(true);
                              try {
                                await controller.registerUser();
                                showSnackBar(title: "", message: "success");
                                Get.off(ChatPage());
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  showSnackBar(
                                      title: "error",
                                      message:
                                          "The password provided is too weak.");
                                } else if (e.code == 'email-already-in-use') {
                                  showSnackBar(
                                      title: "error",
                                      message:
                                          "The account already exists for that email.");
                                }
                              } catch (e) {
                                showSnackBar(
                                    title: "error",
                                    message: "there was an error");
                              }
                              controller.check(false);
                            }
                          }),
                          textName: 'Login',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("you have an account ? "),
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Text('Sign In',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ],
                  ),
                )),
              ),
            ),
          );
        });
  }
}
