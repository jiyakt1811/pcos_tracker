class PCOSPredictionRequest {
  final int age;
  final double weight;
  final double height;
  final double bmi;
  final bool weightGain;
  final bool hairGrowth;
  final bool skinDarkening;
  final bool hairLoss;
  final bool pimple;
  final bool fastFood;
  final bool regExercise;
  final double waistHipRatio;

  PCOSPredictionRequest({
    required this.age,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.weightGain,
    required this.hairGrowth,
    required this.skinDarkening,
    required this.hairLoss,
    required this.pimple,
    required this.fastFood,
    required this.regExercise,
    required this.waistHipRatio,
  });

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'weight': weight,
      'height': height,
      'bmi': bmi,
      'weight_gain': weightGain ? 1 : 0,
      'hair_growth': hairGrowth ? 1 : 0,
      'skin_darkening': skinDarkening ? 1 : 0,
      'hair_loss': hairLoss ? 1 : 0,
      'pimple': pimple ? 1 : 0,
      'fast_food': fastFood ? 1 : 0,
      'reg_exercise': regExercise ? 1 : 0,
      'waist_hip_ratio': waistHipRatio,
    };
  }
} 