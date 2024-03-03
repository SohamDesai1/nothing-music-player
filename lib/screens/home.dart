// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    _hasPermission ? setState(() {}) : null;
  }

  getSongs() {
    var songs = _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    return songs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("N Music Player"),
        elevation: 2,
      ),
      body: Center(
        child: !_hasPermission
            ? Column(
                children: [
                  const Text("No permission "),
                  TextButton(
                      onPressed: () => checkAndRequestPermissions(),
                      child: const Text("Give permission"))
                ],
              )
            : FutureBuilder<List<SongModel>>(
                // Default values:
                future: getSongs(),
                builder: (context, item) {
                  if (item.hasError) {
                    return Text(item.error.toString());
                  }

                  if (item.data == null) {
                    return const CircularProgressIndicator();
                  }
                  if (item.data!.isEmpty) return const Text("Nothing found!");

                  return ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(item.data![index].title),
                        subtitle: Text(item.data![index].artist ?? "No Artist"),
                        trailing: IconButton(
                            icon: const Icon(Icons.more_vert_outlined),
                            onPressed: () {}),
                        leading: QueryArtworkWidget(
                          controller: _audioQuery,
                          id: item.data![index].id,
                          type: ArtworkType.AUDIO,
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
