import 'package:employee/const/color.const.dart';
import 'package:employee/gen/assets.gen.dart';
import 'package:employee/widgets/trangle.widget.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
        height: 70.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xff1e202414).withOpacity(0.08),
                  offset: const Offset(2, -4),
                  spreadRadius: 0,
                  blurRadius: 20)
            ]),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 20.0,
              ),
              const Expanded(
                // height: 70.0,
                // width: 300,
                child: Center(
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message',
                        hintStyle: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: AppColors.lightPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Assets.icons.image.image(width: 50.0),
              const SizedBox(
                width: 10.0,
              )
            ],
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
              height: 180,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(color: Color(0xFFAAAFB6), width: 1))),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 60,
                      height: 60.0,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.14),
                              offset: const Offset(-2, 12),
                              spreadRadius: 0,
                              blurRadius: 24)
                        ],
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjBqBHVe6sgC-lKbpBQQmOyLKNDasEFqYCUw&usqp=CAU",
                            ))),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Thomas",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18.0),
                      ),
                      Text(
                        'Online',
                        style:
                            TextStyle(color: AppColors.lightGrey, fontSize: 16),
                      )
                    ],
                  ),
                  const Spacer(),
                  Assets.icons.phone.image(width: 40.0)
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: AppColors.lightPurple,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(-8, 11),
                                    blurRadius: 21,
                                    spreadRadius: 0,
                                    color: const Color(0xff1f324f24)
                                        .withOpacity(0.14))
                              ],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              )),
                          child: const Center(
                            child: Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          // width: MediaQuery.of(context).size.width * 0.7,
                          child: CustomPaint(
                            painter: TrianglePainter(
                                paintingStyle: PaintingStyle.fill,
                                strokeColor: AppColors.lightPurple),
                            child: const SizedBox(
                              width: 40.0,
                              height: 30.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(-8, 11),
                                    blurRadius: 21,
                                    spreadRadius: 0,
                                    color: const Color(0xff1f324f24)
                                        .withOpacity(0.14))
                              ],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              )),
                          child: const Center(
                            child: Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.0),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          // width: MediaQuery.of(context).size.width * 0.7,
                          child: CustomPaint(
                            painter: InvertedTrianglePainter(
                                paintingStyle: PaintingStyle.fill,
                                strokeColor: Colors.white),
                            child: const SizedBox(
                              width: 40.0,
                              height: 30.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
