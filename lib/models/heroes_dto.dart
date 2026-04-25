import 'dart:convert';


Heroes heroesFromJson(String str) => Heroes.fromJson(json.decode(str));

String heroesToJson(Heroes data) => json.encode(data.toJson());

class Heroes {
    final String response;
    final String id;
    final String name;
    final Powerstats powerstats;
    final Biography biography;
    final Appearance appearance;
    final Work work;
    final Connections connections;
    final HeroImage heroImage;

    Heroes({
        required this.response,
        required this.id,
        required this.name,
        required this.powerstats,
        required this.biography,
        required this.appearance,
        required this.work,
        required this.connections,
        required this.heroImage,
    });

    factory Heroes.fromJson(Map<String, dynamic> json) => Heroes(
        response: json["response"],
        id: json["id"],
        name: json["name"],
        powerstats: Powerstats.fromJson(json["powerstats"]),
        biography: Biography.fromJson(json["biography"]),
        appearance: Appearance.fromJson(json["appearance"]),
        work: Work.fromJson(json["work"]),
        connections: Connections.fromJson(json["connections"]),
        heroImage: HeroImage.fromJson(json["image"]),
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "id": id,
        "name": name,
        "powerstats": powerstats.toJson(),
        "biography": biography.toJson(),
        "appearance": appearance.toJson(),
        "work": work.toJson(),
        "connections": connections.toJson(),
        "image": heroImage.toJson(),
    };

}

class Appearance {
    final String gender;
    final String race;
    final List<String> height;
    final List<String> weight;
    final String eyeColor;
    final String hairColor;

    Appearance({
        required this.gender,
        required this.race,
        required this.height,
        required this.weight,
        required this.eyeColor,
        required this.hairColor,
    });

    factory Appearance.fromJson(Map<String, dynamic> json) => Appearance(
        gender: json["gender"],
        race: json["race"],
        height: List<String>.from(json["height"].map((x) => x)),
        weight: List<String>.from(json["weight"].map((x) => x)),
        eyeColor: json["eye-color"],
        hairColor: json["hair-color"],
    );

    Map<String, dynamic> toJson() => {
        "gender": gender,
        "race": race,
        "height": List<dynamic>.from(height.map((x) => x)),
        "weight": List<dynamic>.from(weight.map((x) => x)),
        "eye-color": eyeColor,
        "hair-color": hairColor,
    };

    List<Map<String, dynamic>> get stats => [
        {"label":"gender", "value":gender},
        {"label":"race", "value":race},
        {"label":"height", "value":height},
        {"label":"weight", "value":weight},
        {"label":"eyeColor", "value":eyeColor},
        {"label":"hairColor", "value":hairColor},
    ];
}

class Biography {
    final String fullName;
    final String alterEgos;
    final List<String> aliases;
    final String placeOfBirth;
    final String firstAppearance;
    final String publisher;
    final String alignment;

    Biography({
        required this.fullName,
        required this.alterEgos,
        required this.aliases,
        required this.placeOfBirth,
        required this.firstAppearance,
        required this.publisher,
        required this.alignment,
    });

    factory Biography.fromJson(Map<String, dynamic> json) => Biography(
        fullName: json["full-name"],
        alterEgos: json["alter-egos"],
        aliases: List<String>.from(json["aliases"].map((x) => x)),
        placeOfBirth: json["place-of-birth"],
        firstAppearance: json["first-appearance"],
        publisher: json["publisher"],
        alignment: json["alignment"],
    );

    Map<String, dynamic> toJson() => {
        "full-name": fullName,
        "alter-egos": alterEgos,
        "aliases": List<dynamic>.from(aliases.map((x) => x)),
        "place-of-birth": placeOfBirth,
        "first-appearance": firstAppearance,
        "publisher": publisher,
        "alignment": alignment,
    };
    List<Map<String, dynamic>> get stats => [
        {"label":"fullName", "value":fullName},
        {"label":"alterEgos", "value":alterEgos},
        {"label":"aliases", "value":aliases},
        {"label":"placeOfBirth", "value":placeOfBirth},
        {"label":"firstAppearance", "value":firstAppearance},
        {"label":"publisher", "value":publisher},
        {"label":"alignment", "value":alignment},
    ];
}

class Connections {
    final String groupAffiliation;
    final String relatives;

    Connections({
        required this.groupAffiliation,
        required this.relatives,
    });

    factory Connections.fromJson(Map<String, dynamic> json) => Connections(
        groupAffiliation: json["group-affiliation"],
        relatives: json["relatives"],
    );

    Map<String, dynamic> toJson() => {
        "group-affiliation": groupAffiliation,
        "relatives": relatives,
    };

    List<Map<String, dynamic>> get stats => [
        {"label":"groupAffiliation", "value":groupAffiliation},
        {"label":"relatives", "value":relatives}
    ];

}

class HeroImage {
    final String url;

    HeroImage({
        required this.url,
    });

    factory HeroImage.fromJson(Map<String, dynamic> json) => HeroImage(
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
    };

    List<Map<String, dynamic>> get stats => [
        {"label":"url", "value":url},
    ];
}

class Powerstats {
    final String intelligence;
    final String strength;
    final String speed;
    final String durability;
    final String power;
    final String combat;

    Powerstats({
        required this.intelligence,
        required this.strength,
        required this.speed,
        required this.durability,
        required this.power,
        required this.combat,
    });

    factory Powerstats.fromJson(Map<String, dynamic> json) => Powerstats(
        intelligence: json["intelligence"],
        strength: json["strength"],
        speed: json["speed"],
        durability: json["durability"],
        power: json["power"],
        combat: json["combat"],
    );

    Map<String, dynamic> toJson() => {
        "intelligence": intelligence,
        "strength": strength,
        "speed": speed,
        "durability": durability,
        "power": power,
        "combat": combat,
    };

    List<Map<String, dynamic>> get stats => [
        {"label":"intelligence", "value":intelligence},
        {"label":"strength", "value":strength},
        {"label":"speed", "value":speed},
        {"label":"durability", "value":durability},
        {"label":"power", "value":power},
        {"label":"combat", "value":combat},
    ];

    
}

class Work {
    final String occupation;
    final String base;

    Work({
        required this.occupation,
        required this.base,
    });

    factory Work.fromJson(Map<String, dynamic> json) => Work(
        occupation: json["occupation"],
        base: json["base"],
    );

    Map<String, dynamic> toJson() => {
        "occupation": occupation,
        "base": base,
    };

    List<Map<String,dynamic>> get stats => [
      {"label":"occupation","value":occupation},
      {"label":"base","value":base}
    ];
}
