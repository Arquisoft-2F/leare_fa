import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

class ResourceCard extends StatelessWidget {
  final String resourceName;
  final String resourceUrl;

  const ResourceCard({
    Key? key,
    required this.resourceName,
    required this.resourceUrl,
  }) : super(key: key);

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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  resourceName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _downloadFile(context);
                  },
                  child: const Icon(Icons.file_download),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _downloadFile(BuildContext context) async {
    try {
      var appdir;
      if (Platform.isAndroid){
          appdir = "/storage/emulated/0/Download/";
      }
      else{
          appdir = (await getApplicationDocumentsDirectory()).path;
      }

      final taskId = await FlutterDownloader.enqueue(
        url: resourceUrl,
        savedDir: appdir, // Cambia esto al directorio deseado
        showNotification: true, // Muestra notificación al completar la descarga
        openFileFromNotification: true, // Abre el archivo al hacer clic en la notificación
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Descargando $resourceName...'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al descargar $resourceName: $e'),
        ),
      );
    }
  }
}