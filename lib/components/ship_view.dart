import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:capriole_app/components/zone_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShipView extends StatefulWidget {
  ZoneStatus status;

  ShipView({Key? key, required this.status}) : super(key: key);

  @override
  State<ShipView> createState() => ShipViewState();
}

class ShipViewState extends State<ShipView> with TickerProviderStateMixin {

  ui.Image? _imageBasic;
  ui.Image? _imageBasicOff;
  ui.Image? _imageBasicSalon;
  ui.Image? _imageBasicAchtern;
  ui.Image? _imageBasicOn;
  ui.Image? _imageFly;
  ui.Image? _imageFlyOff;
  ui.Image? _imageFlyOn;

  //Status
  bool _isFly = false;

  final Tween<double> _scaleTween = Tween(begin: 4, end: 1);
  Animation<double>? animation;
  AnimationController? controller;

  @override
  initState() {
    super.initState();
    _loadShipBasicOff();
    _loadShipBasicAchtern();
    _loadShipBasicSalon();
    _loadShipBasicOn();
    _loadShipFly();
    _loadShipFlyOn();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = _scaleTween.animate(controller!)
      ..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          _isFly = true;
        }else if (status == AnimationStatus.reverse) {
          _isFly = true;
        }else if (status == AnimationStatus.completed) {
          _isFly = true;
        }else if (status == AnimationStatus.dismissed) {
          _isFly = false;
        }
      })
      ..addListener(() {
        setState(() {});
      });
  }

  updateImages() {
    setState(() {
      if (widget.status.zoneSalon && widget.status.zoneAchtern) {
        _imageBasic = _imageBasicOn;
      }else if (widget.status.zoneSalon) {
        _imageBasic = _imageBasicSalon;
      }else if (widget.status.zoneAchtern) {
        _imageBasic = _imageBasicAchtern;
      }else {
        _imageBasic = _imageBasicOff;
      }

      if (widget.status.zoneFly) {
        _imageFly = _imageFlyOn;
      }else {
        _imageFly = _imageFlyOff;
      }
    });

  }

  setFly(bool isActive) {
    if (isActive) {
      controller?.forward();
    }else{
      controller?.reverse();
    }
  }

  setSalonActive() {
    setFly(false);
    updateImages();
  }

  setAchternActive() {
    setFly(false);
    updateImages();
  }

  setFlyActive() {
    setFly(true);
    updateImages();
  }

  _loadShipBasicOff() async {
    ByteData bd = await rootBundle.load("graphics/ship-bottom.png");
    ui.decodeImageFromList(_loadImage(bd), (ui.Image uiImage) {
      _imageBasicOff = uiImage;
      setState(() => _imageBasic = _imageBasicOff);
    });
  }

  _loadShipBasicOn() async {
    ByteData bd = await rootBundle.load("graphics/ship-bottom-on.png");
    ui.decodeImageFromList(_loadImage(bd), (ui.Image uiImage) {
      _imageBasicOn = uiImage;
    });
  }

  _loadShipBasicAchtern() async {
    ByteData bd = await rootBundle.load("graphics/ship-bottom-achtern.png");
    ui.decodeImageFromList(_loadImage(bd), (ui.Image uiImage) {
      _imageBasicAchtern = uiImage;
    });
  }

  _loadShipBasicSalon() async {
    ByteData bd = await rootBundle.load("graphics/ship-bottom-salon.png");
    ui.decodeImageFromList(_loadImage(bd), (ui.Image uiImage) {
      _imageBasicSalon = uiImage;
    });
  }

  _loadShipFly() async {
    ByteData bd = await rootBundle.load("graphics/ship-fly.png");
    ui.decodeImageFromList(_loadImage(bd), (ui.Image uiImage) {
      _imageFlyOff = uiImage;
    });
  }

  _loadShipFlyOn() async {
    ByteData bd = await rootBundle.load("graphics/ship-fly-on.png");
    ui.decodeImageFromList(_loadImage(bd), (ui.Image uiImage) {
      _imageFlyOn = uiImage;
    });
  }

  Uint8List _loadImage(ByteData bd) {
    final Uint8List bytes = Uint8List.view(bd.buffer);
    //img.Image? image = img.decodeImage(bytes);
    return bytes;
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
        painter: ShipPainter(_imageBasic, _imageFly, _isFly, animation!.value),
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

/*class ShipPainter extends CustomPainter {
  DrawableRoot? imageBasic;
  DrawableRoot? imageTest;
  int imageIndex;
  double scale;

  ShipPainter(this.imageBasic, this.imageTest, this.imageIndex, this.scale) : super();

  @override
  void paint(Canvas canvas, Size size) {
    if(imageBasic != null){
      imageBasic?.scaleCanvasToViewBox(canvas, size);
      imageBasic?.clipCanvasToViewBox(canvas);
      imageBasic?.draw(canvas, Rect.fromLTWH(0, 0, size.width, size.height));
    }

    if(imageTest != null){
      imageTest?.scaleCanvasToViewBox(canvas, size);
      imageTest?.clipCanvasToViewBox(canvas);
      imageTest?.draw(canvas, Rect.fromLTWH(0, 0, size.width, size.height));
    }

    /*print(imageIndex);

    if (imageTest != null && imageIndex == 1) {
      Size test = Size(size.width * scale, size.height * scale);
      Rect scaledImage = Rect.fromLTWH(
          0, 0, size.width, size.height
      );
      imageTest?.scaleCanvasToViewBox(canvas, size);
      imageTest?.clipCanvasToViewBox(canvas);
      imageTest?.draw(canvas, scaledImage);
    }*/
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    ShipPainter old = (oldDelegate as ShipPainter);
    return imageBasic != old.imageBasic || imageTest != old.imageTest
        || imageIndex != old.imageIndex || scale != old.scale;
    //return true;
  }
}*/

class ShipPainter extends CustomPainter {
  ui.Image? imageBasic;
  ui.Image? imageTest;
  bool isFly;
  double scale;

  ShipPainter(this.imageBasic, this.imageTest, this.isFly, this.scale) : super();
  
  @override
  void paint(Canvas canvas, Size size) {
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
        opacity: 1.0,
        isAntiAlias: true,
      );
    }

    if (imageTest != null && isFly == true) {
      Rect scaledImage = Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width * scale,
          height: size.height * scale
      );

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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    ShipPainter old = (oldDelegate as ShipPainter);
    return imageBasic != old.imageBasic || imageTest != old.imageTest
        || isFly != old.isFly || scale != old.scale;
    //return true;
  }
}

