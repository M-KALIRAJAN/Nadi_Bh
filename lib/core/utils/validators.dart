class Validators{
  static String? email(String? value){
    if(value == null || value.isEmpty) return " Enter The Email";

     final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      if(!regex.hasMatch(value)) return " Invalid Email Formet";
      return null;
  
  }

  static String? Password (String? value){
    if(value == null || value.isEmpty) return "Enter The Password";
    if(value.length < 6) return "Password must be 6+ chars";
     return null ;
  } 

  static String? phonenumber (String? value){
    if(value == null || value.isEmpty) return "Enter The Number";
    if(value.length != 8) return "Mobile must be 8 digits";
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return "Only digits Allowed";
    return null ;
  }
}