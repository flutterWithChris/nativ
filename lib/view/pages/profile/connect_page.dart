import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nativ/bloc/profile/profile_bloc.dart';
import 'package:nativ/main.dart';
import 'package:nativ/view/screens/chat/chat_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ConnectPage extends StatelessWidget {
  const ConnectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const bool isNextButtonEnabled = true;
    final PageController pageController = PageController();
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60), child: MainAppBar()),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PageView(
          controller: pageController,
          children: [
            TripInfo(controller: pageController),
            const ConnectType(),
          ],
        ),
      ),
      bottomSheet: Container(
        color: const Color(0xff18465A).withAlpha(255),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut),
                child: const Text('BACK'),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: SmoothPageIndicator(
                  onDotClicked: (index) => pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut),
                  controller: pageController,
                  count: 4,
                  effect: WormEffect(
                    spacing: 16,
                    dotColor: Colors.black26,
                    activeDotColor: Colors.teal.shade700,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                  onPressed: isNextButtonEnabled
                      ? () {
                          pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        }
                      : null,
                  child: const Text('NEXT')),
            ),
          ],
        ),
      ),
    );
  }
}

class TripInfo extends StatelessWidget {
  final PageController controller;
  const TripInfo({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'When is Your Trip?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SfDateRangePicker(
              todayHighlightColor: const Color(0xfff37d64).withOpacity(.9),
              rangeSelectionColor: const Color(0xfff37d64).withOpacity(.45),
              endRangeSelectionColor: const Color(0xfff37d64),
              startRangeSelectionColor: const Color(0xfff37d64),
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton.icon(
              onPressed: () {
                controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              icon: const Icon(Icons.calendar_month),
              label: const Text('Set Dates')),
        )
      ]),
    );
  }
}

class ConnectType extends StatelessWidget {
  const ConnectType({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 125),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('How should we connect?',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(
            height: 30,
          ),
          Wrap(
            spacing: 16.0,
            direction: Axis.vertical,
            children: [
              OutlinedButton(
                  style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                      fixedSize:
                          MaterialStateProperty.all(const Size(360, 60))),
                  onPressed: () {},
                  child: ListTile(
                    style: Theme.of(context).listTileTheme.style,
                    leading: const Icon(Icons.camera),
                    title: const Text(
                      'Video Call',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                  )),
              OutlinedButton(
                  style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                      fixedSize:
                          MaterialStateProperty.all(const Size(360, 60))),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: BlocProvider.of<ProfileBloc>(context),
                          child: const ChatScreen(),
                        ),
                      ),
                    );
                  },
                  child: const ListTile(
                    //  style: Theme.of(context).listTileTheme.style,
                    leading: Icon(Icons.telegram_rounded),
                    title: Text(
                      'Messaging',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.chevron_right_rounded),
                  )),
              OutlinedButton(
                  style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                      fixedSize:
                          MaterialStateProperty.all(const Size(360, 60))),
                  onPressed: () {},
                  child: const ListTile(
                    //  style: Theme.of(context).listTileTheme.style,
                    leading: Icon(Icons.phone),
                    title: Text(
                      'Phone Call',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.chevron_right_rounded),
                  )),
              OutlinedButton(
                  style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                      fixedSize:
                          MaterialStateProperty.all(const Size(360, 60))),
                  onPressed: () {},
                  child: const ListTile(
                    //  style: Theme.of(context).listTileTheme.style,
                    leading: Icon(FontAwesomeIcons.personCircleCheck),
                    title: Text(
                      'In Person',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.chevron_right_rounded),
                  )),
            ],
          )
        ],
      ),
    ));
  }
}
