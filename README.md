# CareZoneShopper

Test job.

## Development setup

```bash
git clone https://github.com/yas375/CareZoneShopper.git
cd CareZoneShopper/
cp CareZoneShopper/Credentials/CZSCredentials.m.example CareZoneShopper/Credentials/CZSCredentials.m
# edit credentials
open CareZoneShopper.xcworkspace
```

## Third-party libraries and tools

* [CocoaPods](http://cocoapods.org/) - for dependency management
* [MBProgressHUD](https://github.com/matej/MBProgressHUD) - for showing HUD messages
* [MKNetworkKit](https://github.com/MugunthKumar/MKNetworkKit) - for communication with the server
* [MagicalRecord](http://github.com/magicalpanda/MagicalRecord) - for simplifying work with CoreData
* [SSPullToRefresh](https://github.com/samsoffes/sspulltorefresh) - pull to refresh view

## Possible improvements

Handle 422 error codes from the server. I saw that when I'm trying to create Item without name or category your web application (which is written on ruby on rails ;)) returns detailed description of errors. I suppose that your server will return detailed errors for another requests too, but the format of error responses for each request isn't documented.

Also I've left some TODOs in code.

