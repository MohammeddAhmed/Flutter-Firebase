import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp18_firebase/firebase/fb_auth_controller.dart';
import 'package:vp18_firebase/firebase/fb_firestroe_controller.dart';
import 'package:vp18_firebase/firebase/fb_notifications.dart';
import 'package:vp18_firebase/models/note.dart';
import 'package:vp18_firebase/models/process_response.dart';
import 'package:vp18_firebase/screen/app/note_screen.dart';
import 'package:vp18_firebase/utils/context_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with FbNotifications{


  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    initializeForegroundNotificationForAndroid();
    manageNotificationAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FbAuthController().singOut();
              Navigator.pushReplacementNamed(context, "/login_screen");
            },
            icon: const Icon(Icons.logout_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoteScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.note_add_outlined,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/images_screen"),
        child: const Icon(Icons.image),
      ),
      body: StreamBuilder<QuerySnapshot<Note>>(
        stream: FbFireStoreController().read(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Note note = snapshot.data!.docs[index].data();
                return ListTile(
                  onTap: () {
                    Note targetNote = note;
                    targetNote.id = snapshot.data!.docs[index].id;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(note: targetNote,),
                      ),
                    );

                  },
                  leading: Icon(
                    Icons.note,
                    color: Colors.blue.shade600,
                  ),
                  title: Text(
                    note.name,
                    style: GoogleFonts.poppins(),
                  ),
                  subtitle: Text(
                    note.info,
                    style: GoogleFonts.poppins(),
                  ),
                  trailing: IconButton(
                    onPressed: () =>
                        _deleteNote(context, snapshot.data!.docs[index].id),
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red.shade500,
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                "NO DATA HERE!",
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _deleteNote(BuildContext context, String id) async {
    ProcessResponse processResponse = await FbFireStoreController().delete(id);
    context.showSnackBar(
      message: processResponse.massage,
      erorr: !processResponse.success,
    );
  }
}
