# Coffee Hopping

![Coffee Hopping](logo.jpg)

Based on the idea of [Pub Crawl](https://en.wikipedia.org/wiki/Pub_crawl), I love coffee, so I made an app for find and discover new coffee shops near using the Google Places API.

# Versions:
- Using Xcode >= Version 12.4 (12D4e)

# Run the app

1. Run on your terminal: `pod install` - (I used some external packages)
2. Open `CoffeeHopping.xcworkspace` on your Xcode
3. Configure the `static let API_KEY = ""` on `Networking/GoogleClient.swift` with an Google Places API
3. Hit the Run button on Xcode to run on your device or simulator (suggestion: iPhone 12 Pro Max)

# How to use
- Open the app and enable the location
- Scroll the map and wait for coffee shop pins to popup on the map
- Click on some coffee shop and enter the page
- On the coffee shop page you can read some Google users reviews
- Tapping on the map on the navigation bar will redirect you to Waze navigation, if not installed it will redirect to Waze on the App Store
- Tapping on the Star on the navigation bar will open the review input, you can review the coffee shop that you visited
- You can delete the review swiping to the right on the review row

- Also you can see on the "Visited Coffee shops tab the coffee shows that you visited.
- You can remove any coffee shop swiping to the right.

# Video Demo
I made a simple demo and upload it on youtube https://youtu.be/yNxmEO51rAs


Have fun :)