# Prospectta
![Static Badge](https://img.shields.io/badge/Swift-5.1-red)
![Static Badge](https://img.shields.io/badge/iOS-13.0%2B-blue)


Prospectta is an iOS application that allows users to quickly connect with prospects at events by scanning custom-generated QR codes. "Prospects", as used in this app,  are people whose contact information is saved by the user to be contacted at a later time. 

**To build this project in Xcode, you have to install  CodeScanner as a package. API documentation can be found [here](https://github.com/twostraws/CodeScanner)**

Original idea based on [Hacking with Swift](https://www.hackingwithswift.com/) bootcamp project.

## Architecture

The app follows the Model View ViewModel (MVVM) architectural pattern. Here are the major components

**Model**: In this app, Prospect is the model that defines the basic information of a prospect that a user adds. This includes a prospect's name, contact information, the date the user met the prospect and more. The model is located in Prospect. swift

**View**: The primary view of this application is located in the file ProspectsView.swift. This file defines a list that displays the time, date, and location that the user meets all their prospects. Another major view is located in MeView.swift. In this view, the user can update their contact information and personal details. Another important view is MeView which allows the user to enter their contact info details and generates a custom QR code from these strings.

**View Model**: The app contains 3 main view models. The view model defines an array of prospects that the user has saved their information. The view model handles insertions, deletions, and storage of the array. The view model is located in the file called ProspectViewModel.swift. The second view model  manages the current event the user attends and shares this data between views. This is located in the file ProspectEventViewModel.swift. The third view model handles the storage of user contact information and generates the users QR code. this view model is located in MeViewModel.swift


## Major Features

## Generate a custom QR code using a user's information

<img src="https://github.com/user-attachments/assets/ecb88da1-5be1-4a70-9640-2dac96bae3f1" alt="Descriptive Alt Text" width="300" height="600">

## Scan the QR code of another user to instantly save their contact information
<img src="https://github.com/user-attachments/assets/9d20c91c-9172-4791-ba15-fa0ceea3cb0b" alt="QR code save" width="300" height="600">

## Schedule a reminder to contact a particular prospect. 
<img src="https://github.com/user-attachments/assets/57960ccf-c3c8-419d-a7e7-b7fcb881abd7" alt="Descriptive Alt Text" width="300" height="600">


## Technologies Used
- AVFoundation framework
- APNS
- [CodeScanner](https://github.com/twostraws/CodeScanner) API

 ## Credits

Hot Prospects is originally based on a project created by [Paul Hudson](https://twitter.com/twostraws) who writes [free tutorials in Swift and SwiftUI](https://www.hackingwithswift.com/). 






