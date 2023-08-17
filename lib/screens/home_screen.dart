import 'package:another_flushbar/flushbar.dart';
import 'package:e_branch_customer/screens/productdetails_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../components/components.dart';
import '../helpers/config.dart';
import '../helpers/helperfunctions.dart';
import '../helpers/navigations.dart';
import '../models/home_models/categories_model.dart';
import '../models/home_models/markets_model.dart';
import '../models/home_models/products_model.dart';
import '../providers/home_provider.dart';
import '../states/homes_states.dart';
import 'cart_screen.dart';
import 'drawer_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;

  var phoneNumberController = TextEditingController();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var msgController = TextEditingController();
  var searchController = TextEditingController();
  late GoogleMapController mapController;
  var _formState = GlobalKey<FormState>();

 // late CategoriesModel catModel;
  late Position currentPosition;
 // late ProductsModel productsModel;
  late MarketsModel marketsModel;
  Set<Marker> _markers = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDataWithinNotification();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      currentPosition = await determinePosition();
      marketsModel = await Provider.of<HomeProvider>(context,listen: false).getMarketsWithLocation(currentPosition.latitude,currentPosition.longitude);
      mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(currentPosition.latitude,currentPosition.longitude),zoom: 16),));
      for (var element in marketsModel.vendors!){
        _markers.add(
            Marker(markerId: MarkerId(element.id.toString()),
                onTap: ()async{
             //     Navigation.mainNavigator(context, MerchantScreen(id: element.id.toString(),));
                },
                position: LatLng(
                    double.parse("${element.lat.toString()}"), double.parse("${element.lang.toString()}")),icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size.fromHeight(5)), "images/logo2.png",))

        );
      }
      setState(() {});
      print("_markers.length ${_markers.length}");

    });

  }
  List<String> cats=[
    "ساعات يد",
    "أحذية",
    "ملابس",
    "العاب أطفال",
    "اكسسوارات رجالية",
    "تصنيف",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: pageIndex==0?"ابحث عن متجر":pageIndex==1?"الأقسام":pageIndex==2?"منتجات":"تواصل معنا",leading: IconButton(icon: Icon(Icons.add_shopping_cart,color: Color(0xffffffff),size: 35,), onPressed: (){
        Navigation.mainNavigator(context, CartScreen());
      }), actions: []),
      endDrawer: DrawerScreen(),
      body: Column(
        children: [
          SizedBox(
            height: 190.0,
            width: double.infinity,
            child: GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(target: LatLng(30,29)),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: _markers,
            ),
          ),
          const SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: Icon(Icons.email,color: pageIndex!=3?Config.buttonColor:Config.mainColor,size: 30,), onPressed: (){
                  pageIndex = 3;
                  setState(() {});
                }),
                IconButton(icon: Icon(Icons.remove_red_eye,color: pageIndex!=2?Config.buttonColor:Config.mainColor,size: 30,), onPressed: () async {
                  pageIndex = 2;
                  setState(() {});
                /*  if(productsModel==null)
                    productsModel = await context.read<HomeProvider>().getRandomProducts();
                }*/}),
                IconButton(icon: Icon(Icons.grid_view,color: pageIndex!=1?Config.buttonColor:Config.mainColor,size: 30,), onPressed: () async {
                  pageIndex = 1;
                  setState(() {});
                 // if(catModel==null)
                   // catModel = await context.read<HomeProvider>().getCategories();
                }),
                IconButton(icon: Icon(Icons.search,color: pageIndex!=0?Config.buttonColor:Config.mainColor,size: 30,), onPressed: (){
                  pageIndex = 0;
                  setState(() {});
                }),
              ],
            ),
          ),
          Container(
            color: Config.buttonColor.withOpacity(0.07),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: Config.responsiveHeight(context)-380,
                child: pageIndex==1?Consumer<HomeProvider>(
                    builder: (context, homeProvider,child) {
                      if(cats.length==0 || HomeStates.catState == CatState.LOADING){
                        return Center(child: CircularProgressIndicator());
                      }else if(cats.length==0){
                        return CustomText(text: "لا يوجد أقسام الان", fontSize: 18, textDecoration: TextDecoration.none,);
                      }
                      if(HomeStates.catState == CatState.ERROR){
                        return Center(child: CustomText(text: "حدث خطأ", fontSize: 16, textDecoration: TextDecoration.none,));
                      }

                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 25,
                          childAspectRatio: (150 / 43),
                          children: List.generate(cats.length, (index) {
                            return InkWell(
                              onTap: (){
                             //   Navigation.mainNavigator(context, StoresScreen(catId: catModel.services[index].id,catName: catModel.services![index].name));
                              },
                              child: Container(
                                width: double.infinity,
                                height: 43,
                                alignment: Alignment.center,
                                child: CustomText(text:cats[index], fontSize: 14,color: Config.mainColor, textDecoration: TextDecoration.none,),
                                decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    border: Border.all(color: Config.buttonColor.withOpacity(0.6),width: 2),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }
                ):pageIndex==0?Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomInput(controller: searchController, hint: "اكتب اسم المتجر", textInputType: TextInputType.text,suffixIcon: IconButton(icon: Icon(Icons.search,size: 37,color: Config.mainColor,), onPressed: (){}), onTap: () {  }, prefixIcon:  Icon(Icons.phone,color: Config.mainColor,), onChange: (String ) {  }, maxLines: 1,),
                    const SizedBox(height: 30,),
                    CustomButton(text: "بحث",onPressed: (){
                      List<Vendors> vendors = [];
                      marketsModel.vendors!.forEach((element) {

                        if(element.name!.toLowerCase().contains(searchController.text.toLowerCase())){
                          vendors.add(element);
                        }
                      });
                 //     Navigation.mainNavigator(context, StoresScreen(catId: null,catName: null,vendors:vendors ));

                    }, color: Colors.transparent,)
                  ],
                ):pageIndex==2?
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("specialproducts")
                  // .orderBy(
                  //   "datePublished",
                  //   descending: true,
                  // )
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return  Center(
                        child: CircularProgressIndicator(),
                      );

                    }

                    return snapshot.data!.docs.length == 0
                        ? CustomText(text: "لا يوجد منتجات الان", fontSize: 18, textDecoration: TextDecoration.none,)
                        : Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 15,
                          childAspectRatio: (Config.responsiveHeight(context)*0.131 / 150),
                          children: List.generate(snapshot.data!.docs.length, (index) {
                            return ProductCard(name: snapshot.data!.docs[index]["name"],price: snapshot.data!.docs[index]["price"].toString(),image: snapshot.data!.docs[index]["imageurl"],onTap: (){
                              Navigation.mainNavigator(context, ProductDetailsScreen(product:snapshot.data!.docs[index], offer: true, fromOrder: false,));
                            }, catName:snapshot.data!.docs[index]["category"] , offer: '',);
                          }),
                        ),
                      ),
                    );
                  },
                )
                /*Consumer<HomeProvider>(
                    builder: (context, homeProvider,child) {
                      if(productsModel==null){
                        return Center(child: CircularProgressIndicator());
                      }else if(productsModel.data!.length == 0){
                        return CustomText(text: "لا يوجد منتجات الان", fontSize: 18, textDecoration: TextDecoration.none,);
                      }
                      if(HomeStates.marketOffersState==MarketOffersState.ERROR){
                        return CustomText(text: "حدث خطأ", fontSize: 16, textDecoration: TextDecoration.none,);
                      }
                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 15,
                            childAspectRatio: (Config.responsiveHeight(context)*0.131 / 160),
                            children: List.generate(productsModel.data!.length, (index) {
                              return ProductCard(name: productsModel.data![index].name!,price: productsModel.data![index].price.toString(),image: productsModel.data![index].photo!,onTap: (){
                                //Navigation.mainNavigator(context, ProductDetailsScreen(product: productsModel.data[index],));
                              }, catName: 'ملابس', offer: '',);
                            }),
                          ),
                        ),
                      );
                    }
                )*/:Form(
                  key: _formState,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomInput( onTap: () {  }, prefixIcon:  Icon(Icons.phone,color: Config.mainColor,), onChange: (String ) {  }, maxLines: 1,controller: nameController, hint: "الاسم بالكامل", textInputType: TextInputType.text,suffixIcon: Icon(Icons.person,color: Config.mainColor,),),
                        const SizedBox(height: 15,),
                        CustomInput( onTap: () {  }, prefixIcon:  Icon(Icons.phone,color: Config.mainColor,), onChange: (String ) {  }, maxLines: 1,controller: emailController, hint: "البريد الإلكتروني", textInputType: TextInputType.emailAddress,suffixIcon: Icon(Icons.email,color: Config.mainColor,),),
                        const SizedBox(height: 15,),
                        CustomInput( onTap: () {  }, prefixIcon:  Icon(Icons.phone,color: Config.mainColor,), onChange: (String ) {  }, maxLines: 1,controller: phoneNumberController, hint: "رقم الهاتف", textInputType: TextInputType.phone,suffixIcon: Icon(Icons.phone,color: Config.mainColor,),),
                        const SizedBox(height: 30,),
                        CustomInput( onTap: () {  }, prefixIcon:  Icon(Icons.phone,color: Config.mainColor,), onChange: (String ) {  }, maxLines: 1,controller: msgController, hint: "الرسالة", textInputType: TextInputType.text,suffixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 85),
                          child: Icon(Icons.chat,color: Config.mainColor,),
                        )),
                        const SizedBox(height: 50,),
                        CustomButton(text: "ارسال",onPressed: () async {
                          if(_formState.currentState!.validate()) {
                            Map response= await context.read<HomeProvider>().contactUs({"name": nameController.text,"email": emailController.text,"phone": phoneNumberController.text,"messages":msgController.text});
                            toast(response['msg'], context);
                            if(response['status']){
                              nameController.text="";
                              emailController.text="";
                              phoneNumberController.text="";
                              msgController.text="";
                            }
                          }
                        }, color: Colors.transparent,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }


  fetchDataWithinNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.requestPermission();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((event) async {
      Flushbar(
        message: event.notification!.body ,
        title: event.notification!.title,
        messageColor: Colors.white,
        titleColor: Colors.white,
        textDirection: TextDirection.rtl,
        padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
        // maxWidth: double.infinity,
        isDismissible: true,
        duration: const Duration(seconds: 5),
        flushbarPosition: FlushbarPosition.TOP,
        barBlur: .1,
        backgroundColor: Config.mainColor,
        borderColor: Colors.white,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
      ).show(context);

      Provider.of<HomeProvider>(context,listen: false).getChatsList();
      Provider.of<HomeProvider>(context,listen: false).getCurrentOrder("current-orders");
      Provider.of<HomeProvider>(context,listen: false).getCurrentOrder("old-orders");
      setState(() {});
    });

  }
}
