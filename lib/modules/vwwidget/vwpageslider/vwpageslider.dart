import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

class VwPageSlider extends StatefulWidget{

  VwPageSlider({
    required super.key,
    required this.pages,
    this.usedAsWidgetComponent=false
});

  final List<Widget> pages;
  final bool usedAsWidgetComponent;

  VwPageSliderState createState()=>VwPageSliderState();
}

class VwPageSliderState extends State<VwPageSlider>{

  late int _current;
  late  CarouselSliderController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._current=0;
    this._controller= CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    return

      Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,

            child: CarouselSlider (

            key:this.widget.key,
            items: this.widget.pages,
            options: CarouselOptions(
              onPageChanged: (index, reason){
                setState(() {
                  _current = index;
                });
              },
              autoPlay: false,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              viewportFraction: 1,
              //aspectRatio: 2.0,
              //initialPage: 2,
            ),

          ),),

           FadeIn (
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeInOutBack,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.pages.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,

                            color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                                .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                )
          )

        ],
      );

  }
}