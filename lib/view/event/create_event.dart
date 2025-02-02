import 'package:evently/models/category.dart';
import 'package:evently/models/event.dart';
import 'package:evently/providers/event_provider.dart';
import 'package:evently/connection/firebase_service.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/theme/apptheme.dart';
import 'package:evently/widgets/deafult_text_field.dart';
import 'package:evently/widgets/login_button.dart';
import 'package:evently/widgets/mytabbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  static const String routeName = '/create-event';

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  int currentIndex = 0;
  DateTime? selectedDateTime;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  TimeOfDay? timeOfDay;
  MyCategory selectedCategory = MyCategory.myCategory.first;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String format(BuildContext context, TimeOfDay timeOfDay) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(
      timeOfDay,
      alwaysUse24HourFormat: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    selectedCategory = MyCategory.myCategory[currentIndex + 1];
    TextStyle? myblackTextTheme = Theme.of(context).textTheme.bodyLarge;
    TextStyle? myblueTextTheme = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(color: Apptheme.primary);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Create Event'),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.h,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.asset(
                    'assets/images/${selectedCategory.imageName}.png',
                    height: 203.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Mytabbar(
                currentIndex: currentIndex,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                isCreateEvent: true,
                tabBarLength: MyCategory.myCategory.length - 1,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        spacing: 16.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title',
                            style: myblackTextTheme,
                          ),
                          DeafultTextFormField(
                            textEditingController: titleController,
                            hintText: 'Event Title',
                            borderColor: Apptheme.grey,
                            prefixImageName: 'note',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Event Title';
                              }
                              return null;
                            },
                          ),
                          Text(
                            'Description',
                            style: myblackTextTheme,
                          ),
                          DeafultTextFormField(
                            textEditingController: descriptionController,
                            hintText: 'Event Descriprion',
                            borderColor: Apptheme.grey,
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Event Descriprion';
                              }
                              return null;
                            },
                          ),
                          Row(
                            spacing: 10.w,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/calendar.svg',
                              ),
                              Text(
                                'Event Date',
                                style: myblackTextTheme,
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () async {
                                  var date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(
                                      const Duration(days: 365),
                                    ),
                                    initialEntryMode:
                                        DatePickerEntryMode.calendarOnly,
                                  );
                                  if (date != null) {
                                    selectedDateTime = date;
                                    setState(() {});
                                  }
                                },
                                child: Text(
                                  selectedDateTime != null
                                      ? dateFormat.format(selectedDateTime!)
                                      : 'Choose Date',
                                  style: myblueTextTheme,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10.w,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/clock.svg',
                              ),
                              Text(
                                'Event Time',
                                style: myblackTextTheme,
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () async {
                                  TimeOfDay? nowTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: false,
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (nowTime != null) {
                                    timeOfDay = nowTime;
                                    setState(() {});
                                  }
                                },
                                child: Text(
                                  timeOfDay != null
                                      ? format(context, timeOfDay!)
                                      : 'Choose Time',
                                  style: myblueTextTheme,
                                ),
                              ),
                            ],
                          ),
                          DefaultButton(
                            onPressed: () {
                              createEvent(context);
                            },
                            label: 'Add',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createEvent(BuildContext context) async {
    if (formKey.currentState!.validate() &&
        selectedDateTime != null &&
        timeOfDay != null) {
      DateTime dateTime = DateTime(
        selectedDateTime!.year,
        selectedDateTime!.month,
        selectedDateTime!.day,
        timeOfDay!.hour,
        timeOfDay!.minute,
      );
      Event event = Event(
        uId: Provider.of<UserProvider>(context, listen: false).user!.id,
        category: selectedCategory,
        title: titleController.text,
        description: descriptionController.text,
        dateTime: dateTime,
      );
      await FirebaseService.addEventToFireStore(event).then(
        (value) {
          EventProvider prov =
              Provider.of<EventProvider>(context, listen: false);
          prov.getEvents();
          Fluttertoast.showToast(
            msg: "Event Created Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Apptheme.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.of(context).pop();
        },
      ).catchError((error) {
        if (error is FirebaseException) {
          Fluttertoast.showToast(
            msg: error.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Apptheme.primary,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Apptheme.primary,
            title: Text(
              'Incomplete Fields',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Apptheme.backgroundLight),
            ),
            content: Text(
              'Please fill out all required fields.',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Apptheme.backgroundLight),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Apptheme.backgroundLight),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
