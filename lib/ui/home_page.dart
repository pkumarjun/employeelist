import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:employeeapp/helpers/api_helper.dart';
import 'package:employeeapp/helpers/db/employee_dao.dart';
import 'package:employeeapp/helpers/employee_model.dart';
import 'package:employeeapp/helpers/image_utility.dart';
import 'package:employeeapp/ui/details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Home page for showing employee list
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // controller for search field
  TextEditingController _controller = TextEditingController();
  // helper for api call
  ApiHelper _apiHelper = ApiHelper();
  // List of employee data
  EmployeeDetailsList? _employeeList, _searchedUsers;
  // flags for loading and search
  bool isLoading = true, _isSearching = false;
  // DAO for db
  EmployeeDAO _employeeDAO = EmployeeDAO();
  // List to catch offline data
  List<EmployeeDetailsList>? empList;

  void initState() {
    super.initState();
    _searchedUsers = _employeeList;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(),
        body: !isLoading
            ? _searchedUsers!.employeeDetails!.length > 0
                ? ListView.builder(
                    itemCount: _searchedUsers!.employeeDetails!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          _navigateToDetailsScreen(
                              _searchedUsers!.employeeDetails![index], index);
                        },
                        child: Card(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                            child: ListTile(
                              leading: Hero(
                                tag: 'image$index',
                                child: _searchedUsers!.employeeDetails![index]
                                            .profileImage! !=
                                        "- NA -"
                                    ? CircleAvatar(
                                        backgroundImage:
                                            ImageUtility.imageFromBase64String(
                                                    _searchedUsers!
                                                        .employeeDetails![index]
                                                        .profileImage!)
                                                .image)
                                    : CircleAvatar(
                                        child: Text(
                                          "- NA -",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                              ),
                              title: Text(
                                _searchedUsers!.employeeDetails![index].name!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                _searchedUsers!
                                    .employeeDetails![index].company!.name!,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'No employees found',
                      style: TextStyle(fontSize: 24),
                    ),
                  )
            : Center(
                child: Platform.isAndroid
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator(),
              ),
      ),
    );
  }

  showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  static Future<bool> checkNetworkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else
      return true;
  }

  loadData() async {
    showLoading();
    bool isNetworkAvailable =
        await checkNetworkConnection(); // for network check
    if (isNetworkAvailable) {
      // Online Fetch
      showToast(
        "Online",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      empList = await _employeeDAO.getAllRecords(); // retrive all records
      // if data is available in DB, api call is not happening
      if (empList!.isEmpty) {
        _employeeList = await _apiHelper.fetchEmployeeDetails();
        for (int i = 0; i < _employeeList!.employeeDetails!.length; i++) {
          _employeeList!.employeeDetails![i].profileImage =
              await ImageUtility.getImageFromNetwork(
                  _employeeList!.employeeDetails![i].profileImage);
        }
        _employeeDAO.insert(_employeeList!); // Insert to DB
      } else {
        _employeeList = empList![0];
      }

      _searchedUsers = _employeeList;
      hideLoading();
    } else {
      // Offline Fetch
      showToast(
        "Offline",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      empList = await _employeeDAO.getAllRecords();
      if (empList!.isEmpty) {
        _employeeList = EmployeeDetailsList();
        _employeeList!.employeeDetails = <EmployeeDetails>[];
      } else {
        _employeeList = empList![0];
      }

      _searchedUsers = _employeeList;
      hideLoading();
    }
  }

  PreferredSizeWidget customAppBar() {
    return AppBar(
      title: _isSearching ? _buildSearchField() : Text("Employee List"),
      actions: _buildActions(),
      centerTitle: true,
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      cursorColor: Colors.white,
      controller: _controller,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search here ...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white38),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (value) => _updateSearchQuery(value),
    );
  }

  void _updateSearchQuery(String newQuery) {
    _searchedUsers = _employeeList;
    EmployeeDetailsList? results = EmployeeDetailsList();
    if (newQuery.isEmpty) {
      // if the search field is empty or only contains white-space, display all employees
      results = _searchedUsers!;
    } else {
      results.employeeDetails = _searchedUsers!.employeeDetails!
          .where(
            (user) => user.name!.toLowerCase().contains(
                  newQuery.toLowerCase(),
                ),
          )
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _searchedUsers = results;
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_controller.text.isEmpty) {
              setState(() {
                _isSearching = false;
                _searchedUsers = _employeeList;
              });
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.sync),
        onPressed: () {
          loadData();
        },
      ),
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _controller.clear();
      _searchedUsers = _employeeList;
    });
  }

  void _navigateToDetailsScreen(EmployeeDetails details, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          details: details,
          index: index,
        ),
      ),
    );
  }

  showToast(String message,
      {Toast? toastLength = Toast.LENGTH_LONG,
      ToastGravity? gravity = ToastGravity.BOTTOM,
      Color? backgroundColor = Colors.green,
      Color? textColor = Colors.white,
      double? fontSize = 16.0}) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength,
        gravity: gravity,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize);
  }
}
