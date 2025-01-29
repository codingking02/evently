import 'package:evently/models/category.dart';
import 'package:evently/providers/event_provider.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/theme/apptheme.dart';
import 'package:evently/widgets/icon_item.dart';
import 'package:evently/widgets/mytabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatefulWidget {
  HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 198.h,
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: Apptheme.primary,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back ✨',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Apptheme.backgroundLight),
                      ),
                      Text(
                        Provider.of<UserProvider>(context).user!.name,
                        style: Theme.of(context).textTheme.displayMedium!,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.wb_sunny_outlined,
                    color: Apptheme.backgroundLight,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                    height: 35.h,
                    width: 35.w,
                    decoration: BoxDecoration(
                      color: Apptheme.backgroundLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'EN',
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: 14,
                                  color: Apptheme.primary,
                                ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16.w,
              ),
              child: Row(
                children: [
                  const IconItem(iconName: 'map_icon'),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    'Cairo , Egypt',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Apptheme.backgroundLight,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Mytabbar(
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
                Provider.of<EventProvider>(
                  context,
                  listen: false,
                ).filterEvents(
                  MyCategory.myCategory[index],
                );
              },
              currentIndex: currentIndex,
              isCreateEvent: false,
              tabBarLength: MyCategory.myCategory.length,
            ),
          ],
        ),
      ),
    );
  }
}
