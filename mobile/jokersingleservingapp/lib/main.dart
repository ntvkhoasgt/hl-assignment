import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JokePage(),
    );
  }
}

class JokePage extends StatefulWidget {
  @override
  _JokePageState createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  bool isFunny = false;
  int textIndex = 0;
  bool canVote = true;

  List<String> textList = [
    'A child asked his father, "How were people born?" So his father said, '
        '"Adam and Eve made babies, then their babies became adults and made babies, '
        'and so on." The child then went to his mother, asked her the same question, '
        'and she told him, "We were monkeys then we evolved to become like we are now." '
        'The child ran back to his father and said, "You lied to me!" His father replied, '
        '"No, your mom was talking about her side of the family."',
    'Teacher: "Kids,what does the chicken give you?" Student: "Meat!" Teacher:'
        ' "Very good! Now what does the pig give you?" Student: "Bacon!" Teacher: '
        '"Great! And what does the fat cow give you?" Student: "Homework!"',
    'The teacher asked Jimmy, "Why is your cat at school today Jimmy?" Jimmy '
        'replied crying, "Because I heard my daddy tell my mommy, '
        '"I am going to eat that pussy once Jimmy leaves for school today!"',
    'A housewife, an accountant and a lawyer were asked "How much is 2+2?" '
        'The housewife replies: "Four!". The accountant says: '
        '"I think it either 3 or 4. Let me run those figures through my spreadsheet one more time." '
        'The lawyer pulls the drapes, dims the lights and asks in a hushed voice, '
        '"How much do you want it to be?"',
    '''"That's all the jokes for today! Come back another day!"'''
  ];

  Future<void> updateText(bool isFunny) async {
    if (canVote) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Save the vote to the database
      await DatabaseHelper.instance
          .createResponse(textList[textIndex], isFunny);

      setState(() {
        if (textIndex < 4) {
          textIndex = textIndex + 1;
          prefs.setInt('textIndex', textIndex);
        } else {
          canVote = false; // Disable voting for the day
          prefs.setString('lastVoteDate', DateTime.now().toIso8601String());
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkVotingLimit();
  }

  // Check if the user has voted today
  Future<void> _checkVotingLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime lastVoteDate =
        DateTime.tryParse(prefs.getString('lastVoteDate') ?? '') ??
            DateTime.now().subtract(Duration(days: 1));

    DateTime now = DateTime.now();

    textIndex = prefs.getInt('textIndex') ?? 0;
    // If the last vote date is not today, reset voting
    if (lastVoteDate.day != now.day ||
        lastVoteDate.month != now.month ||
        lastVoteDate.year != now.year) {
      setState(() {
        canVote = true; // Allow voting
      });
    } else {
      setState(() {
        canVote = false; // Don't allow voting until the next day
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 1000));

    return ScreenUtilInit(
        enableScaleWH: ()=> true,
        enableScaleText: ()=> false,
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0).h,
                  child: Image.asset(
                    'res/logo.png', // Replace with your logo path
                    height: 40.h,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0).h,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('res/avatar.jpg'),
                    // Replace with your avatar image path
                    radius: 20,
                  ),
                ),
              ],
            ),
            (!canVote || textIndex == 4)
                ? SizedBox(
                    height: 150.h,
                  )
                : Container(
                    color: Colors.green,
                    width: double.infinity,
                    height: 150.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 15.h), // <-- Set height
                        Text("A joke a day keeps the doctor away",
                            style: TextStyle(fontSize: 16.sp)),
                        Text(
                          "If you joke wrong way, your teeth have to pay. (Serious)",
                          style: TextStyle(fontSize: 10.sp),
                        ),
                        SizedBox(height: 15.h), // <-- Set height
                      ],
                    ),
                  ),
          ],
        ),
        toolbarHeight: 250.h, // Adjusted height for the column
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0).h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8).h,
              height: 250.h,
              child: Text(
                (!canVote || textIndex == 4)
                    ? textList[4]
                    : textList[textIndex],
                style: TextStyle(
                    fontSize: 13.sp, height: 1.2.sp, wordSpacing: 0.1.sp),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                (!canVote || textIndex == 4)
                    ? const SizedBox()
                    : Container(
                      color: Colors.transparent,
                      child: ElevatedButton(
                          onPressed: () => updateText(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            side: BorderSide(color: Colors.blue, width: 2.h), // Border color and width
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Optional: To make the corners rounded
                            ),
                          ),
                          child: Text("This is Funny!",
                            style: TextStyle(fontSize: 13.sp, color: Colors.white),),
                        ),
                    ),
                (!canVote || textIndex == 4)
                    ? const SizedBox()
                    : ElevatedButton(
                  onPressed: () => updateText(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    side: BorderSide(color: Colors.green, width: 2.h), // Border color and width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Optional: To make the corners rounded
                    ),
                  ),
                  child: Text("This is not Funny.", style: TextStyle(fontSize: 13.sp, color: Colors.white),),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 250.h,
        child: Padding(
          padding: EdgeInsets.fromLTRB(6, 3, 6, 0).h,
          child: Text(
            "This app is created as part of HLSolutions program. The materials contained "
            "on this website are provided for general information only and do not "
            "constitute any form of advice. HLS assumes no responsibility for the accuracy "
            "of any particular statement and accepts no liability for any loss or damage which may arise "
            "from reliance on the information contained on this site.\n\nCopyright 2021 HLS",
            style: TextStyle(fontSize: 9.sp),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }
}
