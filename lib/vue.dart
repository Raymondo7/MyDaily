import 'dart:convert';

import 'package:base_contact/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constants.dart';
import 'database.dart';

class VuePage extends StatefulWidget {
  const VuePage({super.key, required this.note});
  final Note note;

  @override
  State<VuePage> createState() => _VuePageState();
}

class _VuePageState extends State<VuePage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime? _selectedDate;
  String? titre;
  String? contenu;
  String? date;

  void _showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 10.0,
        padding: const EdgeInsets.all(10),
        backgroundColor: Colors.red,
        content: Text('Tous les champs sont vides', style: stylish(18, secColor),),
        duration: const Duration(seconds: 3), // Durée d'affichage de la Snackbar
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: primColor,
            hintColor: Colors.blue,
            colorScheme: const ColorScheme.light(primary: primColor),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null && selectedDate != _selectedDate) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> noteData = jsonDecode(widget.note.toString());
    titre = noteData['title'];
    contenu = noteData['content'];
    date = noteData['date'];
    _selectedDate = DateTime.parse(date!);
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    if(titre!= null){
      _titleController.text = titre!;
    }else{
      _titleController.text = '';
    }
    if(contenu!=null){
      _contentController.text = contenu!;
    }else{
      _contentController.text = '';
    }

  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primColor,
        foregroundColor: secColor,
        centerTitle: true,
        title: Text(
          'Modifier',
          style: stylish(30, secColor),
        ),
        actions: [
          IconButton(
              tooltip: 'Enrégistrer',
              onPressed: () async{
                if(_titleController.text.isEmpty  && _contentController.text.isEmpty){
                  _showSnackbar(context);
                }
                else {
                  final date = _selectedDate!.toString();
                  if (_titleController.text.isEmpty) {
                    final content = _contentController.text;
                    Note newNote = Note(date: date, content: content);
                    await dbHelper.updateNote(newNote);
                    setState(() {});
                    Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => const HomePage()),(route) => false,
                    );

                  }
                  if (_contentController.text.isEmpty) {
                    final title = _titleController.text;
                    Note newNote = Note(date: date, title: title);
                    await dbHelper.updateNote(newNote);
                    setState(() {});
                    Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => const HomePage()),(route) => false,
                    );
                  }
                  if (_titleController.text.isNotEmpty &&
                      _contentController.text.isNotEmpty) {
                    final content = _contentController.text;
                    final title = _titleController.text;
                    Note newNote = Note(id: widget.note.id, date: date, title: title, content: content);
                    await dbHelper.updateNote(newNote);
                    setState(() {});
                    Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => const HomePage()),(route) => false,
                    );
                  }
                }
              },
              icon: const Icon(
                Icons.save,
                size: 30,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              readOnly: true,
              style: stylish(20, primColor),
              decoration: InputDecoration(
                filled: true,
                suffixIcon: IconButton(
                  onPressed: () async {
                    // Appeler la fonction _selectDate lorsque le champ de texte est tapé
                    await _selectDate(context);

                    // Mettre à jour le texte du champ de texte avec la date sélectionnée
                    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
                  },
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    color: primColor,
                    size: 30,
                  ),
                ),
                hintStyle: stylish(20, Colors.black87),
                hintFadeDuration: const Duration(milliseconds: 300),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: primColor,
                        width: 2,
                        style: BorderStyle.solid)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: primColor,
                        width: 2,
                        style: BorderStyle.solid)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: primColor,
                        width: 1,
                        style: BorderStyle.solid)),
              ),
              controller: _dateController,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              style: stylish(20, primColor),
              maxLength: 25,
              decoration: InputDecoration(
                hintText: 'Titre...',
                filled: true,
                hintStyle: stylish(20, Colors.black87),
                hintFadeDuration: const Duration(milliseconds: 300),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: primColor,
                        width: 2,
                        style: BorderStyle.solid)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: primColor,
                        width: 2,
                        style: BorderStyle.solid)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: primColor,
                        width: 1,
                        style: BorderStyle.solid)),
              ),
              controller: _titleController,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: TextFormField(
                style: stylish(20, primColor),
                autocorrect: true,
                maxLines: 50,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Contenu...',
                  hintStyle: stylish(20, Colors.black87),
                  hintFadeDuration: const Duration(milliseconds: 300),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: primColor,
                          width: 2,
                          style: BorderStyle.solid)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: primColor,
                          width: 2,
                          style: BorderStyle.solid)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: primColor,
                          width: 1,
                          style: BorderStyle.solid)),
                ),
                controller: _contentController,
              ),
            ),
          ],
        ),
      )
    );
  }
}
