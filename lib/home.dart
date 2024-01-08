import 'dart:io';

import 'package:base_contact/ajouter.dart';
import 'package:base_contact/constants.dart';
import 'package:base_contact/nous.dart';
import 'package:base_contact/vue.dart';
import 'package:flutter/material.dart';

import 'database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  String _monthByInt(int month) {
    String mois;
    switch (month) {
      case 1:
        mois = 'Jan';
        break;
      case 2:
        mois = 'Fév';
        break;
      case 3:
        mois = 'Mar';
        break;
      case 4:
        mois = 'Avr';
        break;
      case 5:
        mois = 'Mai';
        break;
      case 6:
        mois = 'Jun';
        break;
      case 7:
        mois = 'Jui';
        break;
      case 8:
        mois = 'Aoû';
        break;
      case 9:
        mois = 'Sep';
        break;
      case 10:
        mois = 'Oct';
        break;
      case 11:
        mois = 'Nov';
        break;
      default:
        mois = 'Dec';
        break;
    }
    return mois;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primColor,
        toolbarHeight: 80,
        foregroundColor: secColor,
        title: Text(
          'Percide Daily',
          style: stylish(30, secColor),
        ),
        actions: [
          PopupMenuButton(
            tooltip: 'Plus',
            icon: const Icon(
              Icons.more_vert,
              size: 30,
            ),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                  child: Row(
                children: [
                  const Icon(Icons.add, color: primColor,size: 25,),
                  const SizedBox(width: 5,),
                  Text('Nouvel Ajout', style: stylish(18, primColor),),
                ],
              ),
                onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Ajouter()));
                },
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    const Icon(Icons.people, color: primColor,size: 25,),
                    const SizedBox(width: 5,),
                    Text('A Propos de nous', style: stylish(18, primColor),),
                  ],
                ),
                onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const APropos()));
                },
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: primColor,size: 25,),
                    const SizedBox(width: 5,),
                    Text('Quitter', style: stylish(18, primColor),),
                  ],
                ),
                onTap: (){
                  exit(0);
                },
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {});
        },
        child: FutureBuilder<List<Note>>(
          future: dbHelper.getAllNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty-box.png',
                      width: 80,
                    ),
                    Text(
                      'Aucune note !',
                      style: stylish(20, primColor),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length * 2 - 1,
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  return const Divider(); // Divider entre les éléments
                }

                final noteIndex = index ~/ 2;
                Note note = snapshot.data![noteIndex];
                DateTime dateTime = DateTime.parse(note.date);

                return ListTile(
                  minLeadingWidth: 50,
                  tileColor: Colors.black12,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  leading: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: blanc,
                      border: Border.all(color: primColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(dateTime.day.toString(),
                            style: stylish(20, primColor)),
                        const Divider(color: primColor, height: 1),
                        Text(_monthByInt(dateTime.month),
                            style: stylish(15, primColor)),
                      ],
                    ),
                  ),
                  trailing: InkWell(
                    onTap: () async {
                      await dbHelper.deleteNote(note.id!);
                      setState(() {});
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(Icons.delete_forever, color: rouge),
                    ),
                  ),
                  title: InkWell(
                    onTap: () {
                      final Note not = Note.fromMap(note.toMap());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VuePage(note: not)));
                    },
                    child: Text(
                      note.title?.toUpperCase() ?? '(Sans titre)'.toUpperCase(),
                      style: stylish(20, primColor),
                    ),
                  ),
                  subtitle: InkWell(
                    onTap: () {
                      final Note not = Note.fromMap(note.toMap());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VuePage(note: not)));
                    },
                    child: Text(
                      note.content != null
                          ? (note.content!.length > 15
                              ? '${note.content!.substring(0, 20)}...'
                              : note.content!)
                          : '(Sans contenu)',
                      style: stylish(18, Colors.black),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Ajouter()));
          },
          elevation: 8.0,
          tooltip: 'Nouvel ajout',
          backgroundColor: primColor,
          foregroundColor: secColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
