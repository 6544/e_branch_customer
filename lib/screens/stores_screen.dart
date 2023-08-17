
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/components.dart';
import '../helpers/config.dart';
import '../helpers/navigations.dart';
import '../models/home_models/markets_model.dart';
import '../providers/home_provider.dart';
import '../states/homes_states.dart';
import 'drawer_screen.dart';
import 'merchant_screen.dart';
class StoresScreen extends StatefulWidget {
 // int catId;
  //String catName;
  //List<Vendors> vendors;
  StoresScreen({Key? key,/* required this.catId,required this.catName,required this.vendors*/}) : super(key: key);

  @override
  _StoresScreenState createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
 // late MarketsModel marketsModel;

 /* @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.catId!=null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        marketsModel =
        await context.read<HomeProvider>().getMarkets(widget.catId);
      });
    }else{
      marketsModel = MarketsModel(vendors: widget.vendors);
    }
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text:"المتاجر",leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios)), actions: []),
      endDrawer: DrawerScreen(),
      body:StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("stores")
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return  Center(
                    child: CircularProgressIndicator(),
                  );

                }

                return snapshot.data!.docs.length == 0
                    ? CustomText(textDecoration: TextDecoration.none,text: "لا يوجد متاجر", fontSize: 18)
                    :Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [

                  const SizedBox(height: 15,),
                  Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          return InkWell(
                            onTap: (){
                             Navigation.mainNavigator(context, MerchantScreen(imageurl: snapshot.data!.docs[index]["imageurl"],name: snapshot.data!.docs[index]["name"]/*id: marketsModel.vendors![index].id.toString(),name: marketsModel.vendors![index].name!*/));
                            },
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Config.buttonColor
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    alignment: Alignment.centerRight,
                                    child: CustomText(textDecoration: TextDecoration.none,text: snapshot.data!.docs[index]["name"], fontSize: 12,color: Colors.white,),
                                  ),
                                  ClipRRect(
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
                                      child: Image.network(snapshot.data!.docs[index]["imageurl"],height: 170,width: double.infinity,fit: BoxFit.fill,))
                                ],
                              ),
                            ),
                          );
                        }, separatorBuilder: (context,index){
                      return const SizedBox(height: 15,);
                    }, itemCount: snapshot.data!.docs.length),
                  )
                ],
              ),
            );
              },
            )

    );
  }
}