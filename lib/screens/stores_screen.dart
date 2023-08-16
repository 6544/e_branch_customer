
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import '../components/components.dart';
import '../helpers/config.dart';
import '../helpers/navigations.dart';
import '../models/home_models/markets_model.dart';
import '../providers/home_provider.dart';
import '../states/homes_states.dart';
import 'drawer_screen.dart';
import 'merchant_screen.dart';
class StoresScreen extends StatefulWidget {
  int catId;
  String catName;
  List<Vendors> vendors;
  StoresScreen({Key? key, required this.catId,required this.catName,required this.vendors}) : super(key: key);

  @override
  _StoresScreenState createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  late MarketsModel marketsModel;

  @override
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: widget.catId!=null?widget.catName:"المتاجر",leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios)), actions: []),
      endDrawer: DrawerScreen(),
      body: Consumer<HomeProvider>(
          builder: (context, homeProvider,child) {
            if(widget.catId!=null) {
              if (marketsModel == null) {
                return Center(child: CircularProgressIndicator());
              } else if (marketsModel.vendors!.isEmpty) {
                return Center(
                    child: CustomText(text: "لا يوجد متاجر", fontSize: 18, textDecoration: TextDecoration.none,));
              }
              if (HomeStates.marketsState == MarketsState.ERROR) {
                return Center(child: CustomText(textDecoration: TextDecoration.none,text: "حدث خطأ", fontSize: 16,));
              }
            }else{
              if(widget.vendors==null){
                return Center(
                    child: CustomText(textDecoration: TextDecoration.none,text: "لا يوجد متاجر", fontSize: 18));
              }
            }
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 170.0,
                  //   width: double.infinity,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(25),
                  //     child: Carousel(
                  //       images: [
                  //         Stack(
                  //           alignment: Alignment.topCenter,
                  //           children: [
                  //             Image.asset('images/homeBanner.png',fit: BoxFit.fill,width: double.infinity,height: 170),
                  //             Container(
                  //               height: 35,
                  //               width: double.infinity,
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                  //                 color: Colors.black.withOpacity(0.6)
                  //               ),
                  //               padding: EdgeInsets.symmetric(horizontal: 15),
                  //               alignment: Alignment.centerLeft,
                  //               child: CustomText(text: "asd333323323", fontSize: 12,color: Colors.white,),
                  //             ),
                  //           ],
                  //         ),
                  //         Stack(
                  //           alignment: Alignment.topCenter,
                  //           children: [
                  //             Image.asset('images/homeBanner.png',fit: BoxFit.fill,width: double.infinity,height: 170),
                  //             Container(
                  //               height: 35,
                  //               width: double.infinity,
                  //               decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                  //                   color: Colors.black.withOpacity(0.6)
                  //               ),
                  //               padding: EdgeInsets.symmetric(horizontal: 15),
                  //               alignment: Alignment.centerLeft,
                  //               child: CustomText(text: "asd333323323", fontSize: 12,color: Colors.white,),
                  //             ),
                  //           ],
                  //         ),
                  //         Stack(
                  //           alignment: Alignment.topCenter,
                  //           children: [
                  //             Image.asset('images/homeBanner.png',fit: BoxFit.fill,width: double.infinity,height: 170,),
                  //             Container(
                  //               height: 35,
                  //               width: double.infinity,
                  //               decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                  //                   color: Colors.black.withOpacity(0.6)
                  //               ),
                  //               padding: EdgeInsets.symmetric(horizontal: 15),
                  //               alignment: Alignment.centerLeft,
                  //               child: CustomText(text: "asd333323323", fontSize: 12,color: Colors.white,),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //       dotSize: 4.0,
                  //       dotSpacing: 15.0,
                  //       dotColor: Colors.lightGreenAccent,
                  //       indicatorBgPadding: 5.0,
                  //       dotBgColor: Colors.purple.withOpacity(0.0),
                  //       borderRadius: true,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 15,),
                  Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          return InkWell(
                            onTap: (){
                              Navigation.mainNavigator(context, MerchantScreen(id: marketsModel.vendors![index].id.toString(),name: marketsModel.vendors![index].name!));
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
                                    child: CustomText(textDecoration: TextDecoration.none,text: marketsModel.vendors![index].name!, fontSize: 12,color: Colors.white,),
                                  ),
                                  ClipRRect(
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
                                      child: Image.network(marketsModel.vendors![index].photo!,height: 170,width: double.infinity,fit: BoxFit.fill,))
                                ],
                              ),
                            ),
                          );
                        }, separatorBuilder: (context,index){
                      return const SizedBox(height: 15,);
                    }, itemCount: marketsModel.vendors!.length),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}