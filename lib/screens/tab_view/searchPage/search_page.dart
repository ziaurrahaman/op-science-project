import 'package:flutter/material.dart';
import 'package:opScienceProject/res/images.dart';
import 'package:opScienceProject/res/screen_size_utils.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  TextEditingController _searchController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: DS.setHeightRatio(0.17),
              width: DS.getWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Text(
                  'Search',
                  style: TextStyle(
                    fontSize: DS.setSP(18),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: DS.setHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0XFFA7A7A7).withOpacity(.18),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontSize: DS.setSP(20),
                  ),
                  decoration: InputDecoration(
                    fillColor: Color.fromRGBO(54, 31, 169, 0.05),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontSize: DS.setSP(17),
                      color: Color(0XFFA7A7A7),
                    ),
                    prefixIcon: SizedBox(
                      width: 48,
                      height: 48,
                      child: Center(
                        child: Icon(
                          Icons.search,
                          color: Color(0XFFA7A7A7),
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _buildCards('SUGGESTIONS', 'View more'),
                  _buildCards('MY SUBSCRIPTIONS', 'View more'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCards(String title, String more) {
    return Expanded(
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: DS.setHeight(40),
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: DS.setSP(15),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      child: Center(
                        child: Text(
                          more,
                          style: TextStyle(
                            fontSize: DS.setSP(14),
                            color: Color(0XFF3E67D6),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          dense: true,
                          leading: Container(
                            width: DS.setWidth(55),
                            height: DS.setHeight(55),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage(Images.boyDoc),
                              ),
                            ),
                          ),
                          title: Text(
                            'Profile Name',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: DS.setSP(15),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Divider()
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
