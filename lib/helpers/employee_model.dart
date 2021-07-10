//Model class for employee data
class EmployeeDetailsList {
  List<EmployeeDetails>? employeeDetails;
  String? itemKey;
  EmployeeDetailsList({this.employeeDetails, this.itemKey});

  EmployeeDetailsList.fromJson(List<dynamic> json) {
    if (json.length > 0) {
      employeeDetails = <EmployeeDetails>[];
      json.forEach(
        (pobDetails) {
          employeeDetails!.add(
            EmployeeDetails.fromJson(pobDetails),
          );
        },
      );
    }
  }

  ///For offline fetch
  EmployeeDetailsList.fromMap(Map<String, dynamic> json) {
    if (json['employeeDetails'] != null) {
      employeeDetails = <EmployeeDetails>[];
      json['employeeDetails'].forEach((v) {
        employeeDetails!.add(new EmployeeDetails.fromJson(v));
      });
      itemKey = json['itemKey'];
    }
  }

  ///For offline insert
  Map<String, dynamic> toJson() {
    final List employeeDetailsList = [];
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (employeeDetails != null) {
      for (int i = 0; i < employeeDetails!.length; i++) {
        employeeDetailsList.add(
          employeeDetails![i].toJson(),
        );
      }
      data['employeeDetails'] = employeeDetailsList;
    } else {
      data['employeeDetails'] = null;
    }
    if (itemKey == null) {
      data['itemKey'] = "detailskey";
    } else {
      data['itemKey'] = itemKey;
    }
    return data;
  }
}

class EmployeeDetails {
  int? id;
  String? name;
  String? username;
  String? email;
  String? profileImage;
  Address? address;
  String? phone;
  String? website;
  Company? company;

  EmployeeDetails(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.profileImage,
      this.address,
      this.phone,
      this.website,
      this.company});

  EmployeeDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "- NA -";
    name = json['name'] ?? "- NA -";
    username = json['username'] ?? "- NA -";
    email = json['email'] ?? "- NA -";
    profileImage = json['profile_image'] ?? "- NA -";
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    phone = json['phone'] ?? "- NA -";
    website = json['website'] ?? "- NA -";
    if (json['company'] != null) {
      company = Company.fromJson(json['company']);
    } else {
      final Map<String, dynamic> zoneMapForNull = {
        "ou": "- NA -",
        "itemCode": "- NA -",
        "itemName": "- NA -"
      };
      company = Company.fromJson(zoneMapForNull);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['profile_image'] = this.profileImage;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['phone'] = this.phone;
    data['website'] = this.website;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    return data;
  }
}

class Address {
  String? street;
  String? suite;
  String? city;
  String? zipcode;
  Geo? geo;

  Address({this.street, this.suite, this.city, this.zipcode, this.geo});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'] ?? "";
    suite = json['suite'] ?? "";
    city = json['city'] ?? "";
    zipcode = json['zipcode'] ?? "";
    geo = json['geo'] != null ? new Geo.fromJson(json['geo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street'] = this.street;
    data['suite'] = this.suite;
    data['city'] = this.city;
    data['zipcode'] = this.zipcode;
    if (this.geo != null) {
      data['geo'] = this.geo!.toJson();
    }
    return data;
  }
}

class Geo {
  String? lat;
  String? lng;

  Geo({this.lat, this.lng});

  Geo.fromJson(Map<String, dynamic> json) {
    lat = json['lat'] ?? "";
    lng = json['lng'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Company {
  String? name;
  String? catchPhrase;
  String? bs;

  Company({this.name, this.catchPhrase, this.bs});

  Company.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "- NA -";
    catchPhrase = json['catchPhrase'] ?? "";
    bs = json['bs'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['catchPhrase'] = this.catchPhrase;
    data['bs'] = this.bs;
    return data;
  }
}
