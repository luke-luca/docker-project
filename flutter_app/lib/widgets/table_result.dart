import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/add_form.dart';
import '../services.dart';
import 'package:intl/intl.dart';

class TableResult extends StatefulWidget {
  const TableResult({super.key});

  @override
  State<TableResult> createState() => _TableResultState();
}

class _TableResultState extends State<TableResult> {
  String _countryName = 'A';
  List _matches = [];

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  void _fetchInitialData() async {
    final matches = await Requests.getAllMatches();
    setState(() {
      _matches = matches;
    });
  }

  void _fetchMatchesByCountry() async {
    final matches = await Requests.getMatchByCountry(_countryName);
    setState(() {
      _matches = matches;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 200,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: ' Nazwa Kraju',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _countryName = value;
                      value.isEmpty
                          ? _fetchInitialData()
                          : _fetchMatchesByCountry();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: AddForm(onAdd: _fetchInitialData),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Dodaj'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(150, 50),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 900,
          child: SingleChildScrollView(
            child: FutureBuilder(
                future: Requests.getAllMatches(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (_matches.isEmpty) {
                      return const Text('Brak meczy');
                    } else {
                      return DataTable(
                          columns: const [
                            DataColumn(
                                label: Text('Data',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Zespol A',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Zespol B',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Wynik',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('ID',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: _matches.map((match) {
                            final dateString = match['date'].toString();
                            final date =
                                DateFormat("EEE, d MMM yyyy HH:mm:ss 'GMT'")
                                    .parse(dateString);
                            final dateFormat =
                                DateFormat("dd-MM-yyyy").format(date);
                            return DataRow(cells: [
                              DataCell(Text(dateFormat)),
                              DataCell(Text(
                                match['homeTeam'],
                              )),
                              DataCell(Text(
                                match['awayTeam'],
                              )),
                              DataCell(
                                Text(
                                  '${match['homeTeamScore']} : ${match['awayTeamScore']}',
                                ),
                              ),
                              DataCell(IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await Requests.deleteMatch(match['id']);
                                  _fetchInitialData();
                                },
                              )),
                            ]);
                          }).toList());
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ),
        ),
      ],
    );
  }
}
