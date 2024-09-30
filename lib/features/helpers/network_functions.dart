// File for functions that require network usage (?)
import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:dio/dio.dart';
import 'package:hyper_thread_downloader/hyper_thread_downloader.dart';

import 'file_functions.dart';

/// Function to create a path to the file, check if file exists and is the same, and download, if not;
/// 
/// Arguments: path as a string, fileName as a string, uri as a string to download the file, uriHash as a string and is optional to check if the file is the same
Future<void> getFile(String path, String fileName, String uri, [String? uriHash]) async{
  final dio = Dio();
  int count = 0, maxTries = 3;
  try {
    // Create path to the file
    await Directory(path).create(recursive: true);
    // If there is uriHash then check. If there isn't - download
    if (uriHash != null) {
      // Get SHA1 of a file if it exists
      String fileHash = await getSHA1(path, fileName);
      // If hash of existing file isn't the same as it should be - redownload
      if (fileHash != uriHash) {
        await dio.download(uri, '$path/$fileName', onReceiveProgress: (count, total) => print('$count $total $fileName'));
      }
    }
    else {
      await dio.download(uri, '$path/$fileName', onReceiveProgress: (count, total) => print('$count $total $fileName'));
    }
  } catch (e) {
    if (++count >= maxTries) {throw Exception(e);}
  }
  print('Downloaded $fileName');
}

/// Function to download ONE file using multiple threads;
/// 
/// Arguments: path as a string, fileName as a string, uri as a string to download the file, uriHash as a string and is optional to check if the file is the same
Future<void> getFileMD(String path, String fileName, String uri, [String? uriHash]) async{
  final md = HyperDownload();
  int count = 0, maxTries = 3;
  int threads = Platform.numberOfProcessors;
  threads -= 2;
  try {
    // Create path to the file
    await Directory(path).create(recursive: true);
    // If there is uriHash then check. If there isn't - download
    if (uriHash != null) {
      // Get SHA1 of a file if it exists
      String fileHash = await getSHA1(path, fileName);
      // If hash of existing file isn't the same as it should be - redownload
      if (fileHash != uriHash) {
        await md.startDownload(
          url: uri, 
          savePath: '$path/$fileName', 
          threadCount: threads, 
          prepareWorking: (bool value) {}, 
          workingMerge: (bool ret) {
            HyperLog.log('working merge: $ret');
          }, 
          downloadProgress: ({
            required double progress,
            required double speed,
            required double remainTime,
            required int count,
            required int total,
          }) {
            HyperLog.log('download progress: $progress, speed: $speed');
          }, 
          downloadComplete: () {
            HyperLog.log('download complete');
          }, 
          downloadFailed: (String reason) {
            HyperLog.log('download failed');
          }, 
          downloadTaskId: (int id) {
            print('start task id: $id');
            // taskId = id;
          }, 
          downloadingLog: (String log) {},
        );
      }
    }
    else {
      await md.startDownload(
          url: uri, 
          savePath: '$path/$fileName', 
          threadCount: threads, 
          prepareWorking: (bool value) {}, 
          workingMerge: (bool ret) {
            HyperLog.log('working merge: $ret');
          }, 
          downloadProgress: ({
            required double progress,
            required double speed,
            required double remainTime,
            required int count,
            required int total,
          }) {
            HyperLog.log('download progress: $progress, speed: $speed');
          }, 
          downloadComplete: () {
            HyperLog.log('download complete');
          }, 
          downloadFailed: (String reason) {
            HyperLog.log('download failed');
          }, 
          downloadTaskId: (int id) {
            print('start task id: $id');
            // taskId = id;
          }, 
          downloadingLog: (String log) {},
        );
    }
  } catch (e) {
    if (++count >= maxTries) {throw Exception(e);}
  }
  print('Downloaded $fileName');
}

Future<void> parallelDownload(List paths, List fileNames, List uris, [List? uriHashes]) async{
  final taskQueue = MemoryTaskQueue();
  taskQueue.maxConcurrent = Platform.numberOfProcessors ~/ 2;
  taskQueue.maxConcurrentByHost = 2;
  FileDownloader().addTaskQueue(taskQueue);
  FileDownloader().updates.listen((update) {
//     switch (update) {
//       case TaskStatusUpdate():
//         // process the TaskStatusUpdate, e.g.
//         switch (update.status) {
//           case TaskStatus.complete:
//             print('Task ${update.task.taskId} success!');
//           
//           case TaskStatus.canceled:
//             print('Download was canceled');
//           
//           case TaskStatus.paused:
//             print('Download was paused');
//             
//           case TaskStatus.enqueued:
//             print('Download was enqueued');
//           
//           default:
//             print('Download not successful');
//         }
// 
//       case TaskProgressUpdate():
//         // process the TaskProgressUpdate, e.g.
//         progressUpdateStream.add(update); // pass on to widget for indicator
//     }
  }); 
  List tasks = List.empty(growable: true);
  // Next, enqueue tasks to kick off background downloads, e.g.
  for (int i = 0; i < paths.length; i++) {
    tasks.add(DownloadTask(
      url: uris[i],
      filename: fileNames[i],
      directory: paths[i],
      updates: Updates.statusAndProgress)
    );
    taskQueue.add(tasks[i]);
  }
  print('Downloaded');
}
