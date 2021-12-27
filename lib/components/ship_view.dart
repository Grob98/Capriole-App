import 'dart:async';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShipView extends StatefulWidget {
  const ShipView({Key? key}) : super(key: key);

  @override
  State<ShipView> createState() => ShipViewState();
}

class ShipViewState extends State<ShipView> with TickerProviderStateMixin {

  ui.Image? _imageBasic;
  ui.Image? _imageTest;
  int _imageIndex = 0;

  final Tween<double> _scaleTween = Tween(begin: 4, end: 1);
  Animation<double>? animation;
  AnimationController? controller;

  @override
  initState() {
    super.initState();
    _loadShipBasic();
    _loadShipTest();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = _scaleTween.animate(controller!)
      ..addListener(() {
        setState(() {});
      });

    controller?.forward();
  }

  doRepeat() {
    controller?.reset();
    _imageIndex = 1;
    controller?.forward();
  }

  _loadShipBasic() async {
    ByteData bd = await rootBundle.load("graphics/ship-top.png");
    ui.decodeImageFromList(_loadImage(bd), (ui.Image uiImage) {
      setState(() => _imageBasic = uiImage);
    });
  }

  _loadShipTest() async {
    ByteData bd = await rootBundle.load("graphics/ship-test.png");
    ui.decodeImageFromList(_loadImage(bd), (ui.Image uiImage) {
      setState(() => _imageTest = uiImage);
    });
  }

  Uint8List _loadImage(ByteData bd) {
    final Uint8List bytes = Uint8List.view(bd.buffer);
    img.Image? image = img.decodeImage(bytes);
    image = img.copyRotate(image!, 90);
    return Uint8List.fromList(img.encodePng(image));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        // Swiping in right direction.
        if (details.delta.dx > 0) {
          print("right");
        }

        // Swiping in left direction.
        if (details.delta.dx < 0) {
          print("left");
        }
      },
      child: CustomPaint(
        painter: ShipPainter(_imageBasic, _imageTest, _imageIndex, animation!.value),
        size: const Size(double.infinity, double.infinity),
      ),
    );
  }

  _buildImage() {
    return const RotatedBox(
        quarterTurns: 1,
        child: Image(image: AssetImage('graphics/ship-top.png'))
    );
  }
}

class ShipPainter extends CustomPainter {
  ui.Image? imageBasic;
  ui.Image? imageTest;
  int imageIndex;
  double scale;

  ShipPainter(this.imageBasic, this.imageTest, this.imageIndex, this.scale) : super();
  
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    Rect canvasRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(canvasRect);

    double opScale = scale - 1;

    if (imageBasic != null) {
      Rect scaledImage = Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width,
          height: size.height
      );
      //Rect scaledImage = Rect.fromLTWH((0 - opScale * size.width), 0, size.width + (scale * size.width), size.height * scale);

      paintImage(
        canvas: canvas,
        rect: scaledImage,
        image: imageBasic!,
        fit: BoxFit.fitWidth,
        repeat: ImageRepeat.noRepeat,
        scale: 1.0,
        alignment: Alignment.center,
        flipHorizontally: false,
        filterQuality: FilterQuality.high,
        opacity: 1.0
      );
    }

    if (imageTest != null && imageIndex == 1) {
      Rect scaledImage = Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width * scale,
          height: size.height * scale
      );
      //Rect scaledImage = Rect.fromLTWH((0 - opScale * size.width), 0, size.width + (scale * size.width), size.height * scale);

      paintImage(
          canvas: canvas,
          rect: scaledImage,
          image: imageTest!,
          fit: BoxFit.fitWidth,
          repeat: ImageRepeat.noRepeat,
          scale: 1.0,
          alignment: Alignment.center,
          flipHorizontally: false,
          filterQuality: FilterQuality.high,
          opacity: 1.0 * (1.0 - opScale / 3.0)
      );
    }

    //canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    //canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    ShipPainter old = (oldDelegate as ShipPainter);
    return imageBasic != old.imageBasic || imageTest != old.imageTest
        || imageIndex != old.imageIndex || scale != old.scale;
    //return true;
  }
}