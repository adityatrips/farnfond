import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HelloController extends GetxController {
  RxInt counter = 0.obs;
}

class Hello extends StatelessWidget {
  const Hello({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HelloController());

    return Center(
      child: Obx(
        () => Text("${controller.counter.value}"),
      ),
    );
  }
}
