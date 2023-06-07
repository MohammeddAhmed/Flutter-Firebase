import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp18_firebase/firebase/fb_firestroe_controller.dart';
import 'package:vp18_firebase/models/note.dart';
import 'package:vp18_firebase/models/process_response.dart';
import 'package:vp18_firebase/utils/context_extension.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key, this.note}) : super(key: key);

  final Note? note;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController _titleTextController;
  late TextEditingController _infoTextController;

  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController(text: widget.note?.name);
    _infoTextController = TextEditingController(text: widget.note?.info);
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _infoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Note",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 30, top: 30, end: 30),
        child: Column(
          children: [
            TextField(
              controller: _titleTextController,
              maxLines: 1,
              style: GoogleFonts.roboto(
                fontSize: 20.sp,
                fontWeight: FontWeight.w300,
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.send,
              cursorColor: Colors.black,
              cursorHeight: 30.h,
              cursorWidth: 1.w,
              decoration: InputDecoration(
                hintText: "Title Note",
                prefixIcon: const Icon(
                  Icons.title,
                  color: Colors.black87,
                ),
                hintMaxLines: 1,
                hintStyle: GoogleFonts.roboto(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w300,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 25.h),
            TextField(
              controller: _infoTextController,
              maxLines: 1,
              style: GoogleFonts.roboto(
                fontSize: 20.sp,
                fontWeight: FontWeight.w300,
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.send,
              cursorColor: Colors.black,
              cursorHeight: 30.h,
              cursorWidth: 1.w,
              decoration: InputDecoration(
                hintText: "info Note",
                prefixIcon: const Icon(
                  Icons.info,
                  color: Colors.black87,
                ),
                hintMaxLines: 1,
                hintStyle: GoogleFonts.roboto(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w300,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () {
                _performSave();
                Future.delayed(
                  const Duration(seconds: 2), () {
                    Navigator.pushReplacementNamed(context, "/home_screen");
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF6A90F2),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: GoogleFonts.roboto(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
                minimumSize: const Size(double.infinity, 53),
              ),
              child: const Text(
                "SAVE",
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get isNewNote => widget.note == null;

  void _performSave() {
    if (_checkData()) {
      _save();
    }
  }

  bool _checkData() {
    if (_titleTextController.text.isNotEmpty &&
        _infoTextController.text.isNotEmpty) {
      return true;
    }
    context.showSnackBar(message: "Enter Required data", erorr: true);
    return false;
  }

  void _save() async {
    ProcessResponse processResponse = isNewNote
        ? await FbFireStoreController().create(note)
        : await FbFireStoreController().update(note);
    if (processResponse.success) {
      isNewNote ? _clear() : Navigator.pop(context);
    }
    context.showSnackBar(
      message: processResponse.massage,
      erorr: !processResponse.success,
    );
  }

  Note get note {
    Note note = isNewNote ? Note() : widget.note!;
    note.name = _titleTextController.text;
    note.info = _infoTextController.text;
    return note;
  }

  void _clear() {
    _titleTextController.clear();
    _infoTextController.clear();
  }
}
