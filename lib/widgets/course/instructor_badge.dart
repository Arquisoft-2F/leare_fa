import 'package:flutter/material.dart';
import 'package:leare_fa/pages/user_page.dart';

class InstructorBadge extends StatelessWidget {
  final String? profilePic;
  final String nombre;
  final String apellido;
  final String nickname;
  final String id;
  const InstructorBadge(
      {super.key,
      required this.profilePic,
      required this.nombre,
      required this.apellido,
      required this.nickname,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surfaceVariant,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ]),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Instructor',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(profilePic!),
                    radius: 30,
                  ),
                  const SizedBox(width: 9.0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('$nombre $apellido',
                            textAlign: TextAlign.center,
                            maxLines: null,
                            style: const TextStyle(
                                height: 1.2,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff43474e))),
                        Text(nickname,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                height: 1.2,
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff43474e)))
                      ],
                    ),
                  ),
                  const SizedBox(width: 9.0),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/profile",
                            arguments: UserArguments(id));
                      },
                      icon: const Icon(
                        Icons.open_in_new,
                        color: Colors.black,
                        size: 30.0,
                      ))
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
