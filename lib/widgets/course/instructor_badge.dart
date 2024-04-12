import 'package:flutter/material.dart';

class InstructorBadge extends StatelessWidget {
  final String profilePic;
  final String nombre;
  final String apellido;
  final String nickname;
  const InstructorBadge(
      {super.key,
      required this.profilePic,
      required this.nombre,
      required this.apellido,
      required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffdfe2eb),
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'Instructor',
                style: TextStyle(
                    color: Color(0xff43474e),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                height: 3, width: double.infinity, color: const Color(0xff43474e)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipOval(
                    child: Image.asset(
                      profilePic,
                      width: 85,
                      height: 85,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    child: Flexible(
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
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.open_in_new,
                        color: Colors.black,
                        size: 45,
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
