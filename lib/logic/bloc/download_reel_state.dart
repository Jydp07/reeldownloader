part of 'download_reel_bloc.dart';

abstract class DownloadReelState {}

class DownloadReelInitial extends DownloadReelState {}

class DownloadReelStartState extends DownloadReelState {}

class DownloadReelSuccessState extends DownloadReelState {
  final String? message;

  DownloadReelSuccessState({this.message});
}

class DownloadReelErrorState extends DownloadReelState {
  final String? error;

  DownloadReelErrorState({required this.error});
}
