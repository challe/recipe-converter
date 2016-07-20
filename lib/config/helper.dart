part of config;

class ConfigHelper {
  static List<String> getMeasurements() {
    List<String> measurements = new List<String>();

    config["measurements"].forEach((text) {
      measurements.add(text["sv"]);
    });

    return measurements;
  }

  static List<String> getReplacementTypes() {
    List<String> conversionTypes = new List<String>();
    config["replacements"].keys.forEach((replacement) {
      conversionTypes.add(replacement);
    });
    return conversionTypes;
  }
}
