import 'package:evently/providers/event_provider.dart';
import 'package:evently/providers/settings_provider.dart';
import 'package:evently/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatefulWidget {
  HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    EventProvider prov = Provider.of<EventProvider>(context);
    bool isDark = Provider.of<SettingsProvider>(context).isDark;
    return prov.filteredEvents.isEmpty
        ? Expanded(
            child: Center(
              child: LottieBuilder.asset(
                isDark
                    ? 'assets/lottie/event_dark.json'
                    : 'assets/lottie/event.json',
              ),
            ),
          )
        : Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 16.h,
                );
              },
              itemCount: prov.filteredEvents.length,
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: index == prov.filteredEvents.length - 1
                      ? EdgeInsets.only(
                          bottom: 75.h,
                        )
                      : EdgeInsets.zero,
                  child: CategoryItem(
                    event: prov.filteredEvents[index],
                  ),
                );
              },
            ),
          );
  }
}
