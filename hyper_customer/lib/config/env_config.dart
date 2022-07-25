class EnvConfig {
  final String baseUrl;
  final String mapboxUrlTemplate;
  final String mapboxNavigationUrlTemplate;
  final String mapboxAccessToken;
  final String mapboxId;

  EnvConfig({
    required this.baseUrl,
    this.mapboxUrlTemplate = '',
    this.mapboxNavigationUrlTemplate = '',
    this.mapboxAccessToken = '',
    this.mapboxId = '',
  });
}
