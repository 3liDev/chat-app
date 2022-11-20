import 'package:chat_app2/controller/chat_controller.dart';
import 'package:chat_app2/models/message.dart';
import 'package:chat_app2/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/chat_buble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class ChatPage extends StatelessWidget {
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);

  final _control = ScrollController();
  TextEditingController control = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GetBuilder<ChatController>(
          init: ChatController(),
          builder: (controller) {
            return StreamBuilder<QuerySnapshot>(
                stream:
                    messages.orderBy(kCreatedAt, descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Message> messagesList = [];
                    for (int i = 0; i < snapshot.data!.docs.length; i++) {
                      messagesList
                          .add(Message.fromJson(snapshot.data!.docs[i]));
                    }
                    return Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: kPrimaryColor,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              kLogo,
                              height: 50,
                            ),
                            const Text('chat'),
                          ],
                        ),
                        centerTitle: true,
                      ),
                      body: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              reverse: true,
                              controller: _control,
                              itemCount: messagesList.length,
                              itemBuilder: (context, index) {
                                return messagesList[index].id ==
                                        controller.email
                                    ? ChatBuble(
                                        message: messagesList[index],
                                      )
                                    : ChatBubleForFriend(
                                        message: messagesList[index]);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              controller: control,
                              onChanged: (data) {
                                controller.updateData(data);
                              },
                              onSubmitted: (data) {
                                messages.add({
                                  KMessage: data,
                                  kCreatedAt: DateTime.now(),
                                  kId: controller.email
                                });
                                control.clear();
                                _control.animateTo(
                                  0, //_control.position.maxScrollExtent,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                );
                              },
                              decoration: InputDecoration(
                                hintText: 'Send Message',
                                suffixIcon: IconButton(
                                  color: kPrimaryColor,
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.greenAccent,
                                  ),
                                  onPressed: () {
                                    if (controller.data != null) {
                                      messages.add({
                                        KMessage: controller.data,
                                        kCreatedAt: DateTime.now(),
                                        kId: controller.email
                                      });
                                      control.clear();
                                      controller.data = null;
                                      _control.animateTo(
                                        0, //_control.position.maxScrollExtent,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.fastOutSlowIn,
                                      );
                                    }
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Scaffold(
                      body: Center(child: Text('loading...')),
                    );
                  }
                });
          }),
    );
  }
}
