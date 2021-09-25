import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winged/screen/global.dart';
import 'package:winged/widgets/appbar_widget.dart';
import 'package:winged/widgets/gridview_widget.dart';
import 'package:winged/widgets/overlay_widget.dart';
import 'package:winged/widgets/raw_gesture_detector_widget.dart';
import 'package:winged/widgets/reset_button_widget.dart';
import 'package:winged/models/floorplan_model.dart';

class Building extends StatelessWidget {
  const Building({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<FloorPlanModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBarWidget(),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: Container(
          color: Colors.white,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                RawGestureDetectorWidget(
                  child: GridViewWidget(),
                ),
                model.hasTouched ? ResetButtonWidget() : OverlayWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
