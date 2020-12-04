import 'dart:async';
import 'dart:convert';
import 'dart:math';
import '../models/Notes.dart';
import '../i18n/strings.g.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AppStateManager.dart';
import '../providers/NotesProvider.dart';
import 'package:zefyr/zefyr.dart';

class NoteEditorScreen extends StatefulWidget {
  static const routeName = "/noteditor";
  const NoteEditorScreen({Key key, this.notes}) : super(key: key);
  final Notes notes;

  @override
  _FullPageEditorScreenState createState() => _FullPageEditorScreenState();
}

class _FullPageEditorScreenState extends State<NoteEditorScreen> {
  ZefyrController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _editing = true;
  StreamSubscription<NotusChange> _sub;

  void saveNoteDialog(BuildContext _context) {
    String name = widget.notes == null ? "" : widget.notes.title;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              t.savenotetitle,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  t.cancel,
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  t.ok,
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  if (name != "") {
                    if (widget.notes != null) {
                      Provider.of<NotesProvider>(context, listen: false)
                          .saveNote(
                        new Notes(
                          title: name,
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          content: jsonEncode(_controller.document),
                          date: widget.notes.date,
                          id: widget.notes.id,
                        ),
                      );
                    } else {
                      Provider.of<NotesProvider>(context, listen: false)
                          .saveNote(
                        new Notes(
                            title: name,
                            color: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                            content: jsonEncode(_controller.document),
                            date: DateTime.now().millisecondsSinceEpoch),
                      );
                    }
                    // Navigator.pop(context);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
            content: TextField(
              controller: TextEditingController(
                  text: widget.notes == null ? "" : widget.notes.title),
              autofocus: true,
              onChanged: (text) {
                name = text;
              },
              // cursorColor: Colors.black,
            ),
          );
        }).then((val) {
      if (widget.notes == null) {
        Navigator.pop(_context);
      } else {
        setState(() {
          _editing = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.notes != null) {
      _editing = false;
    }
    if (widget.notes != null) {
      _controller = ZefyrController(
          NotusDocument.fromJson(jsonDecode(widget.notes.content)));
    } else {
      _controller = ZefyrController(NotusDocument());
    }

    _sub = _controller.document.changes.listen((change) {
      print('${change.source}: ${change.change}');
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<AppStateManager>(context, listen: false).preferredTheme);
    final done = _editing
        ? IconButton(onPressed: _stopEditing, icon: Icon(Icons.save))
        : IconButton(onPressed: _startEditing, icon: Icon(Icons.edit));
    final result = Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.pink[500],
        textTheme: Provider.of<AppStateManager>(context, listen: false)
            .themeData
            .textTheme,
        iconTheme: Provider.of<AppStateManager>(context, listen: false)
            .themeData
            .iconTheme
            .copyWith(color: Colors.white),
        title: Text(widget.notes == null ? t.notes : widget.notes.title),
        actions: [
          done,
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(15),
          controller: _controller,
          focusNode: _focusNode,
          mode: _editing ? ZefyrMode.edit : ZefyrMode.select,
          //imageDelegate: CustomImageDelegate(),
          keyboardAppearance:
              Provider.of<AppStateManager>(context, listen: false)
                          .preferredTheme ==
                      1
                  ? Brightness.dark
                  : Brightness.light,
        ),
      ),
    );
    if (Provider.of<AppStateManager>(context, listen: false).preferredTheme ==
        1) {
      return Theme(data: ThemeData.dark(), child: result);
    }
    return Theme(
        data: ThemeData(primarySwatch: Colors.cyan).copyWith(
          brightness: ThemeData.dark().brightness,
        ),
        child: result);
  }

  void _startEditing() {
    setState(() {
      _editing = true;
    });
  }

  void _stopEditing() {
    saveNoteDialog(context);
  }
}
