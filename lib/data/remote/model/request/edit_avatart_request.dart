import 'dart:io';

class EditAvatarRequest {

  final List<File> fileAvatar;
  final String? path;
  EditAvatarRequest({required this.fileAvatar,this.path});
}