import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class BudgetController extends GetxController {
  // Variables
  RxDouble monthlyBudget = RxDouble(100);
  RxDouble expectedCPC = RxDouble(0.1);
  RxDouble conversionRate = RxDouble(0.1);
  RxDouble averageSalePrice = RxDouble(100);
  RxDouble leadToCustomerRate = RxDouble(1.0);


  RxInt numberOfClicks = RxInt(0);
  RxDouble numberOfLeads = RxDouble(500);
  RxDouble costPerLead = RxDouble(0.0);
  RxDouble valueOfALead = RxDouble(1);
  RxDouble expectedRevenue = RxDouble(1);
  RxDouble expectedProfit = RxDouble(-99);
  RxDouble returnOnAdSpend = RxDouble(0.0);

  // Function to calculate values
  void calculateValues() {
    numberOfClicks.value = monthlyBudget.value ~/ expectedCPC.value;
    numberOfLeads.value = numberOfClicks.value * (conversionRate.value / 100);
    costPerLead.value = monthlyBudget.value != 0 ? monthlyBudget.value / numberOfLeads.value : 0;
    valueOfALead.value = averageSalePrice.value * (leadToCustomerRate.value / 100);
    expectedRevenue.value = numberOfLeads.value * valueOfALead.value;
    expectedProfit.value = expectedRevenue.value - monthlyBudget.value;
    returnOnAdSpend.value = ((expectedRevenue.value - monthlyBudget.value) / monthlyBudget.value) * 100;
    update();
  }
}

class MyHomePage extends StatelessWidget {
  final BudgetController budgetController = Get.put(BudgetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Slider for Projected Monthly Budget
              Text("Number of clicks: ${budgetController.numberOfClicks.round()}"),
              SizedBox(height: 20,),
              Text("Number of leads: ${budgetController.numberOfLeads.round()}"),
              SizedBox(height: 20,),
          
              Text("Cost per leads: ${budgetController.costPerLead.round()}"),
              SizedBox(height: 20,),
              Text("Value of a leads: ${budgetController.valueOfALead.round()}"),
              SizedBox(height: 20,),
              Text("Expected Revenue: ${budgetController.expectedRevenue.round()}"),
              SizedBox(height: 20,),
              Text("Expected Profit: ${budgetController.expectedProfit.round()}"),
              SizedBox(height: 20,),
              Card(
                  color: Colors.orange,
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Return On AdSpend: ${budgetController.returnOnAdSpend.round()}%",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              )),
              SizedBox(height: 20,),
              Text("Projected Monthly Budget: \$ ${budgetController.monthlyBudget.round()}"),
              SizedBox(height: 20,),
              Slider(
                value: budgetController.monthlyBudget.value,
                min: 100.0,
                max: 50000.0,
                divisions:20,
                onChanged: (value) {
                  // Update the monthlyBudget value when the slider is changed
                  budgetController.monthlyBudget.value = value;
                  // Recalculate other values
                  budgetController.calculateValues();
                },
              ),
              SizedBox(height: 20,),
          
              Text("Expected CPC: \$ ${budgetController.expectedCPC}"),
              SizedBox(height: 20,),
              Slider(
                value: budgetController.expectedCPC.value,
                min: 0.1,
                max: 50,
                // divisions: 1,
          
                onChanged: (value) {
                  // Update the monthlyBudget value when the slider is changed
                  budgetController.expectedCPC.value = value;
                  // Recalculate other values
                  budgetController.calculateValues();
                },
              ),
          
              Text("Target Conversion Rate: ${budgetController.conversionRate}%"),
              SizedBox(height: 20,),
              Slider(
                value: budgetController.conversionRate.value,
                min: 0.1,
                max: 50,
                onChanged: (value) {
                  // Update the monthlyBudget value when the slider is changed
                  budgetController.conversionRate.value = value;
                  // Recalculate other values
                  budgetController.calculateValues();
                },
              ),
          
              Text("Average Sale Price: \$ ${budgetController.averageSalePrice.round()}"),
              SizedBox(height: 20,),
              Slider(
                value: budgetController.averageSalePrice.value,
                min: 100,
                max: 100000.0,
                onChanged: (value) {
                  // Update the monthlyBudget value when the slider is changed
                  budgetController.averageSalePrice.value = value;
                  // Recalculate other values
                  budgetController.calculateValues();
                },
              ),
          
          
              Text("Lead to Customer Rate: ${budgetController.leadToCustomerRate.round()}%"),
              SizedBox(height: 20,),
              Slider(
                value: budgetController.leadToCustomerRate.value,
                min: 1,
                max: 90.0,
                onChanged: (value) {
                  // Update the monthlyBudget value when the slider is changed
                  budgetController.leadToCustomerRate.value = value;
                  // Recalculate other values
                  budgetController.calculateValues();
                },
              ),
              // Display the current value of the slider
          
          
              // Other UI elements...
            ],
          ),
        ))
      ),
    );
  }
}