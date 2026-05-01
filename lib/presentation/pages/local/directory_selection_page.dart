import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firefly/presentation/bloc/local/local_music_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firefly/presentation/providers/local_music_provider.dart';
import 'package:firefly/presentation/widgets/cards/local_track_card.dart';
import 'package:firefly/core/utils/provider_wrapper.dart';

class DirectorySelectionPage extends StatefulWidget {
  const DirectorySelectionPage({super.key});

  @override
  State<DirectorySelectionPage> createState() => _DirectorySelectionPageState();
}

class _DirectorySelectionPageState extends State<DirectorySelectionPage> {
  final TextEditingController _pathController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  bool _isScanning = false;
  List<String> _detectedDirectories = [];
  String? _selectedDirectory;

  @override
  void initState() {
    super.initState();
    _detectCommonMusicDirectories();
  }

  @override
  void dispose() {
    _pathController.dispose();
    super.dispose();
  }

  Future<void> _detectCommonMusicDirectories() async {
    // Simulate detection of common music directories
    setState(() {
      _detectedDirectories = [
        '/storage/emulated/0/Music',
        '/storage/emulated/0/Download',
        '~/Music',
      ];
    });
  }

  Future<void> _pickDirectory() async {
    try {
      // On web, show dialog instead of native picker
      if (kIsWeb) {
        _showWebPathDialog();
        return;
      }

      final result = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select Music Folder',
        lockParentWindow: true,
      );

      if (result != null) {
        setState(() {
          _pathController.text = result;
          _selectedDirectory = result;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to select directory: ${e.toString()}';
      });
    }
  }

  void _showWebPathDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Music Folder Path'),
        content: TextField(
          controller: _pathController,
          decoration: const InputDecoration(
            hintText: '/path/to/music',
            labelText: 'Folder Path',
          ),
          onChanged: (value) {
            setState(() {
              _selectedDirectory = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startScan();
            },
            child: const Text('Scan'),
          ),
        ],
      ),
    );
  }

  Future<void> _startScan() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isScanning = true;
        _errorMessage = null;
      });

      // Update provider
      final provider = context.read<LocalMusicProvider>();
      provider.setScanning(true);

      // Dispatch BLoC event
      context.read<LocalMusicBloc>().add(
        ScanLocalMusicEvent(_pathController.text),
      );

      // Simulate scanning progress
      await Future.delayed(const Duration(seconds: 2));
      
      provider.setScanning(false);
      
      // Navigate back to local music page
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Music Folder'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                
                // Title
                Text(
                  'Select your music folder',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFFFFFFFF),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Firefly will scan this folder for your music files',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFB3B3B3),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Detected directories
                if (_detectedDirectories.isNotEmpty)
                  ...[
                    Text(
                      'Detected folders:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        itemCount: _detectedDirectories.length,
                        itemBuilder: (context, index) {
                          final dir = _detectedDirectories[index];
                          final isSelected = _selectedDirectory == dir;
                          
                          return Card(
                            color: isSelected
                                ? const Color(0xFFFFB300).withOpacity(0.2)
                                : const Color(0xFF1E1E1E),
                            child: ListTile(
                              title: Text(
                                dir,
                                style: const TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Radio<String>(
                                value: dir,
                                groupValue: _selectedDirectory,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDirectory = value;
                                    _pathController.text = value!;
                                  });
                                },
                                activeColor: const Color(0xFFFFB300),
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedDirectory = dir;
                                  _pathController.text = dir;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFF2A2A2A)),
                    const SizedBox(height: 16),
                  ],
                
                // Custom path input
                Text(
                  'Or enter a custom path:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Path input field
                TextFormField(
                  controller: _pathController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: kIsWeb ? 'Enter folder path' : 'Folder path',
                    labelStyle: const TextStyle(color: Color(0xFFB3B3B3)),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineBorder(
                      side: const BorderSide(color: Color(0xFF2A2A2A)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineBorder(
                      side: const BorderSide(color: Color(0xFF2A2A2A)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineBorder(
                      side: const BorderSide(color: Color(0xFFFFB300)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.folder_open, color: Color(0xFFB3B3B3)),
                      onPressed: _pickDirectory,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a folder';
                    }
                    return null;
                  },
                ),
                
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Color(0xFFFF5252),
                        fontSize: 14,
                      ),
                    ),
                  ),
                
                const Spacer(),
                
                // Scan button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isScanning ? null : _startScan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB300),
                      foregroundColor: const Color(0xFF121212),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: _isScanning
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF121212)),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Scanning...'),
                            ],
                          )
                        : const Text(
                            'Start Scan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Supported formats info
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Supported formats: MP3, FLAC, WAV, OGG, M4A, AAC, WMA, OPUS',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF666666),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
