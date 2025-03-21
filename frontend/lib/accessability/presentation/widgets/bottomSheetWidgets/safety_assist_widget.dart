import 'package:AccessAbility/accessability/presentation/widgets/bottomSheetWidgets/safety_assist_helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:AccessAbility/accessability/firebaseServices/models/emergency_contact.dart';
import 'package:AccessAbility/accessability/logic/bloc/emergency/bloc/emergency_bloc.dart';
import 'package:AccessAbility/accessability/logic/bloc/emergency/bloc/emergency_event.dart';
import 'package:AccessAbility/accessability/logic/bloc/emergency/bloc/emergency_state.dart';
import 'package:provider/provider.dart';
import 'package:AccessAbility/accessability/themes/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SafetyAssistWidget extends StatefulWidget {
  final String uid;
  const SafetyAssistWidget({Key? key, required this.uid}) : super(key: key);

  @override
  State<SafetyAssistWidget> createState() => _SafetyAssistWidgetState();
}

class _SafetyAssistWidgetState extends State<SafetyAssistWidget> {
  // Boolean state variable to determine which design to display
  bool _showHelper = false;

  // Add a controller for the DraggableScrollableSheet.
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EmergencyBloc>(context)
        .add(FetchEmergencyContactsEvent(uid: widget.uid));
  }

  void _showAddEmergencyContactDialog() {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final arrivalController = TextEditingController();
    final updateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("add_emergency_contact".tr()),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "name".tr()),
                ),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: "location".tr()),
                ),
                TextField(
                  controller: arrivalController,
                  decoration: InputDecoration(labelText: "arrival".tr()),
                ),
                TextField(
                  controller: updateController,
                  decoration: InputDecoration(labelText: "update".tr()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("cancel".tr()),
            ),
            ElevatedButton(
              onPressed: () {
                final contact = EmergencyContact(
                  name: nameController.text,
                  location: locationController.text,
                  arrival: arrivalController.text,
                  update: updateController.text,
                );
                BlocProvider.of<EmergencyBloc>(context).add(
                  AddEmergencyContactEvent(uid: widget.uid, contact: contact),
                );
                Navigator.of(context).pop();
              },
              child: Text("add".tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return DraggableScrollableSheet(
      controller: _draggableController,
      // Use different initial sizes based on whether the helper is showing.
      initialChildSize: _showHelper ? 0.8 : 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              // Toggle between the helper widget and the main design.
              child: _showHelper
                  ? SafetyAssistHelperWidget(
                      onBack: () {
                        setState(() {
                          _showHelper = false;
                        });
                        _draggableController.animateTo(
                          0.8, // Collapse back to 80% of the screen.
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 2,
                          color: Colors.grey.shade700,
                          margin: const EdgeInsets.only(bottom: 8),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "safety_assist".tr(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            // Help icon toggles the helper widget.
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showHelper = true;
                                });
                                _draggableController.animateTo(
                                  0.8, // Expand the sheet to 80% of the screen.
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Icon(
                                Icons.help_outline,
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF6750A4),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: _showAddEmergencyContactDialog,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.person_add_outlined,
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF6750A4),
                                  size: 30,
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  "add_emergency_contact".tr(),
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        BlocBuilder<EmergencyBloc, EmergencyState>(
                          builder: (context, state) {
                            if (state is EmergencyLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is EmergencyContactsLoaded) {
                              final contacts = state.contacts;
                              if (contacts.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "no_emergency_contacts".tr(),
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                );
                              }
                              return Column(
                                children: contacts.map((contact) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          child: Icon(Icons.person,
                                              color: Colors.white),
                                        ),
                                        title: Text(
                                          contact.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              contact.location,
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              contact.arrival,
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              contact.update,
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.call,
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : const Color(
                                                          0xFF6750A4)),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.message,
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : const Color(
                                                          0xFF6750A4)),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                if (contact.id != null) {
                                                  BlocProvider.of<
                                                              EmergencyBloc>(
                                                          context)
                                                      .add(
                                                          DeleteEmergencyContactEvent(
                                                              uid: widget.uid,
                                                              contactId:
                                                                  contact.id!));
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                    ],
                                  );
                                }).toList(),
                              );
                            } else if (state is EmergencyOperationError) {
                              return Text(
                                state.message,
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
