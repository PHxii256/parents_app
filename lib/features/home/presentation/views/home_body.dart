import 'package:flutter/material.dart';
import 'package:parent_app/features/absence/presentation/views/absence_page.dart';
import 'package:parent_app/features/change_request/presentation/views/change_request_page.dart';
import 'package:parent_app/features/pin_code/views/pin_code_page.dart';
import 'package:parent_app/shared/widgets/icon_box.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          child: Stack(
            alignment: AlignmentGeometry.bottomCenter,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.amber),
                child: SizedBox(height: 460, width: double.infinity),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 8, spreadRadius: 3)],
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(16),
                    topEnd: Radius.circular(16),
                  ),
                ),
                child: SizedBox(height: 20, width: double.infinity),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 18,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Trip Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
                  Row(
                    spacing: 8,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                        child: SizedBox(width: 14, height: 14),
                      ),
                      Text(
                        "No trip currently",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ListTile(
                horizontalTitleGap: 12,
                contentPadding: EdgeInsets.all(0),
                leading: IconBox(icon: Icons.home, width: 48, height: 48),
                trailing: InkWell(child: Icon(Icons.edit, size: 22), onTap: () {}),
                title: SizedBox(
                  child: Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 6,
                        children: [
                          Text(
                            "Home",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              height: 0.95,
                            ),
                          ),
                          Text(
                            "(next pickup)",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              height: 0.95,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "123 Maple Street",
                        style: TextStyle(color: Color.fromARGB(255, 97, 117, 138), fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  "Quick Actions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
              ),
              Row(
                spacing: 8,
                children: [
                  Column(
                    spacing: 6,
                    children: [
                      IconBox(
                        icon: Icons.key,
                        width: 80,
                        height: 80,
                        iconSize: 32,
                        onTap: () {
                          Navigator.of(
                            context,
                          ).push(MaterialPageRoute(builder: (_) => PinCodePage()));
                        },
                      ),
                      Text("Pin Code", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  Column(
                    spacing: 6,
                    children: [
                      IconBox(
                        icon: Icons.calendar_month,
                        width: 80,
                        height: 80,
                        iconSize: 32,
                        onTap: () {
                          Navigator.of(
                            context,
                          ).push(MaterialPageRoute(builder: (_) => AbsencePage()));
                        },
                      ),
                      Text("Absence", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      spacing: 6,
                      children: [
                        IconBox(
                          icon: Icons.pin_drop,
                          height: 80,
                          iconSize: 32,
                          width: double.infinity,
                          onTap: () {
                            Navigator.of(
                              context,
                            ).push(MaterialPageRoute(builder: (_) => ChangeRequestPage()));
                          },
                        ),
                        Text(
                          "Change Pickup/Drop-off",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
