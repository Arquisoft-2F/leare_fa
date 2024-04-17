import 'package:flutter/material.dart';

class EditCourseForm extends StatefulWidget {
  const EditCourseForm({super.key});

  @override
  State<EditCourseForm> createState() => _EditCourseFormState();
}

class _EditCourseFormState extends State<EditCourseForm> {
  static const List<Map<String, String>> categories = [
    {"category_name": "Tecnología"},
    {"category_name": "Comedia"},
    {"category_name": "Actualidad"}
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ingrese el nombre del curso',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 17,
                      fontWeight: FontWeight.normal)),
              const SizedBox(
                height: 5,
              ),
              const TextField(
                maxLines: null,
                enableSuggestions: true,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Nombre del curso',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ingrese la descripción del curso',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 17,
                      fontWeight: FontWeight.normal)),
              const SizedBox(
                height: 5,
              ),
              const TextField(
                maxLines: null,
                enableSuggestions: true,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Descripción del curso',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          Container(
            child: Column(
              children: [
                Text('Seleccione las categorías más adecuadas para el curso',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 17,
                        fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Container(
            child: Wrap(
                alignment: WrapAlignment.center,
                children: categories.map<CheckboxExample>((cat) {
                  return CheckboxExample(category_name: cat['category_name']);
                }).toList()),
          ),
          const SizedBox(
            height: 14,
          ),
          Container(child: const RadioExample())
        ],
      ),
    );
  }
}

class RadioExample extends StatefulWidget {
  const RadioExample({super.key});

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  String? _selectedOption = "Público";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            const Text(
              'Público',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Radio<String>(
              value: "Público",
              groupValue: _selectedOption,
              onChanged: (String? value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
            const SizedBox(
              width: 8,
            )
          ],
        ),
        Row(
          children: [
            const Text(
              'Privado',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Radio<String>(
              value: "Privado",
              groupValue: _selectedOption,
              onChanged: (String? value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

class CheckboxExample extends StatefulWidget {
  final String? category_name;
  const CheckboxExample({super.key, required this.category_name});

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffdae3fb),
            border: Border.all(color: Colors.blueAccent, width: 2),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(widget.category_name!, style: const TextStyle(fontSize: 18)),
            Checkbox(
              checkColor: Colors.white,
              activeColor: Colors.blue,
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
