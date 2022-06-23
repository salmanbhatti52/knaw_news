import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/post_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/screens/home/widget/report_card.dart';

class ReportDialog extends StatefulWidget {
  PostDetail? postDetail;
  ReportDialog({this.postDetail});

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  int selected=0;
  String reportType="";
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 270,
        width: MediaQuery.of(context).size.width*0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10,right: 10),
              alignment: Alignment.topRight,
              child: InkWell(
                  onTap: () => Get.back(),
                  child: SvgPicture.asset(Images.close),
              ),
            ),
            SizedBox(height: 10,),
            Text(AppData().language!.reportThread,style: openSansBold.copyWith(color:Colors.red),),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                ReportCard(title: AppData().language!.violentRepulsive,isSeclected: selected==1?true:false,onTap: () => setState(() {reportType="Violent/repulsive";selected=1;reportPost();}),),
                SizedBox(height: 15,),
                ReportCard(title: AppData().language!.hatefulAbusive,isSeclected: selected==2?true:false,onTap: () => setState(() {reportType="Hateful/Abusive";selected=2;reportPost();})),
                SizedBox(height: 15,),
                ReportCard(title: AppData().language!.sexualContent,isSeclected: selected==3?true:false,onTap: () => setState(() {reportType="Sexual Content";selected=3;reportPost();})),
                SizedBox(height: 15,),
                ReportCard(title: AppData().language!.spamMisleading,isSeclected: selected==4?true:false,onTap: () => setState(() {reportType="Spam/Misleading";selected=4;reportPost();})),
                SizedBox(height: widget.postDetail!.category=="Events"?15:0,),
                widget.postDetail!.category=="Events"?ReportCard(title: AppData().language!.expired,isSeclected: selected==5?true:false,onTap: () => setState(() {reportType="Expire";selected=5;reportExpirePost();})):SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> reportPost() async {
    print(reportType);
    openLoadingDialog(context, "Reporting");
    var response;
    response = await DioService.post('report_news_post', {
      "newsPostId" : widget.postDetail!.newsPostId,
      "usersId" : AppData().userdetail!.usersId,
      "reportType" : reportType
    });
    if(response['status']=='success'){
      //print(postDetail![0].toJson());
      //widget.postDetail!.isBookmarked=="false"?widget.postDetail!.isBookmarked="true":widget.postDetail!.isBookmarked="false";
      Navigator.pop(context);
      Navigator.pop(context);
      //showCustomSnackBar(response['data'],isError: false);
    }
    else{
      Navigator.pop(context);
      Navigator.pop(context);
      //showCustomSnackBar(response['message']);

    }
    Navigator.pop(context);

  }
  Future<void> reportExpirePost() async {
    print(reportType);
    openLoadingDialog(context, "Reporting");
    var response;
    response = await DioService.post('expire_event_news_request', {
      "newsPostId" : widget.postDetail!.newsPostId,
      "usersId" : AppData().userdetail!.usersId,
    });
    if(response['status']=='success'){
      //print(postDetail![0].toJson());
      //widget.postDetail!.isBookmarked=="false"?widget.postDetail!.isBookmarked="true":widget.postDetail!.isBookmarked="false";
      Navigator.pop(context);
      Navigator.pop(context);
      //showCustomSnackBar(response['data'],isError: false);
    }
    else{
      Navigator.pop(context);
      Navigator.pop(context);
      //showCustomSnackBar(response['message']);

    }
    Navigator.pop(context);

  }
}
