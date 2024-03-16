export 'models.dart';

class Manifest {
  final Latest latest;
  final Versions versions;

  const Manifest({
    required this.latest,
    required this.versions,
  });

  factory Manifest.fromJson(json) {
      // final latests = json['latest'] as Object?;
    return Manifest(
      // latest: latests != null ? latests.map((latests) => Latest.fromJson(latests as Map<String, dynamic>)).toList() : <Latest>[],
      latest: Latest.fromJson(json['latest']),
      // latest: json['latest'] as List<dynamic>,
      versions: Versions.fromJson(json['versions']),
    );
  }
}

class Latest {
  final String release;
  final String snapshot;

  const Latest({
    required this.release,
    required this.snapshot,
  });
  
  factory Latest.fromJson(json) {
    return Latest(
      release: json['release'] as String,
      snapshot: json['snapshot'] as String,
    );
  }
}

class Versions {
  final Version version;

  const Versions({
    required this.version,
  });
  
  factory Versions.fromJson(json) {
    return Versions(
      version: Version.fromJson(json[0]),
    );
  }
}

class Version {
  final String id;
  final String type;
  final String url;
  final String time;
  final String releaseTime;
  final String sha1;
  final int complianceLevel;

  const Version({
    required this.id,
    required this.type,
    required this.url,
    required this.time,
    required this.releaseTime,
    required this.sha1,
    required this.complianceLevel,
  });
  
  factory Version.fromJson(json) {
    return Version(
      id: json['id'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
      time: json['time'] as String,
      releaseTime: json['releaseTime'] as String,
      sha1: json['sha1'] as String,
      complianceLevel: json['complianceLevel'] as int,
    );
  }
}
