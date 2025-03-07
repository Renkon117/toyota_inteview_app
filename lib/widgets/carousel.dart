import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<String> images;

  const Carousel({Key? key, required this.images}) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int currentIndex = 0;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 0);
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      currentIndex = (scrollController.offset / MediaQuery.of(context).size.width).round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            itemCount: widget.images.length,
            itemBuilder: (context, index) => Image.asset(
              widget.images[index],
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitHeight,
            ),
          ),
          // Indicator
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  Container(
                    height: 20,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.images
                        .map(
                          (item) => InkWell(
                            onTap: () {
                              setState(() {
                                currentIndex = widget.images.indexOf(item);
                                scrollController.animateTo(
                                  currentIndex * MediaQuery.of(context).size.width,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4, left: 6, right: 6),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentIndex ==
                                          widget.images.indexOf(item)
                                      ? Colors.blueAccent
                                      : Colors.grey,
                                ),
                                height: 8,
                                width: 8,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
