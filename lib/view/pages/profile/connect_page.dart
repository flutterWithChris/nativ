import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nativ/bloc/profile/profile_bloc.dart';
import 'package:nativ/main.dart';
import 'package:nativ/view/screens/chat/chat_screen.dart';

class ConnectPage extends StatelessWidget {
  const ConnectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60), child: MainAppBar()),
      body: Center(
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
                    style: Theme.of(context)
                        .outlinedButtonTheme
                        .style!
                        .copyWith(
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
                    style: Theme.of(context)
                        .outlinedButtonTheme
                        .style!
                        .copyWith(
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
                    style: Theme.of(context)
                        .outlinedButtonTheme
                        .style!
                        .copyWith(
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
                    style: Theme.of(context)
                        .outlinedButtonTheme
                        .style!
                        .copyWith(
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
      )),
    );
  }
}
