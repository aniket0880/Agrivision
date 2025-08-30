import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetectionPage extends StatefulWidget {
  final String serviceName;
  final String detectedDisease;

  DetectionPage({required this.serviceName, required this.detectedDisease});

  @override
  _DetectionPageState createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  String solution = "";
  String youtubeUrl = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPredictionData();
  }

  Future<void> fetchPredictionData() async {
    try {
      final diseaseSnapshot = await FirebaseFirestore.instance
          .collection('predictions')
          .where('disease', isEqualTo: widget.detectedDisease)
          .limit(1)
          .get();

      if (diseaseSnapshot.docs.isNotEmpty) {
        final diseaseData = diseaseSnapshot.docs.first.data();
        solution = diseaseData['solution'] ?? "";
        youtubeUrl = diseaseData['ytlink'] ?? "";
        print("Fetched YouTube URL: $youtubeUrl");
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _launchYouTube() async {
    if (await canLaunch(youtubeUrl)) {
      await launch(youtubeUrl, forceSafariVC: false, forceWebView: false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open video')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('${widget.serviceName} Detection Result'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detected Disease for ${widget.serviceName}:',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                widget.detectedDisease,
                style:
                TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
              SizedBox(height: 20),
              Text(
                'Possible Solutions:',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                solution,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Watch the video for more solutions:',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              youtubeUrl.isNotEmpty
                  ? ElevatedButton.icon(
                onPressed: _launchYouTube,
                icon: Icon(Icons.play_arrow),
                label: Text('Open Video'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
              )
                  : Text('No video available.'),
            ],
          ),
        ),
      ),
    );
  }
}
