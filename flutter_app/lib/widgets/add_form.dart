import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/services.dart';
import 'package:date_time_picker/date_time_picker.dart';

class AddForm extends StatefulWidget {
  const AddForm({super.key, required this.onAdd});
  final VoidCallback onAdd;
  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _score1Controller = TextEditingController();

  final TextEditingController _score2Controller = TextEditingController();

  String? _selectedTeam1;

  String? _selectedTeam2;

  final List countries = [
    'Algieria',
    'Anglia',
    'Angola',
    'Arabia Saudyjska',
    'Argentyna',
    'Australia',
    'Austria',
    'Belgia',
    'Boliwia',
    'Brazylia',
    'Bośnia i Hercegowina',
    'Bułgaria',
    'Kamerun',
    'Canada',
    'Chile',
    'Chiny',
    'Chorwacja',
    'Czechy',
    'Demokratyczna Republika Konga',
    'Dania',
    'Egipt',
    'Ekwador',
    'Francja',
    'Ghana',
    'Grecja',
    'Haiti',
    'Hiszpania',
    'Holandia',
    'Honduras',
    'Indonezja',
    'Iran',
    'Irak',
    'Irlandia',
    'Irlandia Północna',
    'Islandia',
    'Izrael',
    'Jamajka',
    'Japonia',
    'Kanada',
    'Kolumbia',
    'Korea Północna',
    'Korea Południowa',
    'Kuwejt',
    'Kostaryka',
    'Maroko',
    'Meksyk',
    'Nigeria',
    'Norwegia',
    'Nowa Zelandia',
    'Niemcy',
    'Panama',
    'Paragwaj',
    'Peru',
    'Polska',
    'Południowa Afryka',
    'Portugalia',
    'Rumunia',
    'Salwador',
    'Senegal',
    'Serbia',
    'Słowacja',
    'Słowenia',
    'Szkocja',
    'Szwajcaria',
    'Szwecja',
    'Tunezja',
    'Turcja',
    'Togo',
    'Trynidad i Tobago',
    'Ukraina',
    'Urugwaj',
    'Węgry',
    'Walia',
    'Włochy',
    'Wybrzeże Kości Słoniowej',
    'Zjednoczone Emiraty Arabskie',
    'Stany Zjednoczone'
  ];

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return SizedBox(
      width: 400,
      height: 500,
      child: Form(
        key: key,
        child: ListView(
          children: [
            DateTimePicker(
              type: DateTimePickerType.date,
              dateMask: 'dd MMM, yyyy',
              initialValue: '',
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: const Icon(Icons.event),
              dateLabelText: 'Data',
              onChanged: (val) => _dateController.text = val,
              validator: (val) {
                return null;
              },
              onSaved: (val) => _dateController.text = val!,
            ),
            DropdownButtonFormField(
              value: _selectedTeam1,
              items: countries
                  .map((country) => DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTeam1 = value.toString();
                });
              },
              decoration: const InputDecoration(
                hintText: 'Zespol A',
              ),
              validator: (value) {
                if (value == null) {
                  return 'Wybierz zespół';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              value: _selectedTeam2,
              items: countries
                  .map((country) => DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTeam2 = value.toString();
                });
              },
              decoration: const InputDecoration(
                hintText: 'Zespol B',
              ),
              validator: (value) {
                if (value == _selectedTeam1) {
                  return 'Wybierz zespół';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _score1Controller,
              decoration: const InputDecoration(
                hintText: 'Wynik A',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Wypełnij pole';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _score2Controller,
              decoration: const InputDecoration(
                hintText: 'Wynik B',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Wypełnij pole';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (key.currentState!.validate()) {
                  Requests.postMatch(
                    DateTime.parse(_dateController.text),
                    _selectedTeam1!,
                    _selectedTeam2!,
                    int.parse(_score1Controller.text),
                    int.parse(_score2Controller.text),
                  );
                  widget.onAdd();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Wypełnij wszystkie pola'),
                    ),
                  );
                }
              },
              child: const Text('Dodaj'),
            ),
          ],
        ),
      ),
    );
  }
}
