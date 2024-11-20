import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage('https://i.pinimg.com/474x/ae/5b/48/ae5b48b7d8667818e86f51d4277c3034.jpg'),
                  fit:BoxFit.cover
              )
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 80,vertical: 50),
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(blurRadius: 30, color: Colors.black)],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('https://www.thoughtco.com/thmb/ic_z5yRJDp8uOfPONAEeXqsOC8s=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-116051299-2693a29a440e4bdab4ee7f10c5f62dc5.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20,top: 30,left: 20,right: 20),
                child: Center(
                  child: Text('"If I know what love is, it is because of you"',style:GoogleFonts.oswald(fontSize:50)),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 300, // Adjust width as needed
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.brown, // Background color of the oval
                    borderRadius: BorderRadius.circular(75), // Half of the height to make it oval
                  ),
                  child: Center(
                    child: Text(
                      '~Hermann Hesse~',style: GoogleFonts.acme(fontSize:30,color:Colors.white),
                    ),
                  )
              )
            ],
          ),
        )
    );
  }
}
