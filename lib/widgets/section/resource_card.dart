import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class ResourceCard extends StatelessWidget {
  final String resourceName;
  final String resourceUrl;
  const ResourceCard(
      {super.key, required this.resourceName, required this.resourceUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffd3e4ff),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          resourceName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              FileDownloader.downloadFile(
                                url: resourceUrl,
                                downloadDestination:
                                    DownloadDestinations.publicDownloads,
                                notificationType: NotificationType.all,
                              );
                            },
                            child: const Icon(Icons.file_download))
                      ]),
                ))));
  }
}
