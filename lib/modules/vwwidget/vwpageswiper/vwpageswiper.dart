import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class VwPageSwiper extends StatelessWidget {
  VwPageSwiper({required this.pages,
  this.  usedAsWidgetComponent=false,
    super.key,
  });

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };

  final List<Widget> pages;
  final bool usedAsWidgetComponent;

  @override
  Widget build(BuildContext context) {



    Swiper swiper= Swiper(
      key: this.key,
        loop: false,
        itemBuilder: (BuildContext context, int index) {
          return Container(key:Key(index.toString()), child:pages.elementAt(index));
        },
        itemCount: pages.length,

      );


    if(pages.length>1)
      {
        swiper= Swiper(

            loop: false,
            itemBuilder: (BuildContext context, int index) {
              return Container(key:Key(index.toString()), child:pages.elementAt(index));
            },
            itemCount: pages.length,
            pagination: new SwiperPagination(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
              alignment: Alignment.bottomCenter,
              builder: new DotSwiperPaginationBuilder(
                size: 6,
                  activeSize: 8,
                  color: Color.fromARGB(255, 210, 210, 210),
                  activeColor:Colors.blue),
            ),
            /*control: new SwiperControl(
              color: Colors.white,
              disableColor: Colors.transparent
            ),*/

          );

      }

    if(this.usedAsWidgetComponent==true)
      {
        return swiper;
      }
    else{
        return Scaffold(
          body:swiper
        );
    }


  }
}
