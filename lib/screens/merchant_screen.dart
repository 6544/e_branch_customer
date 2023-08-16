import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/components.dart';
import '../helpers/config.dart';
import '../helpers/navigations.dart';
import '../models/home_models/categories_model.dart';
import '../models/home_models/products_model.dart';
import '../models/home_models/sliders_model.dart';
import '../providers/home_provider.dart';
import '../states/homes_states.dart';
import 'chats_screen.dart';
import 'home_screen.dart';

class MerchantScreen extends StatefulWidget {
  String id,name;
  MerchantScreen({Key? key,required this.id,required this.name}) : super(key: key);

  @override
  _MerchantScreenState createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  late List<Widget> images;
  late ProductsModel productsModel;
  late CategoriesModel categoriesModel;
  late SlidersModel slidersModel;
  late ProductsModel bestSeller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SlidersModel slidersModel = await Provider.of<HomeProvider>(context,listen: false).getMarketSliders(widget.id);
      images = [];
      slidersModel.data!.forEach((element) {
        images.add(Image.network(element.image!,width: double.infinity,fit: BoxFit.fill,height: 170,));
      });
      productsModel = await Provider.of<HomeProvider>(context,listen: false).getMarketOffers(widget.id);
      categoriesModel = (await Provider.of<HomeProvider>(context,listen: false).getMarketCategories(widget.id))!;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "مراسلة المتجر",leading: IconButton(onPressed: (){
        Navigation.removeUntilNavigator(context, HomeScreen());
      }, icon: Icon(Icons.close,color: Colors.red,)),actions: [
        IconButton(onPressed: (){
          Navigation.mainNavigator(context, ChatsScreen(merchantId: widget.id,merchantName: widget.name));
        }, icon: Icon(Icons.chat))
      ]),
      body: Stack(
        children: [
          // Container(height: double.infinity,width: double.infinity,color: Config.buttonColor.withOpacity(0.3),),
          SingleChildScrollView(
            child: Column(
              children: [
                Consumer<HomeProvider>(
                    builder: (context, sliders,child) {
                      if(images==null){
                        return Center(child: CircularProgressIndicator());
                      }
                      if(images.isEmpty){
                        return SizedBox();
                      }
                      return SizedBox(
                        height: 170.0,
                        width: double.infinity,
                        child:Container() /*Carousel(
                          images: images,
                          dotSize: 4.0,
                          dotSpacing: 15.0,
                          dotColor: Config.mainColor,
                          indicatorBgPadding: 5.0,
                          borderRadius: true,
                        ),*/
                      );
                    }
                ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          CustomText(text: "العروض", fontSize: 22,color: Color(0xff000000), textDecoration: TextDecoration.none,),
                          Container(height: 30,width: 3,color: Config.buttonColor,),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18,),
                Consumer<HomeProvider>(
                    builder: (context, homeProvider,child) {
                      if(productsModel==null){
                        return Center(child: CircularProgressIndicator());
                      }else if(productsModel.data!.isEmpty){
                        return Center(child: CustomText(textDecoration: TextDecoration.none,text: "لا يوجد منتجات", fontSize: 18));
                      }

                      if(HomeStates.marketOffersState==MarketOffersState.ERROR){
                        return CustomText(textDecoration: TextDecoration.none,text: "حدث خطأ", fontSize: 16);
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 5,),
                          Padding(
                            padding: const EdgeInsets.only(top:65,),
                            child: Icon(Platform.isAndroid?Icons.arrow_back:Icons.arrow_back_ios,size: 20,),
                          ),
                          Container(
                            height: 216,
                            width:  Config.responsiveWidth(context)*0.88,
                            child: ListView.separated(
                                shrinkWrap: true,
                                reverse: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context,index){
                                  return ProductCard(name: productsModel.data![index].name!,rate:0.0,price: productsModel.data![index].price.toString(), catName: "".toString(),image: productsModel.data![index].photo!,onTap: (){
                                  //  Navigation.mainNavigator(context, ProductDetailsScreen(product: productsModel.data![index],offer: true));
                                  },offer: productsModel.data![index].offer.toString());
                                }, separatorBuilder: (context,index){
                              return const SizedBox(width: 10,);
                            }, itemCount: productsModel.data!.length),
                          ),
                          const SizedBox(width: 5,),
                          Padding(
                            padding: const EdgeInsets.only(top:65,),
                            child: Icon(Icons.arrow_forward_ios,size: 20,),
                          ),
                        ],
                      );
                    }
                ),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          CustomText(text: "الاقسام", fontSize: 22,color: Color(0xff000000),textDecoration: TextDecoration.none),
                          Container(height: 30,width: 3,color: Config.buttonColor,),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15)),
                      ),
                    ),
                  ],
                ),
                Consumer<HomeProvider>(
                    builder: (context, homeProvider,child) {
                      if(categoriesModel == null){
                        return Center(child: CircularProgressIndicator());
                      }

                      if(HomeStates.marketCategoriesState == MarketCategoriesState.ERROR){
                        return Center(child: CustomText(text: "حدث خطأ", fontSize: 16,textDecoration: TextDecoration.none));
                      }
                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 15,
                            childAspectRatio: (150 / 100),
                            children: List.generate(categoriesModel.services!.length, (index) {
                              return CategoriesCard(name: categoriesModel.services![index].name!,image: categoriesModel.services![index].photo!,onTap: (){
                             //   Navigation.mainNavigator(context, ProductsScreen(name: categoriesModel.services[index].name,id: categoriesModel.services![index].id.toString()));
                              },);
                            }),
                          ),
                        ),
                      );
                    }
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          CustomText(text: "الاكثر مبيعا", fontSize: 19,color: Color(0xff000000),textDecoration: TextDecoration.none),
                          Container(height: 30,width: 3,color: Config.buttonColor,),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15)),
                      ),
                    ),
                  ],
                ),
                ChangeNotifierProvider(
                  create: (BuildContext context) => HomeProvider()..getBestSeller(widget.id),
                  child: Selector<HomeProvider,MarketOffersState>(
                      selector: (context,provider){
                        bestSeller = provider.bestSeller;
                        return HomeStates.marketOffersState;
                      },
                      builder: (context, state,child) {
                        if(state == MarketOffersState.LOADING){
                          return Center(child: CircularProgressIndicator());
                        }
                        if(state == MarketOffersState.LOADED && bestSeller.data!.isEmpty){
                          return Center(child: CustomText(text: "لا يوجد منتجات", fontSize: 16,textDecoration: TextDecoration.none));
                        }
                        return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: (Config.responsiveHeight(context)*0.15 / 160),
                              children: List.generate(bestSeller.data!.length, (index) {
                                return ProductCard(name: bestSeller.data![index].name!,rate:0.0,price: bestSeller.data![index].price.toString(), catName: "".toString(),image: bestSeller.data![index].photo!,onTap: (){
                                //  Navigation.mainNavigator(context, ProductDetailsScreen(product: bestSeller.data[index]));
                                }, offer: '',);
                              }),
                            ),
                          ),
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}