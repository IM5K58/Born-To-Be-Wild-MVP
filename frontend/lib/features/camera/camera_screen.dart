import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../mission/mission_model.dart';
import '../attempt/attempt_repository.dart';
import '../home/home_provider.dart';

class CameraScreen extends ConsumerStatefulWidget {
  final Mission? mission;
  const CameraScreen({super.key, this.mission});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  XFile? _pickedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() => _pickedFile = image);
      }
    } catch (e) {
      // 카메라 사용 불가 시 갤러리로 폴백
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() => _pickedFile = image);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(submitAttemptProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        ref.read(submitAttemptProvider.notifier).reset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('인증 제출 완료! 판정 결과를 기다려주세요 🔍')),
        );
        ref.refresh(homeDataProvider);
        context.go('/');
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('업로드 실패: ${next.error}')),
        );
      }
    });

    final isSubmitting = ref.watch(submitAttemptProvider).isLoading;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('미션 인증', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. 이미지 미리보기 또는 안내
          if (_pickedFile != null)
            Image.network(_pickedFile!.path, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.image, size: 100, color: Colors.white54),
              ),
            )
          else
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 80, color: Colors.white54),
                  SizedBox(height: 16),
                  Text(
                    '아래 버튼을 눌러 인증 사진을 찍어주세요',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

          // 2. 미션 오버레이
          if (widget.mission != null)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.black54,
                child: Column(
                  children: [
                    const Text('🎯 오늘의 미션', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      widget.mission!.overlayText,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '인증 코드: ${widget.mission!.codeword}',
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

          // 3. 하단 버튼
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_pickedFile == null) ...[
                  Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'take_photo',
                        backgroundColor: Colors.red,
                        onPressed: _pickImage,
                        child: const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text('사진 찍기', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ] else ...[
                  Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'retake',
                        backgroundColor: Colors.grey,
                        onPressed: isSubmitting ? null : () => setState(() => _pickedFile = null),
                        child: const Icon(Icons.refresh, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text('다시 찍기', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'submit',
                        backgroundColor: Colors.green,
                        onPressed: isSubmitting ? null : _submitProof,
                        child: isSubmitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.check, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isSubmitting ? '제출 중...' : '인증 제출',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitProof() {
    if (_pickedFile == null || widget.mission == null) return;

    ref.read(submitAttemptProvider.notifier).submitXFile(
      challengeId: widget.mission!.challengeId,
      missionId: widget.mission!.id,
      file: _pickedFile!,
    );
  }
}
