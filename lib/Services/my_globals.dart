library my_prj.globals;
bool printerState = false;

String ipToUse = "";
String ipToUse_Version = "";
String username ="";
String password = "";
String fullName = "";
String userID = "";
List loginList = [];
List productsList = [];
List agentsList = [];
List invoicesList = [];

String accountCodes = "";
var ipAddress = "";


RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
String Function(Match) mathFunc = (Match match) => '${match[1]},';