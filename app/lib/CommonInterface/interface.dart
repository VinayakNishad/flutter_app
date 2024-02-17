import 'package:flutter/material.dart';
import '../Admin/loginAsAdmin.dart';
import '../Council/loginAsCouncilMember.dart';
import '../Student/loginAsStudent.dart';
import '../Council/loginAsTeacher.dart';


const List<String> list = <String>['Login As Student', 'Login As Council member',
  'Login As Admin', 'Login As Teacher'];

void main() => runApp(const DropdownMenuApp());

class DropdownMenuApp extends StatelessWidget {
  const DropdownMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(
            child: DropdownMenuExample(),
          ),
        ),
      ),
    );
  }
}

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
        if (value == 'Login As Student') {
          // Navigate to student screen
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>const MyLogin()));
        }
        else if(value=='Login As Council member'){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>const LoginAsCM()));
        }
        else if(value=='Login As Admin'){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>const MyLoginAsAdmin()));
        }
        else{
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=>const MyLoginAsTeacher()));
        }
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
