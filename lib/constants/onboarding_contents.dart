class OnboardingContents {
  String header;
  String desc;
  String image;

  OnboardingContents(
      {required this.header, required this.desc, required this.image});
}

List<OnboardingContents> contents = [
  OnboardingContents(
    header: "RUN 2024",
    desc:
        "Welcome to Calvary Chapel Youth Conference 2024! It is always exciting to work with group of leaders and worship the Lord!",
    image: "assets/runfinal.json",
  ),
  OnboardingContents(
    header: "Introducing YCSS",
    desc:
        "Designed to enhance your experience and interaction throughout the event. Track team scores and progress amongst your peers.",
    image: "assets/scoreball.json",
  ),
  OnboardingContents(
    header: "Score with Joy!",
    desc:
        "\"Worship the Lord with gladness; come before him with joyful songs. Know that the Lord is God. It is he who made us, and we are his. We are his people, The sheep of his pasture. \" -Psalm 100:2-3  ",
    image: "assets/friends.json",
  ),
];
