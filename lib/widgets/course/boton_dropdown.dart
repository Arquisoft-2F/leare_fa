import 'package:flutter/material.dart';

class BotonDrowdown extends StatelessWidget {
  const BotonDrowdown({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.white,
      icon: const Icon(
        Icons.more_vert,
        color: Color.fromRGBO(255, 255, 255, 1.0),
        size: 29,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: Text('Editar curso'),
          onTap: () {
            print('editar curso');
          },
        ),
        PopupMenuItem(
          child: Text('Zonas'),
          onTap: () {},
        ),
        PopupMenuItem(
          child: Text('Si'),
          onTap: () {},
        ),
      ],
    );
  }
}


// PopupMenuButton(
//   color: Colors.white,
//   icon: const Icon(
//     Icons.more_vert,
//     color: Color.fromRGBO(255, 255, 255, 1.0),
//     size: 29,
//   ),
//   itemBuilder: (BuildContext context) =>
//       <PopupMenuEntry>[
//     PopupMenuItem(
//       child: Text('Editar curso'),
//       onTap: () {
//         print('editar curso');
//       },
//     ),
//     PopupMenuItem(
//       child: Text('Item 2'),
//       onTap: () {},
//     ),
//     PopupMenuItem(
//       child: Text('Item 3'),
//       onTap: () {},
//     ),
//   ],
// )