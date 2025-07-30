import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/banner_model.dart';
import '../provider/banner_provider.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

BannerProvider provider = BannerProvider();

List<Banner1> listBanner = [];

class _BannerWidgetState extends State<BannerWidget> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    provider.getBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BannerProvider>(context);
    provider.getBanner();
    listBanner = provider.getListBanner;
    if (listBanner.isNotEmpty) {
      return CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 16 / 9,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          enlargeCenterPage: true,
          viewportFraction: 0.8,
          enableInfiniteScroll: true,
          height: 180.0,
          initialPage: 0,
        ),
        items: listBanner.map((banner) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.all(6.0),
                width: MediaQuery.of(context).size.width,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image(
                    image: NetworkImage(banner.imgURL),
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          );
        }).toList(),
      );
    } else {
      return Container();
    }
  }
}
