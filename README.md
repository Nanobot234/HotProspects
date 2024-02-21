# Hot Prospects
![Static Badge](https://img.shields.io/badge/Swift-5.1-red)
![Static Badge](https://img.shields.io/badge/iOS-13.0%2B-blue)


HotProspects is an iOS application that allows users to quickly connect with prospects at events by scanning custom-generated QR codes. "Prospects", as used in this app,  are people whose contact information is saved by the user to be contacted at a later time. 

**To build this project in Xcode, you have to install  CodeScanner as a package. API documentation can be found [here](https://github.com/twostraws/CodeScanner)**

Original idea based on [Hacking with Swift](https://www.hackingwithswift.com/) bootcamp project.

## Architecture

The app follows the Model View ViewModel (MVVM) architectural pattern. Here are the major components

Model: In this app, Prospect is the model which defines basic information of a prosepect that a user adds. THis includes a prospects name, contact information, the date the user met the prospect and more. The model is located in Prospect.swift

View: The primary view of this application is located in the file ProspectsView.swift. This file defines a list which displays the time, date, and location that the user meets all their prospects.

View Model: The view model defines an array of prospects that the user has saved their information. The view model handles insertions, deletions, and storage of the array. The view model is located in the file



## Features

## Generate a custom QR code using a user's name, email, and phone number

<img src="https://github.com/Nanobot234/HotProspects/assets/16675052/a7335b00-12b2-4e2a-a3c9-9332e2d6770e" alt="Descriptive Alt Text" width="300" height="600">

## Scan the QR code of another user to instantly save their contact information and set the event where a user meets a prospect.
<img src="https://github.com/Nanobot234/HotProspects/assets/16675052/f36cbf90-7fde-4fd6-a5cf-184a78cfc44f" alt="Descriptive Alt Text" width="300" height="600">

## Schedule a reminder to contact a particular prospect. 
<img src="https://github.com/Nanobot234/HotProspects/assets/16675052/6aeb6892-7665-4b95-8a85-ef5334c2abdd" alt="Descriptive Alt Text" width="300" height="600">


## Technologies Used
- AVFoundation framework
- APNS
- [CodeScanner](https://github.com/twostraws/CodeScanner) API

 ## Credits

Hot Prospects is originally based on a project created by [Paul Hudson](https://twitter.com/twostraws) who writes [free tutorials in Swift and SwiftUI](https://www.hackingwithswift.com/). 



