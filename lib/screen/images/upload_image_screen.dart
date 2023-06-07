import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vp18_firebase/bloc/bloc/images_bloc.dart';
import 'package:vp18_firebase/bloc/events/image_event.dart';
import 'package:vp18_firebase/bloc/states/image_state.dart';
import 'package:vp18_firebase/utils/context_extension.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  late ImagePicker _imagePicker;
  XFile? _pickedImage;
  double? _progressValue = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload Image",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: BlocListener<ImagesBloc, ImageState>(
        listenWhen: (previous, current) =>
            current is ImageProcessState &&
            current.processType == ProcessType.upload,
        listener: (context, state) {
          state as ImageProcessState;
          context.showSnackBar(
            message: state.message,
            erorr: !state.success,
          );
          if (state.success) _clear();
          _updateProgressValue(state.success ? 1 : 0);
        },
        child: Column(
          children: [
            LinearProgressIndicator(
              minHeight: 1.h,
              backgroundColor: const Color(0XFF6A90F2),
              color: Colors.red.shade400,
              value: _progressValue,
            ),
            Expanded(
              child: _pickedImage != null
                  ? Image.file(File(_pickedImage!.path))
                  : IconButton(
                      onPressed: () => _pickImage(),
                      icon: const Icon(Icons.camera),
                      iconSize: 70,
                    ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                _performSave();
                Future.delayed(const Duration(seconds: 3), () {
                  Navigator.pushReplacementNamed(context, "/images_screen");
                });
              },
              icon: const Icon(Icons.cloud_upload),
              label: const Text("UPLOAD"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF6A90F2),
                minimumSize: Size(double.infinity, 50.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    XFile? imageFile = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 100);
    if (imageFile != null) {
      setState(() => _pickedImage = imageFile);
    }
  }

  void _performSave() {
    if (checkData()) {
      _save();
    }
  }

  bool checkData() {
    if (_pickedImage != null) {
      return true;
    }
    context.showSnackBar(message: "Pick Image to upload", erorr: true);
    return false;
  }

  void _save() async {
    _updateProgressValue();
    BlocProvider.of<ImagesBloc>(context).add(
      UploadImageEvent(_pickedImage!.path),
    );
    // setState(() => _pickedImage = null);
  }

  void _updateProgressValue([double? value]) {
    setState(() => _progressValue = value);
  }

  void _clear() {
    setState(() => _pickedImage = null);
  }
}
