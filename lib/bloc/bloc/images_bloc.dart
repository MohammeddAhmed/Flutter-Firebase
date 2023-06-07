import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vp18_firebase/bloc/events/image_event.dart';
import 'package:vp18_firebase/bloc/states/image_state.dart';
import 'package:vp18_firebase/firebase/fb_storage_controller.dart';
import 'package:vp18_firebase/models/process_response.dart';

class ImagesBloc extends Bloc<ImageEvent, ImageState> {
  ImagesBloc(super.initialState) {
    //on<E extends Event>((E event, emit) => null);
    on<UploadImageEvent>(_uploadImageEvent);
    on<ReadImageEvent>(_readImageEvent);
    on<DeleteImageEvent>(_deleteImageEvent);
  }

  List<Reference> _references = <Reference>[];
  final FbStorageController _controller = FbStorageController();

  void _uploadImageEvent(UploadImageEvent event, Emitter<ImageState> emit) async {
    UploadTask uploadTask = _controller.upload(event.path);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    if (snapshot.state == TaskState.success) {
      _references.add(snapshot.ref);
      emit(
        ImageProcessState("Image Upload Failed!", true, ProcessType.upload),
      );
      emit(ReadImageState(_references));
    } else if (snapshot.state == TaskState.error) {
      emit(
        ImageProcessState(
            "Image Upload Failed!", false, ProcessType.upload),
      );
    }
  }

  void _readImageEvent(ReadImageEvent event, Emitter<ImageState> emit) async {
    _references = await _controller.read();
    emit(ReadImageState(_references),);
  }

  void _deleteImageEvent(
      DeleteImageEvent event, Emitter<ImageState> emit) async {
    ProcessResponse processResponse = await _controller.delete(_references[event.index].fullPath);
    if (processResponse.success) {
      _references.removeAt(event.index);
      emit(ReadImageState(_references));
    }
    emit(
      ImageProcessState(
        processResponse.massage,
        !processResponse.success,
        ProcessType.delete,
      ),
    );
  }
}
