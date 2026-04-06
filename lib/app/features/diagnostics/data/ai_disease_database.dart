import 'package:krishiastra/app/features/diagnostics/domain/entities/disease.dart';

/// Static disease database matching the AI model's trained classes
/// Model: winkoo/plant-disease-api (Hugging Face)
/// Source: https://github.com/MadGcodes/Krishi
class AiDiseaseDatabase {
  AiDiseaseDatabase._();

  /// Map of AI model output (snake_case) to Disease entity
  static final Map<String, Disease> diseases = {
    // ============================================
    // SUGARCANE DISEASES
    // ============================================
    'sugarcane_rust': const Disease(
      name: 'Sugarcane Rust',
      description:
          'Rust is a fungal disease that affects sugarcane leaves, causing orange-brown pustules on both leaf surfaces. It can reduce photosynthesis and overall plant vigor, leading to yield losses if not managed properly.',
      symptoms:
          'Small, elongated, orange-brown pustules on both upper and lower leaf surfaces\n\nPustules rupture to release orange spores\n\nLeaves may turn yellow and die prematurely\n\nReduced plant vigor and growth\n\nSevere infections can cause significant yield loss',
      remedies: [
        Remedy(
          id: 'rust_preventive',
          preventiveMeasures:
              'Plant resistant varieties\n\nMaintain proper field sanitation\n\nRemove and destroy infected plant debris\n\nEnsure adequate spacing for air circulation\n\nAvoid excessive nitrogen fertilization',
          biologicalControl:
              'Apply Trichoderma viride or Bacillus subtilis\n\nUse neem oil spray (3-5 ml/liter of water)\n\nEncourage natural predators',
          chemicalControl:
              'Spray Mancozeb (2.5 g/liter) at first sign of disease\n\nUse Propiconazole (1 ml/liter) for severe infections\n\nApply fungicides at 10-15 day intervals during favorable conditions',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'Medium',
    ),

    'sugarcane_red_rot': const Disease(
      name: 'Red Rot',
      description:
          'Red rot is one of the most destructive fungal diseases of sugarcane. It affects the stalks, causing internal reddening with white patches when split open. The disease spreads through infected seed material and water.',
      symptoms:
          'Red discoloration of internal cane tissue\n\nWhite patches across red areas (cross-wise bands)\n\nDrying of top leaves from tip downward\n\nShrinkage and drying of stalks\n\nSour or alcoholic smell from affected cane\n\nLoss of juice quality and sugar recovery\n\nCane becomes hollow in severe cases\n\nPoor germination of infected setts',
      remedies: [
        Remedy(
          id: 'red_rot_preventive',
          preventiveMeasures:
              'Use disease-free, healthy seed material\n\nPlant resistant varieties\n\nTreat setts with fungicides before planting\n\nPractice crop rotation\n\nRemove and burn infected plants immediately\n\nAvoid waterlogging in fields',
          biologicalControl:
              'Treat setts with Trichoderma viride (10 g/liter) for 30 minutes\n\nApply Pseudomonas fluorescens as soil treatment',
          chemicalControl:
              'Dip setts in Carbendazim (2 g/liter) or Thiophanate-methyl (1 g/liter) for 30 minutes before planting\n\nSpray standing crop with Propiconazole (1 ml/liter) if symptoms appear',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'sugarcane_whip_smut': const Disease(
      name: 'Whip Smut',
      description:
          'Whip smut is a systemic fungal disease that produces a long, whip-like structure from the growing point of sugarcane. It can cause significant yield losses and affects cane quality.',
      symptoms:
          'Long, whip-like growth emerging from the top of the plant\n\nWhip is initially covered with a silvery membrane\n\nMembrane ruptures to release black spores\n\nAffected shoots are thin and stunted\n\nReduced tillering\n\nPlant may die if infection is severe',
      remedies: [
        Remedy(
          id: 'whip_smut_preventive',
          preventiveMeasures:
              'Plant resistant varieties\n\nUse disease-free seed material\n\nRogue out and burn infected plants immediately\n\nAvoid ratoon crops in heavily infected fields\n\nMaintain field sanitation',
          biologicalControl:
              'Limited biological control options\n\nFocus on preventive measures and resistant varieties',
          chemicalControl:
              'Treat seed setts with Carbendazim (2 g/liter) before planting\n\nSpray standing crop with Propiconazole (1 ml/liter) if disease appears',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'sugarcane_leaf_spot': const Disease(
      name: 'Leaf Spot',
      description:
          'Leaf spot diseases in sugarcane are caused by various fungal pathogens that create spots on leaves, reducing photosynthetic area and overall plant health.',
      symptoms:
          'Small, circular to oval spots on leaves\n\nSpots may be brown, red, or yellow with darker borders\n\nCoalescing of spots in severe infections\n\nPremature leaf drying and death\n\nReduced plant vigor',
      remedies: [
        Remedy(
          id: 'leaf_spot_preventive',
          preventiveMeasures:
              'Plant resistant varieties\n\nMaintain proper field sanitation\n\nRemove infected leaves\n\nEnsure adequate spacing\n\nAvoid overhead irrigation',
          biologicalControl:
              'Apply Trichoderma viride or Bacillus subtilis\n\nUse neem oil spray (3-5 ml/liter)',
          chemicalControl:
              'Spray Mancozeb (2.5 g/liter) or Copper oxychloride (3 g/liter)\n\nRepeat application at 15-day intervals if needed',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'Low to Medium',
    ),

    'sugarcane_mosaic': const Disease(
      name: 'Sugarcane Mosaic Virus',
      description:
          'Sugarcane mosaic is a viral disease transmitted by aphids. It causes characteristic mosaic patterns on leaves and can significantly reduce yield and sugar content.',
      symptoms:
          'Light and dark green mosaic pattern on leaves\n\nYellowing of leaves\n\nStunted growth\n\nReduced tillering\n\nThin and weak stalks\n\nReduced sugar content\n\nYield losses up to 50% in susceptible varieties',
      remedies: [
        Remedy(
          id: 'mosaic_preventive',
          preventiveMeasures:
              'Plant virus-free, certified seed material\n\nUse resistant varieties\n\nControl aphid vectors with insecticides\n\nRogue out infected plants immediately\n\nAvoid ratoon crops from infected fields\n\nMaintain field sanitation',
          biologicalControl:
              'Control aphids with neem oil spray (5 ml/liter)\n\nEncourage natural predators of aphids (ladybugs, lacewings)',
          chemicalControl:
              'Control aphid vectors with Imidacloprid (0.5 ml/liter) or Thiamethoxam (0.3 g/liter)\n\nNo direct chemical control for virus - focus on vector control',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'sugarcane_healthy': const Disease(
      name: 'Healthy Sugarcane',
      description:
          'The plant appears healthy with no visible signs of disease. Continue good agricultural practices to maintain plant health.',
      symptoms:
          'No disease symptoms detected\n\nPlant shows normal growth and vigor',
      remedies: [
        Remedy(
          id: 'healthy_maintenance',
          preventiveMeasures:
              'Continue regular monitoring\n\nMaintain balanced nutrition\n\nEnsure proper irrigation\n\nPractice crop rotation\n\nMaintain field sanitation',
          biologicalControl: 'No treatment needed',
          chemicalControl: 'No treatment needed',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'None',
    ),

    // ============================================
    // RICE DISEASES
    // ============================================
    'rice_blast': const Disease(
      name: 'Rice Blast',
      description:
          'Rice blast is a devastating fungal disease that can affect all above-ground parts of the rice plant. It thrives in humid conditions and can cause significant yield losses.',
      symptoms:
          'Diamond-shaped lesions on leaves with gray centers and brown margins\n\nNeck rot causing lodging\n\nPanicle infection leading to grain sterility\n\nSeedling blight in nurseries\n\nNode infection causing breakage',
      remedies: [
        Remedy(
          id: 'rice_blast_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nUse balanced fertilization (avoid excess nitrogen)\n\nMaintain proper water management\n\nRemove infected plant debris\n\nUse disease-free seeds',
          biologicalControl:
              'Apply Trichoderma viride or Pseudomonas fluorescens\n\nUse neem cake in soil',
          chemicalControl:
              'Spray Tricyclazole (0.6 g/liter) or Carbendazim (1 g/liter)\n\nApply at tillering, booting, and heading stages',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'rice_brown_spot': const Disease(
      name: 'Rice Brown Spot',
      description:
          'Brown spot is a fungal disease that affects rice plants, particularly under nutrient-deficient conditions. It can reduce grain quality and yield.',
      symptoms:
          'Small, circular to oval brown spots on leaves\n\nSpots have yellow halos\n\nSevere infection causes leaf blight\n\nGrain discoloration\n\nReduced grain quality and weight',
      remedies: [
        Remedy(
          id: 'brown_spot_control',
          preventiveMeasures:
              'Ensure balanced nutrition (especially potassium)\n\nUse certified disease-free seeds\n\nTreat seeds with fungicides\n\nMaintain proper water management\n\nRemove infected stubble',
          biologicalControl:
              'Seed treatment with Trichoderma viride\n\nApply Pseudomonas fluorescens',
          chemicalControl:
              'Seed treatment with Carbendazim (2 g/kg seed)\n\nSpray Mancozeb (2.5 g/liter) or Edifenphos (1 ml/liter)',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'Medium',
    ),

    'rice_sheath_blight': const Disease(
      name: 'Rice Sheath Blight',
      description:
          'Sheath blight is a major fungal disease of rice that affects the leaf sheath and can spread to leaves and panicles, causing significant yield losses.',
      symptoms:
          'Oval to irregular greenish-gray lesions on leaf sheaths near water line\n\nLesions enlarge and develop white centers with brown margins\n\nInfection spreads upward to leaves and panicles\n\nPremature drying of leaves\n\nLodging in severe cases\n\nYield reduction up to 50%',
      remedies: [
        Remedy(
          id: 'sheath_blight_control',
          preventiveMeasures:
              'Avoid excessive nitrogen fertilization\n\nMaintain proper plant spacing\n\nDrain water periodically\n\nRemove infected plant debris\n\nUse balanced fertilization',
          biologicalControl:
              'Apply Trichoderma viride or Pseudomonas fluorescens\n\nUse Bacillus subtilis as foliar spray',
          chemicalControl:
              'Spray Validamycin (2 ml/liter) or Hexaconazole (2 ml/liter)\n\nApply at early tillering and repeat at 15-day intervals',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'rice_tungro': const Disease(
      name: 'Rice Tungro Virus',
      description:
          'Tungro is a viral disease transmitted by green leafhoppers. It causes yellowing and stunting of rice plants and can cause severe yield losses.',
      symptoms:
          'Yellow to orange discoloration of leaves\n\nStunted growth\n\nReduced tillering\n\nDelayed flowering\n\nPartially filled or empty grains\n\nPlants may die in severe cases',
      remedies: [
        Remedy(
          id: 'tungro_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nUse virus-free seeds\n\nControl leafhopper vectors\n\nRemove infected plants immediately\n\nAvoid staggered planting\n\nSynchronize planting in the area',
          biologicalControl:
              'Encourage natural predators of leafhoppers\n\nUse neem oil to repel vectors',
          chemicalControl:
              'Control leafhoppers with Imidacloprid (0.5 ml/liter) or Thiamethoxam (0.3 g/liter)\n\nNo direct cure for virus - focus on vector control',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'rice_healthy': const Disease(
      name: 'Healthy Rice',
      description:
          'The rice plant appears healthy with no visible signs of disease. Continue good agricultural practices.',
      symptoms:
          'No disease symptoms detected\n\nNormal plant growth and development',
      remedies: [
        Remedy(
          id: 'rice_healthy_maintenance',
          preventiveMeasures:
              'Continue monitoring\n\nMaintain balanced nutrition\n\nProper water management\n\nField sanitation',
          biologicalControl: 'No treatment needed',
          chemicalControl: 'No treatment needed',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'None',
    ),

    // ============================================
    // CORN (MAIZE) DISEASES
    // ============================================
    'corn_common_rust': const Disease(
      name: 'Corn Common Rust',
      description:
          'Common rust is a fungal disease that produces rust-colored pustules on corn leaves. It can reduce photosynthesis and yield if severe.',
      symptoms:
          'Small, circular to elongated rust-colored pustules on both leaf surfaces\n\nPustules rupture to release reddish-brown spores\n\nLeaves may turn yellow and die prematurely\n\nSevere infections reduce grain fill',
      remedies: [
        Remedy(
          id: 'corn_rust_control',
          preventiveMeasures:
              'Plant resistant hybrids\n\nPractice crop rotation\n\nRemove crop residue\n\nAvoid late planting\n\nMaintain balanced nutrition',
          biologicalControl:
              'Apply Trichoderma viride\n\nUse neem oil spray (3-5 ml/liter)',
          chemicalControl:
              'Spray Mancozeb (2.5 g/liter) or Azoxystrobin (1 ml/liter)\n\nApply at first sign of disease',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'Medium',
    ),

    'corn_leaf_spot': const Disease(
      name: 'Corn Leaf Spot',
      description:
          'Leaf spot diseases in corn are caused by various fungal pathogens, creating spots that reduce photosynthetic capacity.',
      symptoms:
          'Circular to oval spots on leaves\n\nSpots may be gray, brown, or tan with darker borders\n\nCoalescing of spots in severe cases\n\nPremature leaf death\n\nReduced yield',
      remedies: [
        Remedy(
          id: 'corn_leaf_spot_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nCrop rotation with non-host crops\n\nRemove infected debris\n\nAvoid overhead irrigation\n\nMaintain proper spacing',
          biologicalControl:
              'Apply Bacillus subtilis\n\nUse Trichoderma viride',
          chemicalControl:
              'Spray Mancozeb (2.5 g/liter) or Chlorothalonil (2 g/liter)\n\nRepeat at 10-14 day intervals',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'Medium',
    ),

    'corn_streak_virus': const Disease(
      name: 'Corn Streak Virus',
      description:
          'Maize streak virus is transmitted by leafhoppers and causes characteristic streaking on leaves, leading to significant yield losses.',
      symptoms:
          'Fine, pale yellow streaks parallel to leaf veins\n\nStunted plant growth\n\nReduced ear size and grain fill\n\nSevere cases may cause plant death\n\nYield losses up to 100% in susceptible varieties',
      remedies: [
        Remedy(
          id: 'corn_streak_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nControl leafhopper vectors\n\nEarly planting to avoid peak vector populations\n\nRemove infected plants\n\nUse virus-free seeds',
          biologicalControl:
              'Encourage natural predators of leafhoppers\n\nUse neem oil to repel vectors',
          chemicalControl:
              'Control leafhoppers with Imidacloprid (0.5 ml/liter)\n\nNo direct cure for virus - focus on vector control',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'corn_healthy': const Disease(
      name: 'Healthy Corn',
      description:
          'The corn plant appears healthy with no visible disease symptoms. Continue good management practices.',
      symptoms: 'No disease symptoms detected\n\nNormal plant growth and vigor',
      remedies: [
        Remedy(
          id: 'corn_healthy_maintenance',
          preventiveMeasures:
              'Continue monitoring\n\nMaintain balanced nutrition\n\nProper irrigation\n\nCrop rotation\n\nField sanitation',
          biologicalControl: 'No treatment needed',
          chemicalControl: 'No treatment needed',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'None',
    ),

    // ============================================
    // COTTON DISEASES
    // ============================================
    'cotton_angular_leaf_spot': const Disease(
      name: 'Cotton Angular Leaf Spot',
      description:
          'Angular leaf spot is a bacterial disease that causes angular lesions on cotton leaves, leading to defoliation and reduced yield.',
      symptoms:
          'Angular, water-soaked lesions on leaves\n\nLesions turn brown and necrotic\n\nPremature defoliation\n\nBoll rot in severe cases\n\nReduced fiber quality',
      remedies: [
        Remedy(
          id: 'cotton_angular_control',
          preventiveMeasures:
              'Use disease-free seeds\n\nPlant resistant varieties\n\nCrop rotation\n\nRemove infected plant debris\n\nAvoid overhead irrigation',
          biologicalControl:
              'Apply Pseudomonas fluorescens\n\nUse Bacillus subtilis',
          chemicalControl:
              'Spray Copper oxychloride (3 g/liter) or Streptocycline (0.1 g/liter)\n\nApply at first sign of disease',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'Medium',
    ),

    'cotton_anthracnose': const Disease(
      name: 'Cotton Anthracnose',
      description:
          'Anthracnose is a fungal disease affecting cotton bolls, stems, and leaves, causing significant yield and quality losses.',
      symptoms:
          'Circular, sunken lesions on bolls\n\nBrown to black spots on leaves\n\nStem cankers\n\nBoll rot and fiber staining\n\nSeedling damping-off',
      remedies: [
        Remedy(
          id: 'cotton_anthracnose_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nSeed treatment with fungicides\n\nCrop rotation\n\nRemove infected plant debris\n\nAvoid plant stress',
          biologicalControl:
              'Seed treatment with Trichoderma viride\n\nApply Bacillus subtilis',
          chemicalControl:
              'Seed treatment with Carbendazim (2 g/kg)\n\nSpray Mancozeb (2.5 g/liter) or Azoxystrobin (1 ml/liter)',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'cotton_grey_mildew': const Disease(
      name: 'Cotton Grey Mildew',
      description:
          'Grey mildew is a fungal disease that affects cotton leaves, causing a characteristic grey growth on the underside.',
      symptoms:
          'White to grey powdery growth on lower leaf surface\n\nYellow spots on upper leaf surface\n\nPremature defoliation\n\nReduced photosynthesis\n\nStunted plant growth',
      remedies: [
        Remedy(
          id: 'cotton_grey_mildew_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nMaintain proper spacing\n\nAvoid excessive nitrogen\n\nRemove infected leaves\n\nEnsure good air circulation',
          biologicalControl:
              'Apply Trichoderma viride\n\nUse Bacillus subtilis',
          chemicalControl:
              'Spray Sulfur (3 g/liter) or Azoxystrobin (1 ml/liter)\n\nRepeat at 10-14 day intervals',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'Medium',
    ),

    'cotton_wilt': const Disease(
      name: 'Cotton Wilt',
      description:
          'Wilt is a soil-borne fungal disease that blocks water transport in cotton plants, causing wilting and death.',
      symptoms:
          'Yellowing and wilting of leaves\n\nBrowning of vascular tissue\n\nStunted growth\n\nPlant death in severe cases\n\nYield losses up to 50%',
      remedies: [
        Remedy(
          id: 'cotton_wilt_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nCrop rotation with non-host crops\n\nSoil solarization\n\nUse disease-free seeds\n\nMaintain soil health',
          biologicalControl:
              'Soil treatment with Trichoderma viride\n\nApply Pseudomonas fluorescens',
          chemicalControl:
              'Soil drenching with Carbendazim (1 g/liter)\n\nSeed treatment with Thiram (2 g/kg)',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'cotton_healthy': const Disease(
      name: 'Healthy Cotton',
      description:
          'The cotton plant appears healthy with no visible disease symptoms. Continue good management practices.',
      symptoms:
          'No disease symptoms detected\n\nNormal plant growth and development',
      remedies: [
        Remedy(
          id: 'cotton_healthy_maintenance',
          preventiveMeasures:
              'Continue monitoring\n\nMaintain balanced nutrition\n\nProper irrigation\n\nCrop rotation\n\nField sanitation',
          biologicalControl: 'No treatment needed',
          chemicalControl: 'No treatment needed',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'None',
    ),

    // ============================================
    // PEANUT (GROUNDNUT) DISEASES
    // ============================================
    'peanut_rust': const Disease(
      name: 'Peanut Rust',
      description:
          'Rust is a fungal disease that produces rust-colored pustules on peanut leaves, reducing photosynthesis and yield.',
      symptoms:
          'Small, circular, rust-colored pustules on lower leaf surface\n\nYellow spots on upper leaf surface\n\nPremature defoliation\n\nReduced pod fill\n\nYield losses up to 50%',
      remedies: [
        Remedy(
          id: 'peanut_rust_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nCrop rotation\n\nRemove infected debris\n\nMaintain proper spacing\n\nAvoid excessive nitrogen',
          biologicalControl:
              'Apply Trichoderma viride\n\nUse neem oil spray (3-5 ml/liter)',
          chemicalControl:
              'Spray Mancozeb (2.5 g/liter) or Tebuconazole (1 ml/liter)\n\nApply at first sign and repeat at 10-14 day intervals',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'peanut_early_leaf_spot': const Disease(
      name: 'Peanut Early Leaf Spot',
      description:
          'Early leaf spot is a fungal disease causing circular lesions on peanut leaves, leading to defoliation and yield loss.',
      symptoms:
          'Small, circular, dark brown spots on upper leaf surface\n\nYellow halo around spots\n\nPremature defoliation\n\nReduced photosynthesis\n\nYield reduction up to 50%',
      remedies: [
        Remedy(
          id: 'peanut_early_spot_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nCrop rotation\n\nRemove crop residue\n\nMaintain proper spacing\n\nAvoid overhead irrigation',
          biologicalControl:
              'Apply Trichoderma viride\n\nUse Bacillus subtilis',
          chemicalControl:
              'Spray Chlorothalonil (2 g/liter) or Azoxystrobin (1 ml/liter)\n\nBegin at 30-40 days after planting, repeat every 10-14 days',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'peanut_late_leaf_spot': const Disease(
      name: 'Peanut Late Leaf Spot',
      description:
          'Late leaf spot is a fungal disease similar to early leaf spot but with darker lesions and more severe defoliation.',
      symptoms:
          'Dark brown to black spots on leaves\n\nNo yellow halo\n\nSevere defoliation\n\nReduced pod quality\n\nYield losses up to 70%',
      remedies: [
        Remedy(
          id: 'peanut_late_spot_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nCrop rotation\n\nRemove infected debris\n\nMaintain proper spacing\n\nBalanced fertilization',
          biologicalControl:
              'Apply Trichoderma viride\n\nUse Pseudomonas fluorescens',
          chemicalControl:
              'Spray Tebuconazole (1 ml/liter) or Azoxystrobin (1 ml/liter)\n\nApply every 10-14 days during disease-favorable conditions',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'peanut_healthy': const Disease(
      name: 'Healthy Peanut',
      description:
          'The peanut plant appears healthy with no visible disease symptoms. Continue good management practices.',
      symptoms:
          'No disease symptoms detected\n\nNormal plant growth and pod development',
      remedies: [
        Remedy(
          id: 'peanut_healthy_maintenance',
          preventiveMeasures:
              'Continue monitoring\n\nMaintain balanced nutrition\n\nProper irrigation\n\nCrop rotation\n\nField sanitation',
          biologicalControl: 'No treatment needed',
          chemicalControl: 'No treatment needed',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'None',
    ),

    // ============================================
    // TOMATO & VEGETABLE DISEASES
    // ============================================
    'tomato_late_blight': const Disease(
      name: 'Tomato Late Blight',
      description:
          'Late blight is a devastating fungal disease that can destroy entire tomato crops within days under favorable conditions.',
      symptoms:
          'Water-soaked lesions on leaves\n\nWhite fungal growth on lower leaf surface\n\nBrown lesions on stems and fruits\n\nRapid plant death\n\nFoul odor from infected tissues',
      remedies: [
        Remedy(
          id: 'tomato_late_blight_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nAvoid overhead irrigation\n\nMaintain proper spacing\n\nRemove infected plants immediately\n\nUse disease-free transplants',
          biologicalControl:
              'Apply Bacillus subtilis\n\nUse Trichoderma viride',
          chemicalControl:
              'Spray Mancozeb (2.5 g/liter) or Metalaxyl + Mancozeb (2 g/liter)\n\nApply preventively every 7-10 days during humid conditions',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'tomato_leaf_mold': const Disease(
      name: 'Tomato Leaf Mold',
      description:
          'Leaf mold is a fungal disease that thrives in humid conditions, causing yellowing and defoliation of tomato plants.',
      symptoms:
          'Yellow spots on upper leaf surface\n\nOlive-green to grey-brown mold on lower leaf surface\n\nPremature defoliation\n\nReduced fruit quality\n\nYield reduction',
      remedies: [
        Remedy(
          id: 'tomato_leaf_mold_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nImprove air circulation\n\nReduce humidity\n\nAvoid overhead irrigation\n\nRemove infected leaves',
          biologicalControl:
              'Apply Trichoderma viride\n\nUse Bacillus subtilis',
          chemicalControl:
              'Spray Chlorothalonil (2 g/liter) or Azoxystrobin (1 ml/liter)\n\nApply at first sign and repeat every 7-10 days',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'Medium',
    ),

    'tomato_septoria_leaf_spot': const Disease(
      name: 'Tomato Septoria Leaf Spot',
      description:
          'Septoria leaf spot is a fungal disease causing numerous small spots on tomato leaves, leading to defoliation.',
      symptoms:
          'Small, circular spots with grey centers and dark borders\n\nTiny black dots (fruiting bodies) in spot centers\n\nPremature defoliation from bottom up\n\nReduced fruit quality\n\nYield reduction',
      remedies: [
        Remedy(
          id: 'tomato_septoria_control',
          preventiveMeasures:
              'Crop rotation\n\nRemove infected plant debris\n\nMulch to prevent soil splash\n\nAvoid overhead irrigation\n\nMaintain proper spacing',
          biologicalControl:
              'Apply Bacillus subtilis\n\nUse Trichoderma viride',
          chemicalControl:
              'Spray Mancozeb (2.5 g/liter) or Chlorothalonil (2 g/liter)\n\nBegin at first sign and repeat every 7-10 days',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'Medium',
    ),

    'tomato_healthy': const Disease(
      name: 'Healthy Tomato',
      description:
          'The tomato plant appears healthy with no visible disease symptoms. Continue good management practices.',
      symptoms:
          'No disease symptoms detected\n\nNormal plant growth and fruit development',
      remedies: [
        Remedy(
          id: 'tomato_healthy_maintenance',
          preventiveMeasures:
              'Continue monitoring\n\nMaintain balanced nutrition\n\nProper irrigation\n\nCrop rotation\n\nField sanitation',
          biologicalControl: 'No treatment needed',
          chemicalControl: 'No treatment needed',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'None',
    ),

    'eggplant_mosaic_virus_disease': const Disease(
      name: 'Eggplant Mosaic Virus',
      description:
          'Mosaic virus causes mottling and distortion of eggplant leaves, reducing plant vigor and fruit quality.',
      symptoms:
          'Light and dark green mosaic pattern on leaves\n\nLeaf distortion and curling\n\nStunted plant growth\n\nReduced fruit size and quality\n\nYield reduction',
      remedies: [
        Remedy(
          id: 'eggplant_mosaic_control',
          preventiveMeasures:
              'Use virus-free transplants\n\nControl aphid vectors\n\nRemove infected plants\n\nAvoid tobacco use near plants\n\nPractice crop rotation',
          biologicalControl:
              'Control aphids with neem oil\n\nEncourage natural predators',
          chemicalControl:
              'Control aphids with Imidacloprid (0.5 ml/liter)\n\nNo direct cure for virus - focus on vector control',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'Medium',
    ),

    'pepper_bell_bacterial_spot': const Disease(
      name: 'Pepper Bacterial Spot',
      description:
          'Bacterial spot is a serious disease of peppers causing leaf spots, defoliation, and fruit lesions.',
      symptoms:
          'Small, dark, water-soaked spots on leaves\n\nSpots turn brown with yellow halos\n\nPremature defoliation\n\nRaised, corky spots on fruits\n\nReduced fruit quality and yield',
      remedies: [
        Remedy(
          id: 'pepper_bacterial_spot_control',
          preventiveMeasures:
              'Use disease-free seeds and transplants\n\nCrop rotation\n\nAvoid overhead irrigation\n\nRemove infected plant debris\n\nMaintain proper spacing',
          biologicalControl:
              'Apply Bacillus subtilis\n\nUse Pseudomonas fluorescens',
          chemicalControl:
              'Spray Copper oxychloride (3 g/liter) or Streptocycline (0.1 g/liter)\n\nApply preventively every 7-10 days',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    // ============================================
    // APPLE DISEASES
    // ============================================
    'apple_scab': const Disease(
      name: 'Apple Scab',
      description:
          'Apple scab is a fungal disease that causes dark, scabby lesions on leaves and fruits, reducing fruit quality and marketability.',
      symptoms:
          'Olive-green to dark brown spots on leaves\n\nVelvety appearance on lesions\n\nPremature defoliation\n\nScabby, corky lesions on fruits\n\nFruit cracking and deformation',
      remedies: [
        Remedy(
          id: 'apple_scab_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nRemove fallen leaves\n\nPrune for air circulation\n\nAvoid overhead irrigation\n\nMaintain orchard sanitation',
          biologicalControl:
              'Apply Bacillus subtilis\n\nUse Trichoderma viride',
          chemicalControl:
              'Spray Mancozeb (2.5 g/liter) or Myclobutanil (1 ml/liter)\n\nApply at bud break and continue through growing season',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'apple_black_rot': const Disease(
      name: 'Apple Black Rot',
      description:
          'Black rot is a fungal disease affecting apple fruits, leaves, and branches, causing significant losses if not managed.',
      symptoms:
          'Purple spots on leaves that turn brown\n\nFrog-eye leaf spot pattern\n\nBlack, sunken lesions on fruits\n\nFruit mummification\n\nBranch cankers',
      remedies: [
        Remedy(
          id: 'apple_black_rot_control',
          preventiveMeasures:
              'Remove mummified fruits\n\nPrune out infected branches\n\nMaintain orchard sanitation\n\nAvoid fruit injuries\n\nProper fertilization',
          biologicalControl:
              'Apply Trichoderma viride\n\nUse Bacillus subtilis',
          chemicalControl:
              'Spray Captan (2 g/liter) or Thiophanate-methyl (1 g/liter)\n\nApply from petal fall through harvest',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'apple_cedar_apple_rust': const Disease(
      name: 'Cedar Apple Rust',
      description:
          'Cedar apple rust is a fungal disease requiring both apple and cedar trees to complete its life cycle, causing leaf spots and fruit lesions.',
      symptoms:
          'Bright orange spots on upper leaf surface\n\nTube-like structures on lower leaf surface\n\nPremature defoliation\n\nOrange lesions on fruits\n\nReduced fruit quality',
      remedies: [
        Remedy(
          id: 'cedar_apple_rust_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nRemove nearby cedar trees if possible\n\nMaintain orchard sanitation\n\nPrune for air circulation\n\nAvoid planting near cedars',
          biologicalControl:
              'Limited biological control options\n\nFocus on preventive measures',
          chemicalControl:
              'Spray Myclobutanil (1 ml/liter) or Mancozeb (2.5 g/liter)\n\nApply from bud break through early summer',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'Medium',
    ),

    // ============================================
    // SORGHUM DISEASES
    // ============================================
    'sorghum_anthracnose': const Disease(
      name: 'Sorghum Anthracnose',
      description:
          'Anthracnose is a fungal disease affecting sorghum leaves, stalks, and heads, causing significant yield losses.',
      symptoms:
          'Circular to oval lesions on leaves\n\nLesions with tan centers and reddish-purple borders\n\nStalk rot and lodging\n\nHead infection reducing grain quality\n\nYield losses up to 50%',
      remedies: [
        Remedy(
          id: 'sorghum_anthracnose_control',
          preventiveMeasures:
              'Plant resistant varieties\n\nCrop rotation\n\nRemove infected plant debris\n\nAvoid excessive nitrogen\n\nMaintain balanced nutrition',
          biologicalControl:
              'Apply Trichoderma viride\n\nUse Bacillus subtilis',
          chemicalControl:
              'Spray Mancozeb (2.5 g/liter) or Propiconazole (1 ml/liter)\n\nApply at first sign and repeat at 10-14 day intervals',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),

    'sorghum_downy_mildew': const Disease(
      name: 'Sorghum Downy Mildew',
      description:
          'Downy mildew is a systemic disease causing stunting and reduced grain production in sorghum.',
      symptoms:
          'Yellowing and striping of leaves\n\nStunted plant growth\n\nExcessive tillering\n\nWhite downy growth on lower leaf surface\n\nReduced or no grain production',
      remedies: [
        Remedy(
          id: 'sorghum_downy_mildew_control',
          preventiveMeasures:
              'Use disease-free seeds\n\nPlant resistant varieties\n\nSeed treatment with fungicides\n\nRemove infected plants\n\nCrop rotation',
          biologicalControl:
              'Seed treatment with Trichoderma viride\n\nLimited biological control for systemic disease',
          chemicalControl:
              'Seed treatment with Metalaxyl (2 g/kg seed)\n\nFoliar spray with Metalaxyl + Mancozeb (2 g/liter)',
        ),
      ],
      details: [],
      imageUrl: '',
      severity: 'High',
    ),
  };

  /// Get disease details by AI model output name
  static Disease? getDiseaseByAiName(String aiName) {
    final normalizedName = aiName.trim().toLowerCase();
    return diseases[normalizedName];
  }

  /// Get all detectable diseases
  static List<Disease> getAllDiseases() {
    return diseases.values.toList();
  }

  /// Get diseases by crop
  static List<Disease> getDiseasesByCrop(String crop) {
    final cropLower = crop.toLowerCase();
    return diseases.entries
        .where((entry) => entry.key.startsWith('${cropLower}_'))
        .map((entry) => entry.value)
        .toList();
  }

  /// Get list of supported crops
  static List<String> getSupportedCrops() {
    return [
      'sugarcane',
      'rice',
      'corn',
      'cotton',
      'peanut',
      'tomato',
      'eggplant',
      'pepper',
      'apple',
      'sorghum',
    ];
  }
}
