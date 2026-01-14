class Userlogmodel  {
   final String id;
   final String log;
   final DateTime  time;
   final String status;
   final String logo;

   Userlogmodel({
    required this.id,
    required this.log,
    required this.status,
    required this.time,
    required this.logo
   });

   factory Userlogmodel.fromJson(Map<String,dynamic> json){
    return Userlogmodel(
      id: json['_id'],
      log: json['log'], 
      status: json['status'], 
      time: DateTime.parse(json['time']),
       logo: json['logo']
       );
   }

}