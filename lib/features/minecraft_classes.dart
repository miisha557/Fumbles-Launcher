class Manifest {
  Latest? latest;
  List<Version>? versions;

  Manifest({
    required this.latest,
    this.versions,
  });

  Manifest.fromJson(json) {
      latest = Latest.fromJson(json['latest']);
      versions = <Version>[];
      json['versions'].forEach((v) {
        versions!.add(Version.fromJson(v));
      });
  }
}

class OurManifest {
  List<Version>? versions;

  OurManifest({
    this.versions,
  });

  OurManifest.fromJson(json) {
      versions = <Version>[];
      json['versions'].forEach((v) {
        versions!.add(Version.fromJson(v));
      });
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
      url:json['url'] as String,
      time: json['time'] as String,
      releaseTime: json['releaseTime'] as String,
      sha1: json['sha1'] as String,
      complianceLevel: json['complianceLevel'] as int,
    );
  }
}

class Package {
  Arguments? arguments;
  AssetIndex? assetIndex;
  String? assets;
  int? complianceLevel;
  DownloadsMappings? downloads;
  String? id;
  JavaVersion? javaVersion;
  List<Libraries>? libraries;
  Logging? logging;
  String? mainClass;
  int? minimumLauncherVersion;
  String? releaseTime;
  String? time;
  String? type;

  Package(
      {this.arguments,
      this.assetIndex,
      this.assets,
      this.complianceLevel,
      this.downloads,
      this.id,
      this.javaVersion,
      this.libraries,
      this.logging,
      this.mainClass,
      this.minimumLauncherVersion,
      this.releaseTime,
      this.time,
      this.type});

  Package.fromJson(Map<String, dynamic> json) {
    arguments = json['arguments'] != null
        ? Arguments.fromJson(json['arguments'])
        : null;
    assetIndex = json['assetIndex'] != null
        ? AssetIndex.fromJson(json['assetIndex'])
        : null;
    assets = json['assets'];
    complianceLevel = json['complianceLevel'];
    downloads = json['downloads'] != null
        ? DownloadsMappings.fromJson(json['downloads'])
        : null;
    id = json['id'];
    javaVersion = json['javaVersion'] != null
        ? JavaVersion.fromJson(json['javaVersion'])
        : null;
    if (json['libraries'] != null) {
      libraries = <Libraries>[];
      json['libraries'].forEach((v) {
        libraries!.add(Libraries.fromJson(v));
      });
    }
    logging =
        json['logging'] != null ? Logging.fromJson(json['logging']) : null;
    mainClass = json['mainClass'];
    minimumLauncherVersion = json['minimumLauncherVersion'];
    releaseTime = json['releaseTime'];
    time = json['time'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (arguments != null) {
      data['arguments'] = arguments!.toJson();
    }
    if (assetIndex != null) {
      data['assetIndex'] = assetIndex!.toJson();
    }
    data['assets'] = assets;
    data['complianceLevel'] = complianceLevel;
    if (downloads != null) {
      data['downloads'] = downloads!.toJson();
    }
    data['id'] = id;
    if (javaVersion != null) {
      data['javaVersion'] = javaVersion!.toJson();
    }
    if (libraries != null) {
      data['libraries'] = libraries!.map((v) => v.toJson()).toList();
    }
    if (logging != null) {
      data['logging'] = logging!.toJson();
    }
    data['mainClass'] = mainClass;
    data['minimumLauncherVersion'] = minimumLauncherVersion;
    data['releaseTime'] = releaseTime;
    data['time'] = time;
    data['type'] = type;
    return data;
  }
}

class Arguments {
  List<String>? game;
  List? jvm;

  Arguments({this.game, this.jvm});

  Arguments.fromJson(Map<String, dynamic> json) {
    game = json['game'].cast<String>();
    if (json['jvm'] != null) {
      jvm = [];
      json['jvm'].forEach((v) {
        jvm!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['game'] = game;
    if (jvm != null) {
      data['jvm'] = jvm!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rules {
  String? action;
  Os? os;

  Rules({this.action, this.os});

  Rules.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    os = json['os'] != null ? Os.fromJson(json['os']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action'] = action;
    if (os != null) {
      data['os'] = os!.toJson();
    }
    return data;
  }
}

class Os {
  String? name;

  Os({this.name});

  Os.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class AssetIndex {
  String? id;
  String? sha1;
  int? size;
  int? totalSize;
  String? url;

  AssetIndex({this.id, this.sha1, this.size, this.totalSize, this.url});

  AssetIndex.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sha1 = json['sha1'];
    size = json['size'];
    totalSize = json['totalSize'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sha1'] = sha1;
    data['size'] = size;
    data['totalSize'] = totalSize;
    data['url'] = url;
    return data;
  }
}

class DownloadsMappings {
  ClientMapping? client;
  ClientMapping? clientMappings;
  ClientMapping? server;
  ClientMapping? serverMappings;

  DownloadsMappings(
      {this.client, this.clientMappings, this.server, this.serverMappings});

  DownloadsMappings.fromJson(Map<String, dynamic> json) {
    client = json['client'] != null ? ClientMapping.fromJson(json['client']) : null;
    clientMappings = json['client_mappings'] != null
        ? ClientMapping.fromJson(json['client_mappings'])
        : null;
    server =
        json['server'] != null ? ClientMapping.fromJson(json['server']) : null;
    serverMappings = json['server_mappings'] != null
        ? ClientMapping.fromJson(json['server_mappings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (client != null) {
      data['client'] = client!.toJson();
    }
    if (clientMappings != null) {
      data['client_mappings'] = clientMappings!.toJson();
    }
    if (server != null) {
      data['server'] = server!.toJson();
    }
    if (serverMappings != null) {
      data['server_mappings'] = serverMappings!.toJson();
    }
    return data;
  }
}

class ClientMapping {
  String? sha1;
  int? size;
  String? url;

  ClientMapping({this.sha1, this.size, this.url});

  ClientMapping.fromJson(Map<String, dynamic> json) {
    sha1 = json['sha1'];
    size = json['size'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sha1'] = sha1;
    data['size'] = size;
    data['url'] = url;
    return data;
  }
}

class JavaVersion {
  String? component;
  int? majorVersion;

  JavaVersion({this.component, this.majorVersion});

  JavaVersion.fromJson(Map<String, dynamic> json) {
    component = json['component'];
    majorVersion = json['majorVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['component'] = component;
    data['majorVersion'] = majorVersion;
    return data;
  }
}

class Libraries {
  DownloadsArtifact? downloads;
  String? name;
  List<Rules>? rules;

  Libraries({this.downloads, this.name, this.rules});

  Libraries.fromJson(Map<String, dynamic> json) {
    downloads = json['downloads'] != null
        ? DownloadsArtifact.fromJson(json['downloads'])
        : null;
    name = json['name'];
    if (json['rules'] != null) {
      rules = <Rules>[];
      json['rules'].forEach((v) {
        rules!.add(Rules.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (downloads != null) {
      data['downloads'] = downloads!.toJson();
    }
    data['name'] = name;
    if (rules != null) {
      data['rules'] = rules!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DownloadsArtifact {
  Artifact? artifact;

  DownloadsArtifact({this.artifact});

  DownloadsArtifact.fromJson(Map<String, dynamic> json) {
    artifact = json['artifact'] != null
        ? Artifact.fromJson(json['artifact'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (artifact != null) {
      data['artifact'] = artifact!.toJson();
    }
    return data;
  }
}

class Artifact {
  String? path;
  String? sha1;
  int? size;
  String? url;

  Artifact({this.path, this.sha1, this.size, this.url});

  Artifact.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    sha1 = json['sha1'];
    size = json['size'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path'] = path;
    data['sha1'] = sha1;
    data['size'] = size;
    data['url'] = url;
    return data;
  }
}

class Logging {
  ClientLogging? client;

  Logging({this.client});

  Logging.fromJson(Map<String, dynamic> json) {
    client =
        json['client'] != null ? ClientLogging.fromJson(json['client']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (client != null) {
      data['client'] = client!.toJson();
    }
    return data;
  }
}

class ClientLogging {
  String? argument;
  File? file;
  String? type;

  ClientLogging({this.argument, this.file, this.type});

  ClientLogging.fromJson(Map<String, dynamic> json) {
    argument = json['argument'];
    file = json['file'] != null ? File.fromJson(json['file']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['argument'] = argument;
    if (file != null) {
      data['file'] = file!.toJson();
    }
    data['type'] = type;
    return data;
  }
}

class File {
  String? id;
  String? sha1;
  int? size;
  String? url;

  File({this.id, this.sha1, this.size, this.url});

  File.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sha1 = json['sha1'];
    size = json['size'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sha1'] = sha1;
    data['size'] = size;
    data['url'] = url;
    return data;
  }
}


class Assets {
  Map<String, dynamic> objects;
  
  Assets({required this.objects});
  factory Assets.fromJson(json) {
    return Assets(objects: json['objects']);
  }
}

class Asset {
  final String hash;
  final int size;
  
  Asset({required this.hash, required this.size});
  
  factory Asset.fromJson(json) {
    return Asset(
      hash: json['hash'] as String,
      size: json['size'] as int,
    );
  }
}
