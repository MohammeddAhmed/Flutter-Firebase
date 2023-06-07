import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp18_firebase/bloc/bloc/images_bloc.dart';
import 'package:vp18_firebase/bloc/events/image_event.dart';
import 'package:vp18_firebase/bloc/states/image_state.dart';
import 'package:vp18_firebase/utils/context_extension.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({Key? key}) : super(key: key);

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ImagesBloc>(context).add(
      ReadImageEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Images',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, "/upload_image_screen"),
            icon: const Icon(Icons.camera_alt_outlined),
          ),
        ],
      ),
      body: BlocConsumer<ImagesBloc, ImageState>(
        listenWhen: (previous, current) =>
            current is ImageProcessState &&
            current.processType == ProcessType.delete,
        listener: (context, state) {
          state as ImageProcessState;
          context.showSnackBar(message: state.message, erorr: !state.success);
        },
        buildWhen: (previous, current) =>
            current is LoadingState || current is ReadImageState,
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ReadImageState && state.references.isNotEmpty) {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: state.references.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Stack(
                    children: [
                      FutureBuilder<String>(
                          future: state.references[index].getDownloadURL(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image.network(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              );
                            } else {
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 36,
                                ),
                              );
                            }
                          }),
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Container(
                          padding: const EdgeInsetsDirectional.only(start: 10),
                          height: 40.h,
                          color: Colors.black45,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  state.references[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  BlocProvider.of<ImagesBloc>(context).add(
                                    DeleteImageEvent(index),
                                  );
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                "NO IMAGES!",
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  color: Colors.black,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
