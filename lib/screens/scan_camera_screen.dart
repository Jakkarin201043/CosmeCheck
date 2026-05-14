import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/ingredient_confirmation_draft.dart';
import '../services/ocr_service.dart';
import '../services/real_ocr_service.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class ScanCameraScreen extends StatefulWidget {
  const ScanCameraScreen({super.key});

  @override
  State<ScanCameraScreen> createState() => _ScanCameraScreenState();
}

class _ScanCameraScreenState extends State<ScanCameraScreen> {
  static const _ocrFailureMessage =
      'เกิดข้อผิดพลาดในการอ่านข้อความ กรุณาลองใหม่อีกครั้ง';
  static const _emptyOcrMessage =
      'ไม่พบข้อความส่วนผสมในภาพ กรุณาลองถ่ายหรือเลือกรูปใหม่';
  static const _cameraPermissionDeniedMessage =
      'ไม่สามารถเปิดกล้องได้ กรุณาอนุญาตการเข้าถึงกล้องในการตั้งค่า';
  static const _cameraCancelledMessage = 'ยกเลิกการถ่ายรูปแล้ว';

  final ImagePicker _imagePicker = ImagePicker();
  final OcrService _ocrService = const RealOcrService();

  bool _isProcessing = false;
  String? _errorMessage;
  String? _noticeMessage;
  String? _lastRawOcrText;
  String? _pendingDebugOcrText;

  Future<void> _pickImageAndAnalyze(ImageSource source) async {
    if (_isProcessing) {
      return;
    }

    setState(() {
      _errorMessage = null;
      _noticeMessage = null;
      _lastRawOcrText = null;
      _pendingDebugOcrText = null;
    });

    XFile? image;
    try {
      image = await _imagePicker.pickImage(source: source);
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }
      setState(
        () => _errorMessage = _isCameraPermissionError(error)
            ? _cameraPermissionDeniedMessage
            : _ocrFailureMessage,
      );
      return;
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _errorMessage = _ocrFailureMessage);
      return;
    }

    if (image == null || !mounted) {
      if (mounted && source == ImageSource.camera) {
        setState(() => _noticeMessage = _cameraCancelledMessage);
      }
      return;
    }

    await _analyzePickedImage(image);
  }

  Future<void> _analyzePickedImage(XFile image) async {
    try {
      setState(() => _isProcessing = true);

      final ocrText = await _ocrService.recognizeTextFromImagePath(image.path);
      if (!mounted) {
        return;
      }

      if (ocrText.trim().isEmpty) {
        setState(() {
          _isProcessing = false;
          _errorMessage = _emptyOcrMessage;
          _noticeMessage = null;
        });
        return;
      }

      if (kDebugMode) {
        setState(() {
          _isProcessing = false;
          _lastRawOcrText = ocrText;
          _pendingDebugOcrText = ocrText;
        });
        return;
      }

      _analyzeRecognizedText(ocrText);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isProcessing = false;
        _errorMessage = _ocrFailureMessage;
        _noticeMessage = null;
      });
    }
  }

  bool _isCameraPermissionError(PlatformException error) {
    return error.code.contains('camera_access') ||
        error.code == 'camera_permission_denied';
  }

  void _analyzePendingDebugOcrText() {
    final ocrText = _pendingDebugOcrText;
    if (ocrText == null) {
      return;
    }
    _analyzeRecognizedText(ocrText);
  }

  void _analyzeRecognizedText(String ocrText) {
    final draft = IngredientConfirmationDraft.fromOcrText(
      rawOcrText: ocrText,
      database: context.read<AppState>().ingredients,
      productName: 'ผลิตภัณฑ์จากรูปภาพ',
    );

    if (draft.parsedIngredients.isEmpty) {
      setState(() {
        _isProcessing = false;
        _errorMessage = _emptyOcrMessage;
        _noticeMessage = null;
      });
      return;
    }

    setState(() {
      _isProcessing = false;
      _errorMessage = null;
      _noticeMessage = null;
      _lastRawOcrText = null;
      _pendingDebugOcrText = null;
    });

    if (!mounted) {
      return;
    }
    context.push('/confirm-ingredients', extra: draft);
  }

  void _runMockScan() {
    final result = context.read<AppState>().analyzeMockOcr();
    context.push('/scan-result', extra: result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101515),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: _CameraMockup()),
            Positioned(
              top: 16,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleTool(
                    icon: Icons.close,
                    onTap: () => context.go('/home'),
                  ),
                  _CircleTool(icon: Icons.flash_on_outlined, onTap: () {}),
                ],
              ),
            ),
            Positioned(
              top: 118,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.56),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'จัดกรอบฉลากให้อยู่ในภาพ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: 190,
              bottom: 334,
              left: 34,
              right: 34,
              child: IgnorePointer(child: _ScanFrame()),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 218,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (_isProcessing)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.primaryDark,
                            ),
                          )
                        else
                          Icon(
                            _errorMessage == null
                                ? Icons.camera_alt_outlined
                                : Icons.error_outline,
                            color: _errorMessage == null
                                ? AppColors.primaryDark
                                : AppColors.warningDark,
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _isProcessing
                                ? 'กำลังอ่านข้อความจากภาพ...'
                                : 'ถ่ายหรือเลือกรูปฉลากส่วนผสม',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _statusMessage,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: _errorMessage == null
                            ? AppColors.textPrimary
                            : AppColors.warningDark,
                        height: 1.5,
                      ),
                    ),
                    if (kDebugMode && _lastRawOcrText != null) ...[
                      const SizedBox(height: 14),
                      _OcrDebugPreview(
                        rawText: _lastRawOcrText!,
                        canAnalyze: _pendingDebugOcrText != null,
                        onAnalyze: _analyzePendingDebugOcrText,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 18,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: const Key('cameraOcrButton'),
                      onPressed: _isProcessing
                          ? null
                          : () => _pickImageAndAnalyze(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('ถ่ายรูปฉลาก'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF101515),
                        disabledBackgroundColor: Colors.white70,
                        disabledForegroundColor: Colors.black45,
                        textStyle: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      key: const Key('galleryOcrButton'),
                      onPressed: _isProcessing
                          ? null
                          : () => _pickImageAndAnalyze(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('เลือกรูปจากเครื่อง'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.78),
                        ),
                        textStyle: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      key: const Key('mockScanButton'),
                      onPressed: _isProcessing ? null : _runMockScan,
                      icon: const Icon(Icons.science_outlined),
                      label: const Text('ทดสอบด้วยข้อมูลจำลอง'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.78),
                        ),
                        textStyle: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _statusMessage {
    if (_errorMessage != null) {
      return _errorMessage!;
    }
    if (_noticeMessage != null) {
      return _noticeMessage!;
    }
    if (_isProcessing) {
      return 'กรุณารอสักครู่ ระบบกำลังอ่านข้อความบนภาพ';
    }
    if (kDebugMode && _pendingDebugOcrText != null) {
      return 'ตรวจสอบข้อความ OCR ดิบด้านล่างก่อนวิเคราะห์ส่วนผสม';
    }
    return 'ถ่ายรูปฉลากหรือเลือกรูปจากเครื่องเพื่ออ่าน OCR หรือใช้ข้อมูลจำลองเพื่อทดสอบการไหลของแอป';
  }
}

class _OcrDebugPreview extends StatelessWidget {
  const _OcrDebugPreview({
    required this.rawText,
    required this.canAnalyze,
    required this.onAnalyze,
  });

  final String rawText;
  final bool canAnalyze;
  final VoidCallback onAnalyze;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E7E5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DEBUG OCR preview',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 96),
              child: SingleChildScrollView(
                child: SelectableText(
                  rawText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const Key('analyzeDebugOcrButton'),
                onPressed: canAnalyze ? onAnalyze : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('วิเคราะห์ข้อความ OCR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraMockup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF363A38), Color(0xFF161B1A)],
        ),
      ),
      child: Center(
        child: Opacity(
          opacity: 0.42,
          child: Container(
            width: 190,
            height: 360,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E7E2),
              borderRadius: BorderRadius.circular(42),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 82,
                  height: 92,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                const SizedBox(height: 18),
                ...List.generate(
                  6,
                  (index) => Container(
                    width: index.isEven ? 122 : 96,
                    height: 9,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(999),
                    ),
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

class _ScanFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _FramePainter());
  }
}

class _FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    const corner = 54.0;
    final path = Path()
      ..moveTo(0, corner)
      ..lineTo(0, 0)
      ..lineTo(corner, 0)
      ..moveTo(size.width - corner, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, corner)
      ..moveTo(size.width, size.height - corner)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - corner, size.height)
      ..moveTo(corner, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, size.height - corner);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CircleTool extends StatelessWidget {
  const _CircleTool({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onTap,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.35),
        foregroundColor: Colors.white,
      ),
    );
  }
}
