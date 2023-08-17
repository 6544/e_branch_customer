
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/components.dart';
import '../providers/home_provider.dart';
import '../states/homes_states.dart';

class TermsScreen extends StatefulWidget {
  String type;
  TermsScreen({Key? key,required this.type}) : super(key: key);

  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(text: widget.type=="about"?"معلومات عننا":widget.type=="privcy"?"سياسة الخصوصية":"الشروط والأحكام", leading: Container(), actions: []),
      body:Container() /*ChangeNotifierProvider(
        create: (BuildContext context) => HomeProvider()..terms(widget.type),
        child: Consumer<HomeProvider>(
            builder: (context, provider,child) {
              if(HomeStates.fetchChatSate == FetchChatSate.LOADING){
                return Center(child: CircularProgressIndicator());
              }
              return Center(
                child: CustomText(text: provider.response['data'], fontSize: 16, textDecoration: TextDecoration.none,),
              );
            }
        ),
      ),*/
    );
  }
}