library config;

part "_config.dart";

class ConfigFunctions {
  static List<String> getMeasurements() {
    List<String> measurements = new List<String>();

    config["measurements"].forEach((text) {
      measurements.add(text["se"]);
    });

    return measurements;
  }
}
