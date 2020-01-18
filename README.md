# Project Title

Simple Microservices Architecture Using .Net Framework and .Net Core

## Screenshot

![Alt text](Capture.jpg?raw=true "Front End")

### Prerequisites

You need to install visual studio 2017, because I use .Net Core 2.2

For databases, please install SQL Server engine and Mongo DB engine

### Installing

1st step : Restore Database. I have put .bak file and json data in database folder
2nd step : Setup your DB connection on web.config for each backend solution.  
3rd step : Publish all backend solutions ( there are 4 solutions for back end ). Notes : You need to create IIS application for each solution.
4th step : Setup each IIS application in OcelotAPigateway project. After finishing the setup process, publish OcelotAPigateway
5th step : Setup your api gateway link in Front End Project. Go through to your web config.
6th step : publish front end project and enjoy

## Authors

* **Antonius Bayu Nugroho** - *Initial work* 

## License

This project is licensed under the MIT License


