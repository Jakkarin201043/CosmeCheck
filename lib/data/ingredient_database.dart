import '../models/ingredient.dart';

class IngredientDatabase {
  static const ingredients = <Ingredient>[
    Ingredient(
      id: 'niacinamide',
      name: 'Niacinamide',
      thaiName: 'ไนอะซินาไมด์',
      inciName: 'Niacinamide',
      aliases: ['Vitamin B3', 'Nicotinamide', 'วิตามินบี 3'],
      category: 'วิตามินบี',
      tag: 'ให้ประโยชน์',
      riskLevel: 'low',
      shortDescription:
          'วิตามินบี 3 ที่ช่วยดูแลผิวหลายด้าน เช่น รอยแดง ความมัน และเกราะป้องกันผิว',
      whatIsIt:
          'Niacinamide เป็นอนุพันธ์ของวิตามินบี 3 ที่นิยมใช้ในสกินแคร์เพื่อช่วยดูแลสมดุลผิวและเกราะป้องกันผิว',
      benefits: [
        'ช่วยเสริมเกราะป้องกันผิว',
        'ช่วยลดรอยแดงและจุดด่างดำ',
        'ช่วยควบคุมความมันส่วนเกิน',
      ],
      cautions: ['โดยทั่วไปอ่อนโยน แต่บางคนอาจรู้สึกยิบผิวช่วงเริ่มใช้'],
      suitableFor: ['ผิวมัน', 'ผิวผสม', 'ผิวแพ้ง่ายบางกรณี'],
      avoidIf: ['เคยระคายเคืองจากสูตรที่มี Niacinamide เข้มข้นสูง'],
      commonIn: ['เซรั่ม', 'มอยส์เจอไรเซอร์', 'โทนเนอร์'],
      mythVsFact: [
        'Myth: Niacinamide ใช้กับผิวแพ้ง่ายไม่ได้',
        'Fact: หลายสูตรใช้ได้กับผิวแพ้ง่าย แต่ควรเริ่มทีละน้อยและสังเกตผิว',
      ],
      references: ['PubChem', 'CIR', 'CosIng'],
    ),
    Ingredient(
      id: 'glycerin',
      name: 'Glycerin',
      thaiName: 'กลีเซอริน',
      inciName: 'Glycerin',
      aliases: ['Glycerol', 'กลีเซอรอล'],
      category: 'สารให้ความชุ่มชื้น',
      tag: 'ให้ประโยชน์',
      riskLevel: 'low',
      shortDescription: 'สารให้ความชุ่มชื้น ช่วยดึงน้ำเข้าสู่ผิว',
      whatIsIt:
          'Glycerin เป็น humectant ที่พบได้บ่อยในมอยส์เจอไรเซอร์และคลีนเซอร์ ช่วยเพิ่มความรู้สึกนุ่มชุ่มชื้น',
      benefits: ['ช่วยเพิ่มความชุ่มชื้น', 'ช่วยให้ผิวนุ่มขึ้น'],
      cautions: ['โดยทั่วไปใช้ได้กับหลายสภาพผิว'],
      suitableFor: ['ผิวแห้ง', 'ผิวผสม', 'ผิวแพ้ง่าย'],
      avoidIf: ['ไม่ค่อยจำเป็นต้องหลีกเลี่ยง ยกเว้นเคยระคายเคืองจากสูตรนั้น'],
      commonIn: ['คลีนเซอร์', 'เซรั่ม', 'ครีมบำรุง', 'โลชั่น'],
      mythVsFact: [
        'Myth: Glycerin ทำให้เหนอะหนะเสมอ',
        'Fact: ความรู้สึกบนผิวขึ้นอยู่กับสูตรและปริมาณที่ใช้',
      ],
      references: ['PubChem', 'CIR', 'CosIng'],
    ),
    Ingredient(
      id: 'salicylic-acid',
      name: 'Salicylic Acid',
      thaiName: 'ซาลิไซลิก แอซิด',
      inciName: 'Salicylic Acid',
      aliases: ['BHA', 'Beta Hydroxy Acid', 'กรดซาลิไซลิก'],
      category: 'สารผลัดเซลล์ผิว',
      tag: 'ให้ประโยชน์',
      riskLevel: 'medium',
      shortDescription: 'กรดผลัดเซลล์ผิวที่มักใช้ในผลิตภัณฑ์ดูแลปัญหาสิว',
      whatIsIt:
          'Salicylic Acid เป็น BHA ที่ละลายในน้ำมัน จึงมักใช้ในสูตรดูแลสิวอุดตันและความมันส่วนเกิน',
      benefits: ['ช่วยผลัดเซลล์ผิว', 'ช่วยดูแลสิวอุดตัน'],
      cautions: ['อาจทำให้ผิวแห้งหรือระคายเคืองได้', 'ควรเริ่มใช้ทีละน้อย'],
      suitableFor: ['ผิวมัน', 'ผิวเป็นสิวง่าย'],
      avoidIf: [
        'ผิวแห้งมาก',
        'ผิวลอกหรือระคายเคืองอยู่',
        'แพ้กลุ่ม salicylate',
      ],
      commonIn: ['โทนเนอร์ผลัดเซลล์ผิว', 'เจลแต้มสิว', 'คลีนเซอร์ลดสิว'],
      mythVsFact: [
        'Myth: ใช้ BHA ทุกวันแล้วเห็นผลเร็วกว่า',
        'Fact: การใช้ถี่เกินไปอาจทำให้ผิวแห้งหรือระคายเคือง ควรปรับตามสภาพผิว',
      ],
      references: ['PubChem', 'CIR'],
    ),
    Ingredient(
      id: 'alcohol-denat',
      name: 'Alcohol Denat.',
      thaiName: 'แอลกอฮอล์ดีแนท',
      inciName: 'Alcohol Denat.',
      aliases: ['Denatured Alcohol', 'SD Alcohol', 'Alcohol', 'Ethanol'],
      category: 'ตัวทำละลาย',
      tag: 'ควรระวัง',
      riskLevel: 'medium',
      shortDescription: 'แอลกอฮอล์ระเหยไว อาจทำให้ผิวแห้งหรือแสบในบางคน',
      whatIsIt:
          'Alcohol Denat. เป็นแอลกอฮอล์ระเหยไวที่ช่วยให้สูตรแห้งเร็วและบางเบา แต่ผิวบางประเภทอาจรู้สึกแห้งหรือแสบ',
      benefits: ['ช่วยให้ผลิตภัณฑ์แห้งไว', 'ช่วยให้เนื้อสัมผัสบางเบา'],
      cautions: [
        'อาจทำให้ผิวแห้ง',
        'ผิวแพ้ง่ายควรทดสอบก่อนใช้',
        'หากเคยแสบหรือแดงจากผลิตภัณฑ์ที่มีแอลกอฮอล์ควรหลีกเลี่ยง',
      ],
      suitableFor: [
        'ผิวมันบางกรณี',
        'ผู้ที่ไม่มีประวัติระคายเคืองจากแอลกอฮอล์',
      ],
      avoidIf: ['ผิวแห้งมาก', 'ผิวแพ้ง่าย', 'เคยแสบหรือแดงจากแอลกอฮอล์ระเหยไว'],
      commonIn: ['กันแดด', 'โทนเนอร์', 'เซรั่มเนื้อบางเบา'],
      mythVsFact: [
        'Myth: Alcohol ทุกชนิดทำร้ายผิว',
        'Fact: Alcohol มีหลายกลุ่ม บางชนิดเป็น fatty alcohol ที่ช่วยให้เนื้อครีมนุ่มได้',
      ],
      references: ['CIR', 'PubChem'],
    ),
    Ingredient(
      id: 'fragrance',
      name: 'Fragrance',
      thaiName: 'น้ำหอม',
      inciName: 'Fragrance / Parfum',
      aliases: ['Parfum', 'Perfume', 'Aroma', 'น้ำหอม', 'สารแต่งกลิ่น'],
      category: 'สารแต่งกลิ่น',
      tag: 'ควรระวัง',
      riskLevel: 'high',
      shortDescription:
          'สารให้กลิ่นหอม อาจเป็นตัวกระตุ้นการแพ้หรือระคายเคืองในบางคน',
      whatIsIt:
          'Fragrance หรือ Parfum คือกลุ่มสารแต่งกลิ่นในผลิตภัณฑ์ ซึ่งอาจประกอบด้วยสารหลายชนิดและควรระวังเป็นพิเศษในผู้ที่มีผิวแพ้ง่าย',
      benefits: ['ช่วยเพิ่มกลิ่นและประสบการณ์การใช้ผลิตภัณฑ์'],
      cautions: [
        'ผิวแพ้ง่ายควรระวัง',
        'ผู้ที่เคยแพ้น้ำหอมควรหลีกเลี่ยง',
        'ควรทำ Patch Test ก่อนใช้',
      ],
      suitableFor: ['ผู้ที่ไม่มีประวัติแพ้น้ำหอม'],
      avoidIf: ['ผิวแพ้ง่าย', 'เคยแพ้น้ำหอม', 'มีผื่นหรือระคายเคืองง่าย'],
      commonIn: ['ครีมบำรุง', 'โลชั่น', 'เซรั่ม', 'กันแดด', 'คลีนเซอร์'],
      mythVsFact: [
        'Myth: ผลิตภัณฑ์มีกลิ่นหอมแปลว่าอ่อนโยน',
        'Fact: กลิ่นหอมไม่ได้บอกความอ่อนโยน ผู้ที่ผิวแพ้ง่ายควรดูฉลากและทดสอบก่อนใช้',
      ],
      references: ['FDA', 'CosIng'],
    ),
  ];

  static Ingredient findById(String id) {
    return ingredients.firstWhere(
      (ingredient) => ingredient.id == id,
      orElse: () => ingredients.first,
    );
  }
}
