/// This file holds the static database for all disease recommendations,
/// just like in your Colab notebook.

const Map<String, Map<String, List<String>>> diseaseRecommendations = {
  // HEALTHY
  "Healthy": {
    "fertilizers": [
      "Balanced NPK fertilizer (10-10-10)",
      "Organic compost or vermicompost",
      "Seaweed or kelp-based fertilizer",
    ],
    "treatments": [
      "Continue regular watering schedule",
      "Maintain current care routine",
      "Monitor plant regularly for any changes",
    ],
    "prevention": [
      "Ensure 6-8 hours of sunlight daily",
      "Maintain proper soil drainage",
      "Keep growing area clean and free of debris",
    ],
  },

  // BLIGHT DISEASES
  "Early_Blight": {
    "fertilizers": [
      "Potassium-rich fertilizer (0-0-60)",
      "Copper-based fungicide",
      "Calcium nitrate spray",
    ],
    "treatments": [
      "Remove and destroy infected leaves immediately",
      "Apply fungicide every 7-10 days",
      "Improve air circulation around plants",
      "Water at base of plant, avoid wetting leaves",
    ],
    "prevention": [
      "Practice crop rotation (3-4 year cycle)",
      "Use disease-resistant varieties",
      "Maintain proper plant spacing",
      "Mulch to prevent soil splash",
    ],
  },

  "Late_Blight": {
    "fertilizers": [
      "Calcium-rich fertilizer",
      "Mancozeb or Chlorothalonil fungicide",
      "Reduce nitrogen if excessive",
    ],
    "treatments": [
      "Apply fungicide immediately upon detection",
      "Remove and destroy infected plants",
      "Reduce humidity around plants",
      "Stop overhead watering",
    ],
    "prevention": [
      "Plant resistant varieties",
      "Ensure adequate plant spacing",
      "Monitor weather for blight-favorable conditions",
      "Remove volunteer plants",
    ],
  },

  // LEAF SPOT
  "Leaf_Spot": {
    "fertilizers": [
      "Balanced fertilizer with micronutrients",
      "Copper fungicide spray",
      "Neem oil solution",
    ],
    "treatments": [
      "Remove infected leaves",
      "Apply fungicide as directed",
      "Improve air circulation",
      "Avoid overhead irrigation",
    ],
    "prevention": [
      "Water at soil level",
      "Practice crop rotation",
      "Space plants properly",
      "Remove plant debris regularly",
    ],
  },

  "Bacterial_Spot": {
    "fertilizers": [
      "Copper hydroxide spray",
      "Avoid high-nitrogen fertilizers",
      "Calcium-based products",
    ],
    "treatments": [
      "Apply copper-based bactericide",
      "Remove severely infected plants",
      "Disinfect tools after use",
      "Avoid working with wet plants",
    ],
    "prevention": [
      "Use disease-free seeds",
      "Rotate crops annually",
      "Avoid overhead watering",
      "Maintain plant health with balanced nutrition",
    ],
  },

  "Powdery_Mildew": {
    "fertilizers": [
      "Sulfur-based fungicide",
      "Potassium bicarbonate spray",
      "Neem oil solution",
    ],
    "treatments": [
      "Apply fungicide at first sign",
      "Prune affected areas",
      "Increase air circulation",
      "Apply baking soda solution (1 tbsp per gallon)",
    ],
    "prevention": [
      "Plant in full sun locations",
      "Space plants adequately",
      "Avoid excess nitrogen",
      "Water in morning hours",
    ],
  },

  "Mosaic_Virus": {
    "fertilizers": [
      "Balanced NPK (10-10-10)",
      "Zinc and iron supplements",
      "Organic compost tea",
    ],
    "treatments": [
      "No cure - remove infected plants",
      "Control aphid populations",
      "Disinfect all tools",
      "Isolate infected plants immediately",
    ],
    "prevention": [
      "Use virus-resistant varieties",
      "Control insect vectors (aphids, thrips)",
      "Remove weeds that harbor virus",
      "Use certified disease-free seeds",
    ],
  },

  "Septoria_Leaf_Spot": {
    "fertilizers": [
      "Copper fungicide",
      "Balanced fertilizer with calcium",
      "Avoid excess nitrogen",
    ],
    "treatments": [
      "Remove lower infected leaves",
      "Apply fungicide weekly",
      "Mulch to prevent soil splash",
      "Stake plants for better air flow",
    ],
    "prevention": [
      "Rotate crops (3-4 years)",
      "Space plants 2-3 feet apart",
      "Water at base only",
      "Clean up plant debris in fall",
    ],
  },

  "Yellow_Leaf_Curl": {
    "fertilizers": [
      "Micronutrient fertilizer",
      "Insecticidal soap for whiteflies",
      "Neem oil spray",
    ],
    "treatments": [
      "Control whitefly population immediately",
      "Remove and destroy infected plants",
      "Use reflective mulches",
      "Apply systemic insecticides if needed",
    ],
    "prevention": [
      "Use resistant varieties",
      "Install insect screens",
      "Remove weeds that harbor whiteflies",
      "Plant early to avoid peak whitefly season",
    ],
  },

  "Target_Spot": {
    "fertilizers": [
      "Potassium-rich fertilizer",
      "Copper fungicide",
      "Avoid excessive nitrogen",
    ],
    "treatments": [
      "Apply fungicide every 7-14 days",
      "Remove infected lower leaves",
      "Improve drainage",
      "Increase plant spacing",
    ],
    "prevention": [
      "Use drip irrigation",
      "Mulch around plants",
      "Rotate with non-host crops",
      "Maintain proper plant nutrition",
    ],
  },

  "Fungal_Disease": {
    "fertilizers": [
      "Copper-based fungicide",
      "Sulfur dust or spray",
      "Potassium-rich fertilizer",
    ],
    "treatments": [
      "Apply appropriate fungicide",
      "Remove infected plant parts",
      "Improve air circulation",
      "Reduce humidity",
    ],
    "prevention": [
      "Avoid overhead watering",
      "Space plants properly",
      "Remove plant debris",
      "Use disease-resistant varieties",
    ],
  },
};

/// Helper function to get recommendations for a given disease name.
/// This includes the fuzzy matching from your Colab script.
Map<String, List<String>>? getRecommendations(String diseaseName) {
  // 1. Direct match
  if (diseaseRecommendations.containsKey(diseaseName)) {
    return diseaseRecommendations[diseaseName];
  }

  // 2. Fuzzy match (case-insensitive)
  String diseaseLower = diseaseName.toLowerCase();
  for (String key in diseaseRecommendations.keys) {
    String keyLower = key.toLowerCase();
    if (keyLower.contains(diseaseLower) || diseaseLower.contains(keyLower)) {
      return diseaseRecommendations[key];
    }
  }

  // 3. Common term match
  if (diseaseLower.contains('healthy')) {
    return diseaseRecommendations['Healthy'];
  }
  if (diseaseLower.contains('blight')) {
    if (diseaseLower.contains('early')) {
      return diseaseRecommendations['Early_Blight'];
    } else if (diseaseLower.contains('late')) {
      return diseaseRecommendations['Late_Blight'];
    }
  }

  // No match found
  return null;
}
