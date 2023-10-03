import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reeldownloader/logic/bloc/download_reel_bloc.dart';

class ReelScreen extends StatelessWidget {
  const ReelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DownloadReelBloc>(
      create: (context) => DownloadReelBloc()..add(RequestPermission()),
      child: _ReelScreen(),
    );
  }
}

class _ReelScreen extends StatelessWidget {
  _ReelScreen();

  final reelControler = TextEditingController();

  void _copy(context) {
    Clipboard.setData(ClipboardData(text: reelControler.text)).then((value) =>
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Copied to the Clipboard"))));
    FocusScope.of(context).unfocus();
  }

  Future<void> _paste() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      reelControler.text = data.text!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/img/instagram.png',
              height: 30,
              width: 30,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text('ReelDownloader')
          ],
        ),
        backgroundColor: Colors.black54,
      ),
      body: Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: reelControler,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          hintText: "Paste url here!",
                          hintStyle: const TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.copy,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _copy(context);
                            },
                          )),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: _paste,
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.teal),
                                shadowColor:
                                    MaterialStatePropertyAll(Colors.black),
                              ),
                              child: const Text(
                                "Paste link",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child:
                              BlocBuilder<DownloadReelBloc, DownloadReelState>(
                            builder: (context, state) {
                              return SizedBox(
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<DownloadReelBloc>(context)
                                        .add(OnDownloadReelEvent(
                                            link: reelControler.text));
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color.fromARGB(255, 202, 19, 6)),
                                    shadowColor:
                                        MaterialStatePropertyAll(Colors.black),
                                  ),
                                  child: BlocBuilder<DownloadReelBloc,
                                      DownloadReelState>(
                                    builder: (context, state) {
                                      if (state is DownloadReelStartState) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                          ),
                                        );
                                      }
                                      if (state is DownloadReelSuccessState) {
                                        return const Center(
                                          child: Text("Download Reel",
                                              style: TextStyle(fontSize: 16)),
                                        );
                                      }
                                      return const Center(
                                        child: Text(
                                          "Download Reel",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<DownloadReelBloc, DownloadReelState>(
                    builder: (context, state) {
                      if (state is DownloadReelErrorState) {
                        return Text(
                          state.error!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                          softWrap: true,
                        );
                      }
                      if (state is DownloadReelStartState) {
                        return const Text("Downloading...",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                            softWrap: true);
                      }
                      if(state is DownloadReelSuccessState){
                        if(state.message != null){
                          return Text(state.message!,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                            softWrap: true);
                        }
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Get Your Reels On Phone",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "T&C applied",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
