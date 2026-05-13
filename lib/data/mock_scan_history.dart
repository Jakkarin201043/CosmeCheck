import '../models/scan_result.dart';
import '../services/mock_ocr_service.dart';

class MockScanHistory {
  static final items = <ScanResult>[
    ScanResult(
      id: 'scan-001',
      productName: 'เซรั่มไฮยา',
      ocrText: MockOcrService.mockIngredientText,
      detectedIngredients: const [
        'Water',
        'Glycerin',
        'Niacinamide',
        'Alcohol Denat.',
        'Butylene Glycol',
        'Propanediol',
        'Panthenol',
        'Allantoin',
        'Sodium Hyaluronate',
        'Fragrance',
        'Disodium EDTA',
      ],
      matchedAllergens: const ['Alcohol Denat.', 'Fragrance'],
      helpfulIngredients: const [
        'Niacinamide',
        'Glycerin',
        'Panthenol',
        'Allantoin',
      ],
      cautionIngredients: const ['Alcohol Denat.', 'Fragrance'],
      riskScore: 6.8,
      status: 'ควรระวัง',
      createdAt: DateTime(2026, 5, 10, 10, 43),
    ),
    ScanResult(
      id: 'scan-002',
      productName: 'มอยส์เจอไรเซอร์',
      ocrText: 'Water, Glycerin, Ceramide NP, Squalane, Panthenol',
      detectedIngredients: const [
        'Water',
        'Glycerin',
        'Ceramide NP',
        'Squalane',
        'Panthenol',
      ],
      matchedAllergens: const [],
      helpfulIngredients: const ['Glycerin', 'Panthenol'],
      cautionIngredients: const [],
      riskScore: 2.0,
      status: 'ปลอดภัยเบื้องต้น',
      createdAt: DateTime(2026, 5, 10, 9, 15),
    ),
    ScanResult(
      id: 'scan-003',
      productName: 'โทนเนอร์อ่อนโยน',
      ocrText: 'Water, Glycerin, Allantoin, Sodium Hyaluronate',
      detectedIngredients: const [
        'Water',
        'Glycerin',
        'Allantoin',
        'Sodium Hyaluronate',
      ],
      matchedAllergens: const [],
      helpfulIngredients: const ['Glycerin', 'Allantoin'],
      cautionIngredients: const [],
      riskScore: 1.5,
      status: 'ปลอดภัยเบื้องต้น',
      createdAt: DateTime(2026, 5, 8, 18, 30),
    ),
  ];
}
