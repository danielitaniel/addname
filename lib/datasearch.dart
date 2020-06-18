import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  final cities = ["Beirut", "Tripoli", "Tyre", "Sidon", "Byblos", "Jounieh"];
  final recentCities = ["Beirut", "Tripoli"];
  @override

  //ACTIONS FOR APP BAR
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(icon: (Icon(Icons.clear)), onPressed: () {})
    ];
  }

  //LEFT OF APP BAR ICON: EXITS SEARCH
  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      }
      );
  }

  //SHOW RESULTS BASED ON USER REQUEST/INPUT
  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults

  }


  //REAL TIME SUGGESTIONS AS SOON AS USER BEGINGS TYPING
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentCities
        : cities.where((str) => str.startsWith(query)).toList();
    if (suggestionList == recentCities) {
      return ListView.builder(itemBuilder: (context, index) =>
          ListTile(
            leading: Icon(Icons.access_time),
            title: RichText(
              text: TextSpan(
                  text: suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ]
              ),
            ),
          ),
        itemCount: suggestionList.length,
      );
    } else {
        return ListView.builder(itemBuilder: (context, index) =>
            ListTile(
              leading: Icon(Icons.search),
              title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: suggestionList[index].substring(query.length),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ]
                ),
              ),
            ),
          itemCount: suggestionList.length,
        );

    }
  } 
  
}