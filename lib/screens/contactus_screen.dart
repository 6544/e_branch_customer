
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/components.dart';
import '../helpers/config.dart';
import '../helpers/helperfunctions.dart';
import '../providers/home_provider.dart';
class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  var nameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var emailController = TextEditingController();
  var msgController = TextEditingController();

  var _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "تواصل معنا", leading: Container(), actions: []),
      body: Form(
        key: _formState,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomInput(controller: nameController, hint: "الاسم بالكامل", textInputType: TextInputType.text,suffixIcon: Icon(Icons.person,color: Config.mainColor,), onTap: () {  }, prefixIcon: Icon(Icons.person,color: Config.mainColor,), onChange: (String ) {  }, maxLines: 1,),
                const SizedBox(height: 15,),
                CustomInput(controller: emailController, hint: "البريد الإلكتروني", textInputType: TextInputType.emailAddress,suffixIcon: Icon(Icons.email,color: Config.mainColor,), onTap: () {  }, prefixIcon: Icon(Icons.email,color: Config.mainColor,), onChange: (String ) {  }, maxLines: 1),
                const SizedBox(height: 15,),
                CustomInput(controller: phoneNumberController, hint: "رقم الهاتف", textInputType: TextInputType.phone,suffixIcon: Icon(Icons.phone,color: Config.mainColor,), onTap: () {  }, prefixIcon: Icon(Icons.phone,color: Config.mainColor,), onChange: (String ) {  }, maxLines: 1),
                const SizedBox(height: 30,),
                CustomInput(controller: msgController, hint: "الرسالة", textInputType: TextInputType.text,suffixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 85),
                  child: Icon(Icons.chat,color: Config.mainColor,),
                ),maxLines: 4, onTap: () {  }, prefixIcon: Icon(Icons.chat,color: Config.mainColor,), onChange: (String ) {  },),
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
                }, color: Config.buttonColor,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}