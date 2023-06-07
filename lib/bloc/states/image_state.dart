import 'package:firebase_storage/firebase_storage.dart';

enum ProcessType { upload, read, delete }

class ImageState {}

class LoadingState extends ImageState {}

class ReadImageState extends ImageState {
  final List<Reference> references;

  ReadImageState(this.references);
}

class ImageProcessState extends ImageState {
  final String message;
  final bool success;
  final ProcessType processType;

  ImageProcessState(this.message, this.success, this.processType);
}
