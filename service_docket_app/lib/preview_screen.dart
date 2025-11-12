import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:camera/camera.dart';

class PreviewScreen extends StatefulWidget {
  final String imagePath;
  final XFile? imageFile;
  final String category;
  final String filename;

  const PreviewScreen({
    super.key,
    required this.imagePath,
    this.imageFile,
    required this.category,
    required this.filename,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  // Alternative upload method using multipart form (bypasses CORS better)
  Future<String> _uploadWithMultipart(Uint8List bytes, String filename) async {
    try {
      print('Using multipart upload to bypass CORS...');
      
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('dockets/$filename');
      
      // Try direct putData first with better error handling
      final uploadTask = storageRef.putData(
        bytes,
        SettableMetadata(
          contentType: 'image/jpeg',
          cacheControl: 'public, max-age=300',
          customMetadata: {'uploadMethod': 'web-workaround'},
        ),
      );
      
      // Listen to upload progress
      await for (final snapshot in uploadTask.snapshotEvents) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
        if (mounted) {
          setState(() {
            _uploadProgress = progress;
          });
        }
        
        if (snapshot.state == TaskState.success) {
          print('Upload completed!');
          break;
        } else if (snapshot.state == TaskState.error) {
          throw Exception('Upload failed: ${snapshot.state}');
        }
      }
      
      final downloadUrl = await storageRef.getDownloadURL();
      print('Download URL obtained: $downloadUrl');
      return downloadUrl;
      
    } catch (e) {
      print('Multipart upload error: $e');
      rethrow;
    }
  }

  Future<dynamic> _compressImage(String imagePath) async {
    if (kIsWeb) {
      // On web, return the path directly (compression handled differently)
      return imagePath;
    } else {
      // On mobile/desktop, compress the file
      final file = File(imagePath);
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        'compressed_${path.basename(file.path)}',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 70,
        minWidth: 1920,
        minHeight: 1080,
      );

      if (result == null) {
        throw Exception('Image compression failed');
      }

      return File(result.path);
    }
  }

  Future<void> _uploadToFirebase() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      // Compress the image
      final compressed = await _compressImage(widget.imagePath);
      
      // Get file sizes
      int originalSize;
      int compressedSize;
      
      if (kIsWeb) {
        // On web, we can't easily get file sizes, use placeholder
        originalSize = 0;
        compressedSize = 0;
      } else {
        final compressedFile = compressed as File;
        originalSize = await File(widget.imagePath).length();
        compressedSize = await compressedFile.length();
      }
      
      final compressionRatio = originalSize > 0 
          ? ((originalSize - compressedSize) / originalSize * 100).toStringAsFixed(1)
          : '0';

      // Upload to Firebase Storage
      print('Starting upload to Firebase...');
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('dockets/${widget.filename}');

      String downloadUrl;
      
      if (kIsWeb && widget.imageFile != null) {
        // On web, use the special multipart method
        print('Reading image bytes for web upload...');
        final Uint8List bytes = await widget.imageFile!.readAsBytes();
        print('Image bytes read: ${bytes.length} bytes');
        
        // Use our custom upload method that handles CORS better
        downloadUrl = await _uploadWithMultipart(bytes, widget.filename);
        
      } else {
        // On mobile/desktop, upload file normally
        final compressedFile = compressed as File;
        print('Uploading file from path: ${compressedFile.path}');
        
        final uploadTask = storageRef.putFile(compressedFile);
        
        // Listen to upload progress
        uploadTask.snapshotEvents.listen((snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          print('Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
          setState(() {
            _uploadProgress = progress;
          });
        });

        final snapshot = await uploadTask;
        print('Upload completed successfully!');
        
        downloadUrl = await snapshot.ref.getDownloadURL();
        print('Download URL obtained: $downloadUrl');
      }

      // Save metadata to Firestore
      print('Saving to Firestore...');
      await FirebaseFirestore.instance.collection('dockets').add({
        'filename': widget.filename,
        'category': widget.category,
        'imageUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'originalSize': originalSize,
        'compressedSize': compressedSize,
        'compressionRatio': '$compressionRatio%',
        'uploadedAt': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload successful! Saved $compressionRatio% space'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e, stackTrace) {
      print('Upload error: $e');
      print('Stack trace: $stackTrace');
      
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Preview'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: kIsWeb
                  ? Image.network(
                      widget.imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 64,
                        );
                      },
                    )
                  : Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          Container(
            color: Colors.black87,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // File info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category: ${widget.category}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Filename: ${widget.filename}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Upload progress
                if (_isUploading) ...[
                  LinearProgressIndicator(
                    value: _uploadProgress,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Uploading... ${(_uploadProgress * 100).toInt()}%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isUploading ? null : () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        label: const Text('Retake'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isUploading ? null : _uploadToFirebase,
                        icon: _isUploading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.cloud_upload),
                        label: Text(_isUploading ? 'Uploading...' : 'Upload'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}