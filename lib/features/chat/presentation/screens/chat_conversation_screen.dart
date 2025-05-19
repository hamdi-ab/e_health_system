import 'package:audioplayers/audioplayers.dart';
import 'package:e_health_system/core/constants/app_colors.dart';
import 'package:e_health_system/features/chat/data/repositories/conversation_repository.dart';
import 'package:e_health_system/models/file_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_health_system/features/chat/domain/entities/message.dart';
import 'package:e_health_system/features/chat/presentation/blocs/conversation_bloc.dart';
import 'package:e_health_system/features/chat/presentation/blocs/conversation_event.dart';
import 'package:e_health_system/features/chat/presentation/blocs/conversation_state.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ChatConversationScreen extends StatefulWidget {
  final String conversationId; // Passed when navigating to this screen.
  const ChatConversationScreen({super.key, required this.conversationId});

  @override
  _ChatConversationScreenState createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  late ConversationBloc _conversationBloc;
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  late String _recordingPath;
  Duration _recordingDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _conversationBloc = ConversationBloc(
      repository: RepositoryProvider.of<ConversationRepository>(context),
    );
    _conversationBloc.add(LoadConversation(widget.conversationId));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _conversationBloc.close();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // Get temporary directory for recording
        final directory = await getTemporaryDirectory();
        _recordingPath =
            '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        // Start recording
        await _audioRecorder.start(
          // 1. Create config object first
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          // 2. Path comes after config
          path: _recordingPath,
        );
        setState(() {
          _isRecording = true;
          _recordingDuration = Duration.zero;
        });

        // Start duration timer
        _startDurationTimer();
      } else {
        // Request permission if not granted
        final status = await Permission.microphone.request();
        if (status.isGranted) {
          _startRecording();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Microphone permission is required for voice messages')),
          );
        }
      }
    } catch (e) {
      print('Error starting recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting recording: $e')),
      );
    }
  }

  void _startDurationTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording) {
        setState(() {
          _recordingDuration += const Duration(seconds: 1);
        });
        _startDurationTimer();
      }
    });
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        // Create a message with the audio file
        final message = Message(
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
          messageText: null,
          senderId: "user1",
          conversationId: widget.conversationId,
          files: [
            FileModel(
              fileId: DateTime.now().millisecondsSinceEpoch.toString(),
              filePath: path,
              fileType: 'audio',
              fileName: 'voice_message.m4a',
            ),
          ],
        );

        // Send the voice message
        _conversationBloc.add(SendMessageEvent(message));
      }
    } catch (e) {
      print('Error stopping recording: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error stopping recording: $e')),
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _conversationBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 1,
          titleSpacing: 0,
          // Dynamic title: You may extract the patient's name from the conversation data.
          title: BlocBuilder<ConversationBloc, ConversationState>(
            builder: (context, state) {
              String patientName = "Patient Name"; // Fallback
              if (state is ConversationLoaded) {
                // TODO: Extract the patient name from state.conversation.
                patientName = "Patient Name";
              }
              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  patientName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          //   actions: [
          //     IconButton(
          //       icon: const Icon(Icons.call, size: 28, color: Colors.black87),
          //       onPressed: () {},
          //     ),
          //     IconButton(
          //       icon: const Icon(Icons.videocam, size: 28, color: Colors.black87),
          //       onPressed: () {},
          //     ),
          //     IconButton(
          //       icon:
          //           const Icon(Icons.more_vert, size: 28, color: Colors.black87),
          //       onPressed: () {},
          //     ),
          //   ],
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ConversationBloc, ConversationState>(
                builder: (context, state) {
                  print('CURRENT STATE: ${state.runtimeType}');
                  if (state is ConversationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ConversationError) {
                    return Center(child: Text("Error: ${state.error}"));
                  } else if (state is ConversationLoaded) {
                    final conversation = state.conversation;
                    print(
                        'Loaded conversation with ${conversation.messages.length} messages');
                    if (conversation.messages.isEmpty) {
                      return const Center(child: Text("No messages yet"));
                    }

                    // Build normal ListView (not reversed) for more predictable behavior
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16, top: 16),
                      itemCount: conversation.messages.length,
                      itemBuilder: (context, index) {
                        final msg = conversation.messages[index];
                        // Debug message
                        print(
                            'Rendering message: ${msg.messageText} from ${msg.senderId}');

                        // Assume "user1" is the current user.
                        if (msg.senderId == "user1") {
                          return _buildMyMessage(msg);
                        } else {
                          return _buildPatientMessage(msg);
                        }
                      },
                    );
                  }
                  return const Center(child: Text("No conversation available"));
                },
              ),
            ),
            if (_isRecording)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.red.withOpacity(0.1),
                child: Row(
                  children: [
                    const Icon(Icons.mic, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'Recording... ${_formatDuration(_recordingDuration)}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.stop, color: Colors.red),
                      onPressed: _stopRecording,
                    ),
                  ],
                ),
              ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  /// Builds a chat bubble for messages sent by "You" (right aligned).
  Widget _buildMyMessage(Message message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.only(left: 60, top: 6, bottom: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (message.messageText != null)
                  Text(
                    message.messageText!,
                    style: const TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                if (message.files != null && message.files!.isNotEmpty)
                  _buildAudioPlayer(message.files!.first),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a chat bubble for messages sent by the patient (left aligned with avatar).
  Widget _buildPatientMessage(Message message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CircleAvatar(
        //   radius: 24,
        //   backgroundColor: Colors.blue.shade200,
        //   child: const Text(
        //     "P",
        //     style: TextStyle(color: Colors.white, fontSize: 20),
        //   ),
        // ),
        // const SizedBox(width: 12),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.only(right: 60, top: 6, bottom: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.messageText != null)
                  Text(
                    message.messageText!,
                    style: const TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                if (message.files != null && message.files!.isNotEmpty)
                  _buildAudioPlayer(message.files!.first),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAudioPlayer(FileModel audioFile) {
    final audioPlayer = AudioPlayer();
    bool isPlaying = false;
    Duration duration = Duration.zero;
    Duration position = Duration.zero;

    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_arrow,
                  size: 28,
                  color: AppColors.primary,
                ),
                onPressed: () async {
                  if (!isPlaying) {
                    try {
                      // Get audio duration
                      duration = await audioPlayer.getDuration() ?? Duration.zero;
                      
                      // Play audio
                      if (audioFile.filePath != null) {
                        await audioPlayer.play(DeviceFileSource(audioFile.filePath!));
                      } else {
                        // Handle the case where filePath is null
                        print('Error: Audio file path is null');
                      }
                      setInnerState(() => isPlaying = true);

                      // Listen to position changes
                      audioPlayer.onPositionChanged.listen((Duration p) {
                        setInnerState(() => position = p);
                      });

                      // Listen to completion
                      audioPlayer.onPlayerComplete.listen((_) {
                        setInnerState(() {
                          isPlaying = false;
                          position = Duration.zero;
                        });
                      });
                    } catch (e) {
                      print('Error playing audio: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error playing audio: $e')),
                      );
                    }
                  } else {
                    await audioPlayer.pause();
                    setInnerState(() => isPlaying = false);
                  }
                },
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Voice Message'),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatDuration(position)} / ${_formatDuration(duration)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds the message input bar.
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(
            Icons.emoji_emotions,
            size: 32,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 18),
                onSubmitted: (value) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon:
                Icon(Icons.attach_file, size: 32, color: Colors.grey.shade600),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(
              _isRecording ? Icons.stop : Icons.mic,
              size: 32,
              color: _isRecording ? Colors.red : Colors.grey.shade600,
            ),
            onPressed: _isRecording ? _stopRecording : _startRecording,
          ),
          IconButton(
            icon: const Icon(Icons.send, size: 32, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  /// Dispatches a SendMessageEvent with the typed message.
  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      print('Sending message: $text');

      final message = Message(
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
        messageText: text,
        senderId: "user1", // Current user is "user1"
        conversationId: widget.conversationId,
      );

      // Add the message to the bloc
      _conversationBloc.add(SendMessageEvent(message));
      _controller.clear();

      // Scroll to the bottom after sending
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  /// Builds the message input area at the bottom.
  // Widget _buildInputBar() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       border: Border(top: BorderSide(color: Colors.grey.shade300)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black12,
  //           blurRadius: 4,
  //           offset: const Offset(0, -2),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         // Emoji icon
  //         Icon(
  //           Icons.emoji_emotions,
  //           size: 32,
  //           color: Colors.grey.shade600,
  //         ),
  //         const SizedBox(width: 12),
  //         // Text field container
  //         Expanded(
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 16),
  //             decoration: BoxDecoration(
  //               color: Colors.grey.shade100,
  //               borderRadius: BorderRadius.circular(30),
  //             ),
  //             child: const TextField(
  //               decoration: InputDecoration(
  //                 hintText: "Type a message...",
  //                 border: InputBorder.none,
  //               ),
  //               style: TextStyle(fontSize: 18),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         // Attachment icon
  //         Icon(
  //           Icons.attach_file,
  //           size: 32,
  //           color: Colors.grey.shade600,
  //         ),
  //         const SizedBox(width: 12),
  //         // Microphone icon
  //         Icon(
  //           Icons.mic,
  //           size: 32,
  //           color: Colors.grey.shade600,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
