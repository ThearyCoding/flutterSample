import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselSliderWithTitles extends StatefulWidget {
  const CarouselSliderWithTitles({Key? key}) : super(key: key);

  @override
  State<CarouselSliderWithTitles> createState() => _CarouselSliderWithTitlesState();
}

class _CarouselSliderWithTitlesState extends State<CarouselSliderWithTitles> {
  final List<String> imageUrls = [
    "https://www.eatingwell.com/thmb/_7h28VUpbggMtFueu4B-SlR751Y=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/wheat-berry-salad-2000-7ef11f7f4bb248a799bf1bd5b4d12c6b.jpg",
    "https://www.aworldtotravel.com/wp-content/uploads/2018/10/paella-spanish-food-best-countries-for-food-around-the-world-a-world-to-travel.jpg",
    "https://hips.hearstapps.com/hmg-prod/images/classic-cheese-pizza-recipe-2-64429a0cb408b.jpg?crop=0.8888888888888888xw:1xh;center,top&resize=1200:*",
    "https://cdn.britannica.com/52/128652-050-14AD19CA/Maki-zushi.jpg",
  ];

  final List<String> titles = [
    "Wheat Berries",
    "SPAIN",
    "Classic Cheese Pizza",
    "Sushi",
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: imageUrls.length,
      itemBuilder: (context, index, realIndex) {
        return Stack(
          children: [
            Container(
              height: 270.0, // Set a fixed height
              width: double.infinity, // Take full width
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: CachedNetworkImage(
                  imageUrl: imageUrls[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Positioned(
              bottom: 20.0,
              left: 12.0,
              child: Container(
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade500.withOpacity(0.80),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  titles[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      options: CarouselOptions(
        height: 270.0,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
    );
  }
}
