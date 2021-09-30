import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winged/models/floorplan_model.dart';
import 'package:winged/models/models.dart';
import 'package:winged/screen/global.dart';

class GridViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final model = Provider.of<FloorPlanModel>(context);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //crossAxisSpacing: 2.0,
        //mainAxisSpacing: 2.0,
        crossAxisCount: 3,
      ),
      itemCount: 9,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        int currentTile = index + 1;
        List<Light> tileLights =
            model.lights.where((item) => item.tile == currentTile).toList();

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Image.asset(
                'assets/img/tile_0$currentTile.png',
              ),
            ),
            model.isScaled
                ? Stack(
                    children: List.generate(
                      tileLights.length,
                      (idx) {
                        return Transform.translate(
                          offset: Offset(
                            size.width * tileLights[idx].position[0],
                            size.width * tileLights[idx].position[1],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: tileLights[idx].status
                                    ? Colors.greenAccent
                                    : Colors.white,
                                radius: 5.0,
                                child: Center(
                                  child: Icon(
                                    Icons.pin_drop,
                                    color: Global.blue,
                                    size: 7,
                                  ),
                                ),
                              ),
                              Transform(
                                transform: Matrix4.identity()..translate(18.0),
                                child: Text(
                                  tileLights[idx].name,
                                  style: TextStyle(
                                    fontSize: 6.0,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : /*CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      '${tileLights.length}',
                      style: TextStyle(
                        color: Global.blue,
                      ),
                    ),
                  ),*/
                Text("")
          ],
        );
      },
    );
  }
}
