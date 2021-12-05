import 'dart:io';

import 'package:contact_list/helpers/contact_helper.dart';
import 'package:contact_list/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper.internal();

  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
              onSelected: _orderList,
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
            const PopupMenuItem<OrderOptions>(
                child: Text("Ordernard de A-Z"),
                value: OrderOptions.orderaz,
            ),
             const PopupMenuItem<OrderOptions>(
                  child: Text("Ordernard de Z-A"),
                  value: OrderOptions.orderza,
                )
          ]),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: _contactCard,
        padding: EdgeInsets.all(10.0),
      ),
    );
  }

  Widget _contactCard(context, int index) {
    return GestureDetector(
      onTap: () {
        _showOptions(context, index);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contacts[index].img != null
                            ? FileImage(File(contacts[index].img!))
                            : Image
                            .asset('assets/person.png')
                            .image)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contacts[index].name ?? "",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].email ?? "",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      contacts[index].phone ?? "",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact,)),
    );
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((value) {
      setState(() {
        contacts = value;
      });
    });
  }

  void _showOptions(context, int index) {
    showModalBottomSheet(context: context,
      builder: (context) {
      return BottomSheet(
          onClosing: (){},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      child: Text("Ligar",
                        style: TextStyle(color: Colors.red, fontSize: 18.0),),
                      onPressed: (){
                        launch("tel:${contacts[index].phone}");
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      child: Text("Editar",
                        style: TextStyle(color: Colors.red, fontSize: 18.0),),
                      onPressed: (){
                        Navigator.pop(context);
                        _showContactPage(contact: contacts[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      child: Text("Excluir",
                        style: TextStyle(color: Colors.red, fontSize: 18.0),),
                      onPressed: (){
                          helper.deleteContact(contacts[index].id!);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                      },
                    ),
                  )
                ],
              ),
            );
          });
      },);
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        setState(() {
          contacts.sort((a, b) {
            a.name = a.name ?? "";
            b.name = b.name ?? "";
            return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());

          });
        });
        break;
      case OrderOptions.orderza:
        setState(() {
          contacts.sort((a, b) {
            a.name = a.name ?? "";
            b.name = b.name ?? "";
            return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
          });
        });
        break;
    }
  }
}
