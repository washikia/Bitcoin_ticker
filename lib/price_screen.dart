import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedValue = "EUR";
  String responseRate0 = "?";
  String responseRate1 = '?';
  String responseRate2 = '?';
  String convertFrom = "BTC";
  var rateList = [];

  DropdownButton getAndroidPicker(){
    List<DropdownMenuItem<String>> itemsList = [];
    String currency;
    for (currency in currenciesList) {
      DropdownMenuItem<String> newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      itemsList.add(newItem);
    }
    return DropdownButton<String>(
        value: selectedValue,
        items: itemsList,
        onChanged: (value) {
          setState(() {
            selectedValue = value!;
            getRate(value!);
          });
        });
  }

  CupertinoPicker getIosPicker(){
    List<Text> itemsList = [];
    String currency;
    for (currency in currenciesList) {
      itemsList.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedValue = currenciesList[selectedIndex];
          getRate(selectedValue);
        });;
      },
      children: itemsList,
    );
  }

  List<Card> rateButton(){
    List<Card> ret = [];
    int i;
    String temp;
    for (i=0; i<cryptoList.length; ++i){
      if(i==0) temp=responseRate0;
      else if(i==1) temp=responseRate1;
      else temp=responseRate2;
      ret.add(
          Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
              child: Text(
                textAlign: TextAlign.center,
                '1 ${cryptoList[i]} = ${temp} $selectedValue',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),),
            ),
          )
      );
    }
    return ret;
  }

  void getRate(String convertTo) async {
    try{
      CoinData coindata = CoinData();
      setState(() async{
        // rateList.clear();
        rateList = [];
        convertFrom = cryptoList[0];
        var rate = await coindata.getCoinData(convertFrom, convertTo);
        responseRate0 = rate.toStringAsFixed(0);
        rateList.add(responseRate0);

        convertFrom = cryptoList[1];
        rate = await coindata.getCoinData(convertFrom, convertTo);
        responseRate1 = rate.toStringAsFixed(0);
        rateList.add(responseRate1);

        convertFrom = cryptoList[2];
        rate = await coindata.getCoinData(convertFrom, convertTo);
        responseRate2 = rate.toStringAsFixed(0);
        rateList.add(responseRate2);
      });
    }
    catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRate(selectedValue);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              children: rateButton(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIosPicker(): getAndroidPicker(),
          ),
        ],
      ),
    );
  }
}


