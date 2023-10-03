part of 'download_reel_bloc.dart';

abstract class DownloadReelEvent{}

class OnDownloadReelEvent extends DownloadReelEvent{
  final String? link;

  OnDownloadReelEvent({required this.link});
}

class RequestPermission extends DownloadReelEvent{}
