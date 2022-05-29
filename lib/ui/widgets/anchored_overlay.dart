import 'package:flutter/material.dart';
// Original code from: https://github.com/matthew-carroll/flutter_ui_challenge_feature_discovery
// This URL does not longer exist

class AnchoredOverlay extends StatelessWidget {
  final bool? showOverlay;
  final Widget Function(BuildContext, Offset anchor)? overlayBuilder;
  final Widget? child;

  const AnchoredOverlay({
    Key? key,
    this.showOverlay,
    this.overlayBuilder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return OverlayBuilder(
        showOverlay: showOverlay,
        overlayBuilder: (BuildContext overlayContext) {
          RenderBox box = context.findRenderObject() as RenderBox;
          final center =
              box.size.center(box.localToGlobal(const Offset(0.0, 0.0)));
          return overlayBuilder!(overlayContext, center);
        },
        child: child,
      );
    });
  }
}

class OverlayBuilder extends StatefulWidget {
  final bool? showOverlay;
  final Function(BuildContext)? overlayBuilder;
  final Widget? child;

  const OverlayBuilder({
    Key? key,
    this.showOverlay = false,
    this.overlayBuilder,
    this.child,
  }) : super(key: key);

  @override
  OverlayBuilderState createState() => OverlayBuilderState();
}

class OverlayBuilderState extends State<OverlayBuilder> {
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.showOverlay!) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
    }
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }

    super.dispose();
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    overlayEntry = OverlayEntry(
      builder: widget.overlayBuilder as Widget Function(BuildContext),
    );
    addToOverlay(overlayEntry!);
  }

  void addToOverlay(OverlayEntry entry) async {
    Overlay.of(context)!.insert(entry);
  }

  void hideOverlay() {
    overlayEntry!.remove();
    overlayEntry = null;
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showOverlay!) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay!) {
      showOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}

class CenterAbout extends StatelessWidget {
  final Offset? position;
  final Widget? child;

  const CenterAbout({
    Key? key,
    this.position,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position!.dy,
      left: position!.dx,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: child,
      ),
    );
  }
}
