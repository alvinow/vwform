import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwwidget/vwcarouselwithindicator/example/libdemo1.dart';

class VwCarouselWithIndicator extends StatefulWidget {
  VwCarouselWithIndicator({
    required this.urlList,
    this.contentType='pdf',
    this.aspectRatio =1,
    required this.appInstanceParam,
    super.key
});
  final List<String> urlList;
  final String contentType;
  final double aspectRatio;
  final VwAppInstanceParam appInstanceParam;


  @override
  State<StatefulWidget> createState() {
    return _VwCarouselWithIndicator();
  }
}

class _VwCarouselWithIndicator extends State<VwCarouselWithIndicator> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  late Key key;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.key==null)
      {
        this.key=Key(Uuid().v4());
      }
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> indicator= this.widget.urlList.asMap().entries.map((entry) {
      return GestureDetector(
        onTap: () => _controller.animateToPage(entry.key),
        child: Container(
          width: 7.0,
          height: 7.0,
          margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.blue)
                  .withOpacity(_current == entry.key ? 0.9 : 0.3)),
        ),
      );
    }).toList();

    List<Widget> bottomPanel=[];
    bottomPanel.addAll(indicator);
    //bottomPanel.add(SizedBox(height: 50,));

    return Column(

        children: [
        Expanded(
          child: CarouselSlider (
            items: this.widget.contentType=="pdf"? LibDemo1.getPdfSliders(key: this.key, appInstanceParam: widget.appInstanceParam, pdfList: this.widget.urlList): LibDemo1.getImageSliders(this.widget.urlList) ,
            carouselController: _controller,
            options: CarouselOptions(
                enlargeStrategy: CenterPageEnlargeStrategy.scale,
                autoPlay: false,
                padEnds: false,
                viewportFraction: 1,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                aspectRatio: this.widget.aspectRatio,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:bottomPanel,
        ),
      ]);

  }
}