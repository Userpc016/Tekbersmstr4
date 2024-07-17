import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nimController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController jurusanController = TextEditingController();
  TextEditingController prodiController = TextEditingController();
  List<dynamic> mahasiswa = [];
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    retrieve();
  }

  Future<void> simpan(String nim, String nama, String jurusan, String prodi) async {
    final response = await supabase.from('mahasiswa').insert({
      'nim': nim,
      'nama': nama,
      'jurusan': jurusan,
      'prodi': prodi,
    });

    if (response.error != null) {
      throw response.error!;
    }
  }

  void save() async {
    await supabase
        .from('UASsmstr4')
        .insert({
          'nim': nimController.text,
          'nama': namaController.text,
          'jurusan': jurusanController.text,
          'prodi': prodiController.text
        });
    retrieve();
    controllerClear();
  }

  void retrieve() async {
    final data = await supabase.from('UASsmstr4').select('*');
    setState(() {
      this.mahasiswa = data;
    });
    controllerClear();
  }

  void deleteRow(id) async {
    await supabase.from('UASsmstr4').delete().eq('id', id);
    retrieve();
  }

  void editRow(id) async {
    final data = mahasiswa.firstWhere((element) => element['id'] == id);
    nimController.text = data['nim'];
    namaController.text = data['nama'];
    jurusanController.text = data['jurusan'];
    prodiController.text = data['prodi'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Data Mahasiswa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nimController,
                decoration: InputDecoration(labelText: 'NIM Mahasiswa'),
              ),
              TextField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Mahasiswa'),
              ),
              TextField(
                controller: jurusanController,
                decoration: InputDecoration(labelText: 'Jurusan Mahasiswa'),
              ),
              TextField(
                controller: prodiController,
                decoration: InputDecoration(labelText: 'Fakultas'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await supabase
                    .from('UASsmstr4')
                    .update({
                      'nim': nimController.text,
                      'nama': namaController.text,
                      'jurusan': jurusanController.text,
                      'prodi': prodiController.text
                    })
                    .eq('id', id);
                retrieve();
                controllerClear();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void controllerClear() {
    nimController.clear();
    namaController.clear();
    jurusanController.clear();
    prodiController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Input Data Mahasiswa")),
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            TextField(
              controller: nimController,
              decoration: const InputDecoration(
                label: Text("NIM Mahasiswa"),
              ),
            ),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                label: Text("Nama Mahasiswa"),
              ),
            ),
            TextField(
              controller: jurusanController,
              decoration: const InputDecoration(
                label: Text("Jurusan Mahasiswa"),
              ),
            ),
            TextField(
              controller: prodiController,
              decoration: const InputDecoration(
                label: Text("Fakultas"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: save,
              child: Text("Simpan"),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text('id'),
                      ),
                      DataColumn(
                        label: Text('NIM'),
                      ),
                      DataColumn(
                        label: Text('Nama'),
                      ),
                      DataColumn(
                        label: Text('Jurusan'),
                      ),
                      DataColumn(
                        label: Text('Fakultas'),
                      ),
                      DataColumn(
                        label: Text('Action'),
                      ),
                    ],
                    rows: mahasiswa
                        .map(
                          (e) => DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  e['id'].toString(),
                                ),
                              ),
                              DataCell(
                                Text(
                                  e['nim'].toString(),
                                ),
                              ),
                              DataCell(
                                Text(
                                  e['nama'].toString(),
                                ),
                              ),
                              DataCell(
                                Text(
                                  e['jurusan'].toString(),
                                ),
                              ),
                              DataCell(
                                Text(
                                  e['prodi'].toString(),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        editRow(e['id']);
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteRow(e['id']);
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
