import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NativListView extends StatelessWidget {
  const NativListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      //snap: true,
      // snapSizes: const [.5],
      minChildSize: 0.3,
      initialChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 80.0, 8.0, 0.0),
              child: NativListTiles(scrollController: scrollController),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                DragHandle(),
                SearchStickyHeader(),
              ],
            ),
          ],
        );
      },
    );
  }
}

class DragHandle extends StatelessWidget {
  const DragHandle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

Widget buildDragHandle() => GestureDetector(
      child: Center(
        child: Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );

class SearchStickyHeader extends StatelessWidget {
  const SearchStickyHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.lightBlue,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 3.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 12,
            ),
            buildDragHandle(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '32 Nativ\'s Found Nearby',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(
                  height: 40,
                  width: 100,
                  child: FittedBox(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          fixedSize: const Size(100, 40)),
                      onPressed: () {
                        print('filter pressed');
                      },
                      child: const Text(
                        'Filter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NativListTiles extends StatelessWidget {
  const NativListTiles({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: ((context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://www.zbrushcentral.com/uploads/default/original/4X/7/9/6/7966865da1c1203fd5250ab05bb1fc00ba8133e9.jpeg'),
              ),
              title: const Text('Thorin Oakenshield'),
              subtitle: const Text('Auckland, NZ'),
              trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4.0,
                children: const [
                  Text('4.5'),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                ],
              ),
            ),
            const ListTile(
              trailing: Icon(
                FontAwesomeIcons.arrowRight,
                color: Colors.blueAccent,
              ),
              subtitle: Text(
                  'I\'m a born & raised New Zealander who love to hike & finding the best food'),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: SizedBox(
                height: 35,
                child: FittedBox(
                  child: Chip(
                    backgroundColor: Colors.orange,
                    label: Text('Top Rated',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
            const Divider(),
          ],
        );
      }),
    );
  }
}
