import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  bool isLoading = false;
  String? email;
  String? password;
  bool? hidePassword = true;
  String? data;

  Future<void> loginUser() async {
    // ignore: unused_local_variable
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
    update();
  }

  Future<void> registerUser() async {
    // ignore: unused_local_variable
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
    update();
  }

  void check(bool state) {
    isLoading = state;
    update();
  }

  void showPassword() {
    hidePassword = !hidePassword!;
    update();
  }

  void updateData(dataMessage) {
    data = dataMessage;
    update();
  }
}
