import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_api_chat_app/models/chat_message.dart';
import 'package:gemini_api_chat_app/pages/bloc/chat_bloc.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

ChatBloc chatBloc = ChatBloc();
TextEditingController textEditingController = TextEditingController();

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        buildWhen: (previous, current) => current is ChatState,
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatSuccessState:
              {
                List<ChatMessage> message =
                    (state as ChatSuccessState).messages;
                return Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/wallpaper.jpg"),
                    ),
                  ),
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      color: Colors.grey.withOpacity(0.5),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Gemini API',
                              style: TextStyle(
                                  fontFamily: 'Honk',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                  color: Color.fromARGB(255, 242, 238, 166)),
                            ),
                          ]),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: message.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.yellow.withOpacity(0.7),
                                  ),
                                  margin: const EdgeInsets.only(
                                      bottom: 10, left: 10, right: 10),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(message[index].role,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        message[index].parts.first.text,
                                        style: const TextStyle(
                                          fontSize:
                                              15, // Adjust the font size as needed
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ));
                            })),
                    if (chatBloc.loading)
                      Expanded(
                          child: Lottie.asset('assets/animation/ai_send.json')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: textEditingController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(248, 248, 247, 1),
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.amber, width: 3),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.amber, width: 3),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                                hintText: 'Be Creative',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: GestureDetector(
                              onTap: () {
                                if (textEditingController.text.isNotEmpty) {
                                  print('button clicked');
                                  chatBloc.add(ChatGenerateNewTextMessageEvent(
                                      inputMessage:
                                          textEditingController.text));
                                  textEditingController.clear();
                                  if (message.isNotEmpty) {
                                    print(message[0].role);
                                  } else {
                                    print('message is empty');
                                  }
                                }
                              },
                              child: Lottie.asset(
                                  'assets/animation/ai_send.json')),
                        ),
                      ],
                    )
                  ]),
                );
              }
            default:
              return Text('default');
          }
        },
      ),
    );
  }
}
