import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_insta/flutter_insta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'download_reel_event.dart';
part 'download_reel_state.dart';

class DownloadReelBloc extends Bloc<DownloadReelEvent, DownloadReelState> {
  DownloadReelBloc() : super(DownloadReelInitial()) {
    on<OnDownloadReelEvent>((event, emit) async {
      try {
        emit(DownloadReelStartState());
        FlutterInsta flutterInsta = FlutterInsta();
        var url = await flutterInsta.downloadReels(event.link!);
        await FlutterDownloader.enqueue(
            url: url,
            savedDir: "/storage/emulated/0/Download/",
            showNotification: true,
            allowCellular: true,
            openFileFromNotification: true,
            fileName:
                "${DateTime.now().millisecondsSinceEpoch.toString()}.mp4");
        emit(DownloadReelSuccessState());
      } catch (ex) {
        if (ex.toString() ==
            "RangeError (index): Invalid value: Only valid value is 0: 2") {
          emit(DownloadReelErrorState(error: "Enter Valid URL"));
          return;
        }
        if (ex.toString() == "Failed host lookup: 'www.instagram.com'") {
          emit(DownloadReelErrorState(error: "Network Error"));
          return;
        }
        emit(DownloadReelErrorState(error: ex.toString()));
      }
    });
    on<RequestPermission>((event, emit) async {
      try {
        WidgetsFlutterBinding.ensureInitialized();
        await FlutterDownloader.initialize(
          debug: true,
        );
        PermissionStatus status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          await Permission.storage.request();
          if (status != PermissionStatus.denied) {
            Future.error("Permission Denied");
          }
        }
      } catch (ex) {
        emit(DownloadReelErrorState(error: ex.toString()));
      }
    });
  }
}
