
List getAgentsDetailsLists(List alist){
  List agentsIDList = [];
  List agentsNameList = [];
  List agentsIsGeneralList = [];

  agentsIDList.add("-- Select Id --");
  agentsNameList.add("-- Select Agent --");
  agentsIsGeneralList.add("-- Select Is ge--");

  for(int i=0; i<alist.length;i++){
    agentsIDList.add(alist[i]["AgentID"]);
    agentsNameList.add("${i+1} "+alist[i]["AgenttName"]);
    agentsIsGeneralList.add(alist[i]["IsGeneral"]);
  }
  List mainList = [];
  mainList.add(agentsIDList);mainList.add(agentsNameList);mainList.add(agentsIsGeneralList);
  return mainList; //loan, Savings
}


List getProductsDetailsLists(List alist){
  List productIDList = [];
  List productNameList = [];
  List productPriceList = [];
  List productCodeList = [];
  List productBalList = [];
  List productValidList = [];

  productIDList.add("-- Select Id --");
  productNameList.add("-- Select Item --");
  productPriceList.add("-- Select Price--");
  productCodeList.add("-- Select Code--");
  productBalList.add("-- Select Bal--");
  productValidList.add("-- Select Val--");


  for(int i=0; i<alist.length;i++){
    productIDList.add(alist[i]["productID"]);
    productNameList.add("${i+1} "+alist[i]["productName"]);
    productPriceList.add(alist[i]["price"]);
    productCodeList.add(alist[i]["productCode"]);
    productBalList.add(alist[i]["Balance"]);
    productValidList.add(alist[i]["Validate_Balance"]);

  }
  List mainList = [];
  mainList.add(productIDList);mainList.add(productNameList);mainList.add(productPriceList);
  mainList.add(productCodeList);mainList.add(productBalList);mainList.add(productValidList);
  return mainList; //loan, Savings
}

String getInvoiceAmountSum(List alist){
  //List to display
  double total = 0.0;

  for(int i=0; i<alist.length;i++){
    total = (double.parse(alist[i]["qty"]) * double.parse(alist[i]["unitPrice"])) + total;
  }
  return total.toString();
}


String getAccountsCodes(List accountsList){
  //List to display
  String codes = "";

  for(int i=0; i<accountsList.length;i++){
    codes = "${codes + accountsList[i]["OutPut8"]},";
  }
  return codes.substring(0,codes.length -1);
}



List getSingleProdTypeList(List allProductTypes,){
  //List to display
  var _allProductTypesIdDict = {};
  List _mainResultList = [];

  List _allProductTypesList = [];
  _allProductTypesList.add("-- Select Product type --");
  _allProductTypesIdDict["-- Select Product type --"] = "0";

  for(int i=0; i<allProductTypes.length;i++){
    _allProductTypesList.add(allProductTypes[i]["Category"]);
    _allProductTypesIdDict[allProductTypes[i]["Category"]] = allProductTypes[i]["ID"];
  }

  _mainResultList.add(_allProductTypesList);_mainResultList.add(_allProductTypesIdDict);
  return _mainResultList;
}

List getSingleStoreNameList(List allStoreNames,){
  //List to display
  var _allStoreNamesIdDict = {};
  List _mainResultList = [];

  List _allStoreNamesList = [];
  _allStoreNamesList.add("--- Select Store ---");
  _allStoreNamesIdDict["--- Select Store ---"] = "0";

  for(int i=0; i<allStoreNames.length;i++){
    _allStoreNamesList.add(allStoreNames[i]["RawMaterialStore"]);
    _allStoreNamesIdDict[allStoreNames[i]["RawMaterialStore"]] = allStoreNames[i]["ID"];
  }

  _mainResultList.add(_allStoreNamesList);_mainResultList.add(_allStoreNamesIdDict);
  return _mainResultList;

}

List getAgentsNameList(List allAgentsNames,){
  //List to display
  var _allAgentsNamesIdDict = {};
  List _mainResultList = [];

  List _allAgentsNamesList = [];
  _allAgentsNamesList.add("--- Select Agent ---");
  _allAgentsNamesIdDict["--- Select Agent ---"] = "0";

  for(int i=0; i<allAgentsNames.length;i++){
    _allAgentsNamesList.add(allAgentsNames[i]["Agent"]);
    _allAgentsNamesIdDict[allAgentsNames[i]["Agent"]] = allAgentsNames[i]["ID"];
  }

  _mainResultList.add(_allAgentsNamesList);_mainResultList.add(_allAgentsNamesIdDict);
  return _mainResultList;

}










