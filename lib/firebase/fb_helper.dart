import 'package:vp18_firebase/models/process_response.dart';

mixin FbHelper {
  ProcessResponse getResponse(String message, [bool isSuccess = true]) =>
      ProcessResponse(message, isSuccess);
}
