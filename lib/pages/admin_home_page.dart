import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/components/request_card.dart';
import 'package:helloworld/pages/all_flight_areas_map.dart';
import 'package:helloworld/pages/flight_request_page.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('flight_info')
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return RequestCard(
                      model: snapshot.data.docs[index]['model'],
                      duration: snapshot.data.docs[index]['duration'].toDate(),
                      index: (index + 1).toString(),
                      accepted: snapshot.data.docs[index]['accepted'],
                      docID: snapshot.data.docs[index].id,
                    );
                  },
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Main Page"),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllFlightAreasMap()),
            );
          },
          icon: Icon(Icons.map),
        ),
      ],
    );
  }
}
