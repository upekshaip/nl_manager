import 'package:flutter/material.dart';
import 'package:nlmanager/components/my_loading.dart';
import 'package:nlmanager/components/primary_btn.dart';
import 'package:nlmanager/tasks/course_state.dart';
import 'package:nlmanager/tasks/downloader_state.dart';
import 'package:nlmanager/tasks/helpers.dart';
import 'package:nlmanager/tasks/session_state.dart';
import 'package:provider/provider.dart';

class DownloaderPage extends StatelessWidget {
  const DownloaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<SessionStateProvider, CourseStateProvider, DownloadStateProvider>(
      builder: (context, mySession, myCourse, myDownloader, child) => Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.black,
            title: const Text(
              'Downloader',
              style: TextStyle(color: Colors.white),
            ),
            // automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                  onPressed: () {
                    myDownloader.getMissingFiles(mySession, myCourse);
                  },
                  color: Colors.white,
                ),
              ),
            ]),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (myDownloader.problems && !myDownloader.isProcessing)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Some files did not download properly. After download completed refresh again to see what's missing..",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              if (myCourse.isLoading) MyLoading(message: "Scanning NL Files"),
              if (!myCourse.isLoading && myDownloader.needsToDownload.isEmpty)
                Column(children: [
                  Center(
                    child: Text("Refresh to see missing files... "),
                  ),
                ]),
              if (!myCourse.isLoading && myDownloader.needsToDownload.isNotEmpty)
                Expanded(
                  // <-- Wrap this entire section in Expanded
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(children: [
                          if (!myDownloader.isProcessing && !myDownloader.isDownloading)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total missing file count: ${myDownloader.needsToDownload.length}",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Do you want to download them now?",
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                PrimaryBtn(
                                  onTap: () {
                                    myDownloader.startDownload(mySession);
                                  },
                                  text: "Download",
                                ),
                              ],
                            ),
                          if (myDownloader.isDownloading && !myDownloader.isProcessing)
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text("Total File Count: ${myDownloader.needsToDownload.length}"),
                              Text("Downloaded File Count: ${myDownloader.downloaded.length}"),
                              Text("File name: ${myDownloader.downloadingFileName}"),
                              Text("Path: ${myDownloader.downloadingFilePath}"),
                              const SizedBox(height: 8),
                              Text("File Size: ${MyHelper().formatBytes(myDownloader.downloadingFileSize)}"),
                              // Text("Downloaded: ${MyHelper().formatBytes(myDownloader.downloadingFileDownloaded)}"),

                              // progress bars
                              const SizedBox(height: 20),
                              Text("File Chunk Progress"),
                              Row(children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: myDownloader.currentProgress ?? 0,
                                    backgroundColor: Colors.grey.shade700,
                                    color: const Color.fromARGB(255, 0, 199, 10),
                                  ),
                                ),
                                // not accurate
                                // Text("${(myDownloader.currentProgress * 100).toStringAsFixed(2)}%"),
                              ]),
                              const SizedBox(width: 8),
                              Text("Total Progress"),
                              Row(children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: myDownloader.totalProgress ?? 0,
                                    backgroundColor: Colors.grey.shade700,
                                    color: const Color.fromARGB(255, 0, 199, 10),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text("${(myDownloader.totalProgress * 100).toStringAsFixed(2)}%"),
                              ]),
                              // PrimaryBtn(
                              //   onTap: () {
                              //     myDownloader.cancelDownload();
                              //   },
                              //   text: "Cancel",
                              // ),
                            ]),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        // <-- This ensures the list takes up remaining space
                        child: ListView.builder(
                          itemCount: myDownloader.needsToDownload.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                myDownloader.needsToDownload[index]["file_name"],
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                myDownloader.needsToDownload[index]["path"].toString().split('/').first,
                                style: TextStyle(color: Colors.grey),
                              ),
                              trailing: MyHelper().getIcons(myDownloader.needsToDownload[index]["ext"], myDownloader.needsToDownload[index]["image"]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
