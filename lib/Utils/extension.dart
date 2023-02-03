extension IntExtension on int{
  
  String secondsToTimeString(){
    int hours = (this / 3600).floor();
    int remainingSeconds = this - (hours * 3600);
    int minutes = (remainingSeconds / 60).floor();
    remainingSeconds = remainingSeconds - (minutes * 60);

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

}