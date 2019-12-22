The README file of the iOS app for DinnerSystem.

DinnerSystem iOS App
====================
[![codebeat badge](https://codebeat.co/badges/cbd2cad9-81cf-4853-98b6-c586baadcf12)](https://codebeat.co/projects/github-com-seanpai96-dinnersys-ios-master)

Introduction
------------

  It's the first project for me and I'm glad it can be better and better. I know it is not as good as the commercial-apps outside, but I think it's good enough for me. Of course, it needs to be going on for much more functionalities, but since I'm also currently learning Kotlin(Android) by myself, I choose to pause the thinking of adding more things in the App until I made the Android version useable or I get any further instructions. Of course, I'll fix the bug immediately when I found it, since its stable now, so I think I won't make too many changes here recently. (Or will I?)
  The iOS App for DinnerSystem is just a frontend. It doesn't do many processes, as long as it can communicate correctly with the server(backend). It simply just fetch the data from the server and parse it as a JSON structure. After parsing, it turns into user-accessible data and shows it to the user by TableView.
  
Used APIs
---------
  I use Alamofire for the network communicating API since it's simple and doesn't need many configuration. JSON Parser is using Swift's standard JSONDecoder and Ahmed-Ali's JSONExport to generate Codeable class structure. I use Firebase for user analytics and crash reporting.  

