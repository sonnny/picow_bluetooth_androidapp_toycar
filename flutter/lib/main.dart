
// driving control
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './blecontroller.dart';

const List<Widget> steering = <Widget>[
  Text('<<'),
  Text('<'),
  Text('center'),
  Text('>'),
  Text('>>'),
];

const List<Widget> shift = <Widget>[
  Text('D1'),
  Text('D2'),
  Text('D3'),
  Text('D4'),
  Text('D5'),

];

late BleController ble;
void main() => runApp(const ToggleButtonsExampleApp());

class ToggleButtonsExampleApp extends StatelessWidget {
  const ToggleButtonsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToggleButtonsSample(title: 'Pico W demo'),
    );
  }
}

class ToggleButtonsSample extends StatefulWidget {
  const ToggleButtonsSample({super.key, required this.title});

  final String title;

  @override
  State<ToggleButtonsSample> createState() => _ToggleButtonsSampleState();
}

class _ToggleButtonsSampleState extends State<ToggleButtonsSample> {

  final List<bool> selectedSteering = <bool>[false, false, true, false, false];
  final List<bool> selectedShift = <bool>[true, false, false, false, false];
  List<int> packet = [0, 0];

  @override
  Widget build(BuildContext context) {
    ble = Get.put(BleController());
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: appBarActions(context, ble)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              Text('Important!', style: TextStyle(color: Colors.red, fontSize: 35, fontWeight: FontWeight.bold)),
              Text('pick picow ble mac address in upper right corner'),
              Text('before continuing'),
             
              const SizedBox(height: 10),
              
              /********* row connect, led on, led off **********/
              Row(mainAxisAlignment:MainAxisAlignment.center, children:[
              
                ElevatedButton(onPressed: ble.connect, 
                child: Obx(()=>Text('${ble.status.value}'))),
                
                IconButton(
          icon: const Icon(Icons.lightbulb, color:Colors.green),
          iconSize: 50.0,
          tooltip: 'stop',
          onPressed: () {packet[0]=0x6c; packet[1]=0x6f; ble.send(packet);}),   
          
               IconButton(
          icon: const Icon(Icons.lightbulb_outline, color:Colors.green),
          iconSize: 50.0,
          tooltip: 'stop',
          onPressed: () {packet[0]=0x6c; packet[1]=0x66; ble.send(packet);}),   
                
              ]),
           
              const SizedBox(height: 5),
             // Text('steering', style: theme.textTheme.titleSmall),
              
              /*********** steering toggle button widget *****************/
              const SizedBox(height: 5),
              ToggleButtons(
                direction: Axis.horizontal,
                //direction: vertical ? Axis.vertical : Axis.horizontal,
                onPressed: (int index) {
                  switch(index){
                    case 0: packet[1]=0x00; break;
                    case 1: packet[1]=0x01; break;
                    case 2: packet[1]=0x02; break;
                    case 3: packet[1]=0x03; break;
                    case 4: packet[1]=0x04; break;
                  }
                  packet[0]=0x73;
                  ble.send(packet);
                  
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < selectedSteering.length; i++) {
                      selectedSteering[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.red[700],
                selectedColor: Colors.white,
                fillColor: Colors.red[200],
                color: Colors.red[400],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 60.0,
                ),
                isSelected: selectedSteering,
                children: steering,
              ),
 
            const SizedBox(height: 5),
            
              /************** driving toggle button widget *************/
              const SizedBox(height: 5),
              ToggleButtons(
                direction: Axis.vertical,
                //direction: vertical ? Axis.vertical : Axis.horizontal,
                onPressed: (int index) {
                  switch(index){
                    case 0: packet[1]=0x01; break;
                    case 1: packet[1]=0x02; break;
                    case 2: packet[1]=0x03; break;
                    case 3: packet[1]=0x04; break;
                    case 4: packet[1]=0x05; break;
                  }
                  packet[0] = 0x64;
                  ble.send(packet);
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < selectedShift.length; i++) {
                      selectedShift[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.purple[700],
                selectedColor: Colors.white,
                fillColor: Colors.purple[200],
                color: Colors.purple[400],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: selectedShift,
                children: shift,
              ),
              
              const SizedBox(height: 10),
              
              /************* stop button ************/
               IconButton(
          icon: const Icon(Icons.hexagon, color:Colors.red),
          iconSize: 50.0,
          tooltip: 'stop',
          onPressed: () {packet[0]=0x68; packet[1]=0x00; ble.send(packet);}),            

          const SizedBox(height: 10),
       ElevatedButton(onPressed: (){packet[0]=0x72; packet[1]=0x00; ble.send(packet);}, child: 
       Text('reverse')),    
              
            ]))));}
  
    List<Widget> appBarActions(BuildContext context, BleController ble ) {
    return [
      PopupMenuButton<String>(
        itemBuilder: (_) {
          return const [
            PopupMenuItem<String>(value: "28:CD:C1:01:54:E7", child: Text("1")),
            PopupMenuItem<String>(value: "28:CD:C1:01:8D:5D", child: Text("7")),
            PopupMenuItem<String>(value: "28:CD:C1:04:E8:51", child: Text("3")),
            PopupMenuItem<String>(value: "28:CD:C1:04:E8:50", child: Text("4")),
            PopupMenuItem<String>(value: "28:CD:C1:08:28:9C", child: Text("5")),
            PopupMenuItem<String>(value: "28:CD:C1:00:E7:A0", child: Text("8")),
          ];
        },
        icon: const Icon(Icons.bluetooth),
        onSelected: (i) {ble.setMac(i);},
        //onCanceled: () => displayBar(context,"Cancelled",cancel: true),
      )];}}
