import 'package:flutter/material.dart';

// Starting point for CustomDialog code taken from https://fluttertutorial.in/dialog-in-flutter/
class CustomDialog extends StatelessWidget {
  final String? title, description, buttonText;
  final Image? image;
  const CustomDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.buttonText,
    this.image,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    const double padding = 16.0;
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: padding,
            left: padding,
            right: padding,
          ),
          margin: const EdgeInsets.only(),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(padding),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16.0),
              SelectableText(description!,
                  enableInteractiveSelection: true,
                  maxLines: 15,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 12.0,
                  )),
              const SizedBox(height: 24.0),
              Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // To close the dialog
                    },
                    child: Text(buttonText!),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
