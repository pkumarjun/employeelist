import 'dart:ui';

import 'package:employeeapp/helpers/employee_model.dart';
import 'package:employeeapp/helpers/image_utility.dart';
import 'package:flutter/material.dart';

// Detail Page for showing Employee details
class DetailsScreen extends StatelessWidget {
  final EmployeeDetails? details;
  final int? index;
  const DetailsScreen({Key? key, this.details, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Employee Details"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ProfilePhoto(
                index: index,
                details: details,
              ),
              ProfileDetails(
                details: details,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  final EmployeeDetails? details;
  const ProfileDetails({Key? key, this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DetailsRow(
                rowName: "Name",
                rowContent: details!.name,
              ),
              DetailsRow(
                rowName: "User Name",
                rowContent: details!.username,
              ),
              DetailsRow(rowName: "Email Address", rowContent: details!.email),
              DetailsRow(
                rowName: "Address",
                rowContent: details!.address!.street! +
                    ", \n" +
                    details!.address!.suite! +
                    ", \n" +
                    details!.address!.city! +
                    ", \n" +
                    details!.address!.zipcode! +
                    ", \nLat : " +
                    details!.address!.geo!.lat! +
                    ", \nLong : " +
                    details!.address!.geo!.lng!,
              ),
              DetailsRow(rowName: "Phone", rowContent: details!.phone),
              DetailsRow(rowName: "Website", rowContent: details!.website),
              DetailsRow(
                rowName: "Company",
                rowContent: getCompanyDetails(details),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String getCompanyDetails(details) {
  String company = "";
  if (details!.company!.name! != "") {
    company = details!.company!.name!;
    if (details!.company!.catchPhrase! != "") {
      company += ", \n" + details!.company!.catchPhrase!;
    }
    if (details!.company!.bs! != "") {
      company += ", \n" + details!.company!.bs!;
    }
  } else {
    company = "- NA -";
  }
  return company;
}

class DetailsRow extends StatelessWidget {
  final String? rowName;
  final String? rowContent;
  const DetailsRow({Key? key, this.rowName, this.rowContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              // color: Colors.orange,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                rowName!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.center,
              // color: Colors.blue,
              width: MediaQuery.of(context).size.width * 0.1,
              child: Text(
                ":",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              // color: Colors.grey,
              width: MediaQuery.of(context).size.width * 0.43,
              child: Text(
                rowContent!,
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

class ProfilePhoto extends StatelessWidget {
  final int? index;
  final EmployeeDetails? details;
  const ProfilePhoto({Key? key, this.index, this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      child: Card(
        // elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Hero(
              tag: 'image$index',
              child: details!.profileImage! != "- NA -"
                  ? CircleAvatar(
                      radius: 110,
                      backgroundImage: ImageUtility.imageFromBase64String(
                              details!.profileImage!)
                          .image,
                    )
                  : CircleAvatar(
                      radius: 110,
                      child: Text(
                        "- NA -",
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
