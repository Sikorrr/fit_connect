import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  final List<Widget> steps;
  final PageController controller;
  final VoidCallback onFinished;
  final VoidCallback onNextPressed;

  const SliderWidget({
    super.key,
    required this.controller,
    required this.steps,
    required this.onFinished,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: BackButton(onPressed: () {
                  controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }),
              ),
              Expanded(child: steps[index]),
            ],
          ),
        );
      },
      itemCount: steps.length,
    );
  }
}
