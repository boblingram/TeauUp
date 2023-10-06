import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/src/hexcolor_base.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/widgets/rounded_edge_button.dart';

class MultiSelectContacts extends StatefulWidget {
  final List<Contact> contactsList;
  final Color? selectedColor;
  MultiSelectContacts({Key? key, required this.contactsList, this.selectedColor}) : super(key: key);

  @override
  State<MultiSelectContacts> createState() => _MultiSelectContactsState();
}

class _MultiSelectContactsState extends State<MultiSelectContacts> {
  TextEditingController searchTextController = TextEditingController();
  var selectedContactList = <Contact>[].obs;

  var searchContacts = <Contact>[].obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    print("Search Query is $query");
    searchContacts.clear();
    if (query.isNotEmpty) {
      widget.contactsList.forEach((element) {
        if ((element.displayName?.toLowerCase() ?? "").contains(query.toLowerCase())) {
          searchContacts.add(element);
        }
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 15.w,
              width: double.infinity,
              child: Stack(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.cancel,
                      )),
                  Center(
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: Text(
                          "Add Members",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w700),
                        )),
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(5.w, 0, 5.w, 2.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: searchTextController,
                  onChanged: (String val) {
                    filterSearchResults(val);
                  },
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    hintText: "Search Name",
                    border: InputBorder.none,
                    hoverColor: Colors.grey,
                    hintStyle: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black26,
                        fontWeight: FontWeight.w500),
                  ),
                )),
            Obx(() => Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            "Added ${selectedContactList.length}/${widget.contactsList.length}",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13.sp),
                          )),
                      SizedBox(
                        height: selectedContactList.value.isEmpty ? 0 : 30,
                        child: ListView.builder(
                          itemCount: selectedContactList.value.length,
                          itemBuilder: (context, position) {
                            return Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                              child: Text(
                                "${selectedContactList.value.elementAt(position).displayName ?? ""}${(position == (selectedContactList.length - 1) ? "" : ",")} ",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
                child: Obx(()=>searchContacts.isEmpty ? getSearchList(widget.contactsList) : getSearchList(searchContacts))),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: RoundedEdgeButton(
              backgroundColor: widget.selectedColor ?? Colors.red,
              text: "Done",
              leftMargin: 20,
              buttonRadius: 10,
              rightMargin: 20,
              bottomMargin: 20,
              onPressed: () {
                //Close
                Get.back(result: selectedContactList.value);
              },
              context: context),
        )
      ],
    );
  }

  Widget getSearchList(List<Contact> tempContactList){
    return ListView.builder(
        itemCount: tempContactList.length,
        itemBuilder: (context, position) {
          var individualContact =
          tempContactList.elementAt(position);
          var phoneList = individualContact.phones?.toSet().toList() ?? [];
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: phoneList.length ?? 0 ,
              itemBuilder: (context, position2){
              var phoneDetail = phoneList.elementAt(position2);
            return Container(
              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
              padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: InkWell(
                onTap: () {
                  if (selectedContactList
                      .contains(individualContact)) {
                    selectedContactList.remove(individualContact);
                  } else {
                    selectedContactList.add(individualContact);
                  }
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: widget.selectedColor,
                      child: Text(
                          individualContact.displayName?[0] ?? "A",style: TextStyle(color: Colors.white),),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${individualContact.displayName ?? ""}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                              TextStyle(fontWeight: FontWeight.bold),
                            ),
                            phoneDetail != null ? Text(
                                    "${phoneDetail.value}",
                                    style: TextStyle(fontSize: 10.sp),
                                  ) : Container()
                          ],
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Obx(() => Icon(
                      selectedContactList
                          .contains(individualContact)
                          ? Icons.check_circle_outlined
                          : Icons.circle_outlined,
                      color: selectedContactList
                          .contains(individualContact)
                          ? widget.selectedColor ?? Colors.red
                          : Colors.grey,
                    size: 21.sp,)),
                  ],
                ),
              ),
            );
          });
        });
  }

}
