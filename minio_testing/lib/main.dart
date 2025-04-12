import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera to MinIO',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const CameraStorageApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CameraStorageApp extends StatefulWidget {
  const CameraStorageApp({super.key});
  @override
  State<CameraStorageApp> createState() => _CameraStorageAppState();
}

class _CameraStorageAppState extends State<CameraStorageApp> {
  late CameraController _controller;
  late Directory _imageDir;
  List<File> _images = [];
  Map<String, double> _uploadProgress = {}; // Store progress for each file
  List<String> _uploadedUrls = []; // Store URLs of uploaded images
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _requestPermissions();

    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller.initialize();

    _imageDir = await getApplicationDocumentsDirectory();
    await _loadImages();

    setState(() {
      _isReady = true;
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.storage.request();
  }

  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized) return;

    // Set the flash mode to off before taking a picture
    await _controller.setFlashMode(FlashMode.off);

    final image = await _controller.takePicture();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedPath = p.join(_imageDir.path, fileName);

    await File(image.path).copy(savedPath);
    await _loadImages();

    // Optional: Reset the flash mode after taking the picture
    await _controller.setFlashMode(FlashMode.off);
  }

  Future<void> _loadImages() async {
    final files = _imageDir.listSync().whereType<File>().toList();
    files.sort((a, b) => b.path.compareTo(a.path)); // Newest first

    setState(() {
      _images = files.where((f) => f.path.endsWith('.jpg')).toList();
    });
  }

  Future<void> _uploadImagesToMinIO() async {
    final dio = Dio();
    const minioEndpoint = 'https://play.min.io';
    const bucket = 'ahsan.bucket.for.testing.minio/clicking.images';

    // Make a copy of the list to avoid issues while modifying the original during iteration
    final imagesToUpload = List<File>.from(_images);
    List<String> uploadedUrls = [];

    for (var image in imagesToUpload) {
      final fileName = p.basename(image.path);
      final propertyName = "507f1f77bcf86cd799439011";
      final url = '$minioEndpoint/$bucket/$propertyName/$fileName';

      try {
        final file = File(image.path);
        final fileStream = file.openRead();
        final fileLength = await file.length();

        // Initialize progress to 0
        _uploadProgress[fileName] = 0.0;

        final response = await dio.put(
          url,
          data: fileStream,
          options: Options(
            headers: {
              'Content-Length': fileLength,
              'Content-Type': 'image/jpeg',
              'x-amz-acl': 'public-read', // optional, depends on bucket policy
            },
          ),
          onSendProgress: (sent, total) {
            // Update progress
            setState(() {
              _uploadProgress[fileName] = sent / total;
            });
          },
        );

        if (response.statusCode == 200) {
          print("✅ Uploaded $fileName");

          // Add URL to the list
          uploadedUrls.add(url);

          // Delete from local storage
          await file.delete();

          // Remove from GridView
          setState(() {
            _images.remove(image);
            _uploadProgress.remove(fileName); // Clean up progress data
          });
        } else {
          print("⚠️ Failed to upload $fileName: ${response.statusCode}");
        }
      } catch (e) {
        print("❌ Error uploading $fileName: $e");
      }

      // Optional: delay for visual effect
      await Future.delayed(const Duration(milliseconds: 300));
    }

    // Update the list of uploaded URLs in the state
    setState(() {
      _uploadedUrls = uploadedUrls;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Upload complete')),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCameraPreview() {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: CameraPreview(_controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera to MinIO')),
      body: !_isReady
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Camera preview occupies half the screen
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: _buildCameraPreview(),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _takePicture,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Capture"),
                    ),
                    ElevatedButton.icon(
                      onPressed: _uploadImagesToMinIO,
                      icon: const Icon(Icons.cloud_upload),
                      label: const Text("Upload All"),
                    ),
                  ],
                ),
                const Divider(),
                // Expanded GridView for images
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _images.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      final image = _images[index];
                      final fileName = p.basename(image.path);
                      final progress = _uploadProgress[fileName] ?? 0.0;

                      return Card(
                        child: Stack(
                          children: [
                            Image.file(
                              image,
                              fit: BoxFit.cover,
                            ),
                            if (_uploadProgress.containsKey(fileName))
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.grey[300],
                                  color: Colors.blue,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                // Scrollable list of uploaded URLs at the bottom
                if (_uploadedUrls.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Uploaded Image URLs:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ..._uploadedUrls.map((url) => Text(url)).toList(),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
