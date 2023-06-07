class ImageEvent {}

class UploadImageEvent extends ImageEvent {
  final String path;

  UploadImageEvent(this.path);
}

class ReadImageEvent extends ImageEvent {}

class DeleteImageEvent extends ImageEvent {
  final int index;

  DeleteImageEvent(this.index);
}
