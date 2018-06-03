# iMoniQ
***project-group-12-version-2:***
*Modified version of project for group 12*

### Launch project
1. Download .zip archive
2. Unzip archive
2. Launch iMoniQ.xcworkspace

OR

1. Clone project

```git clone https://github.com/uts-ios-dev/project3-group-12-version-2/```

2. Launch iMoniQ.xcworkspace

**Note:** If possible, use account assigned to University of Technology Sydney Development Team 

### Possible issues
Project should compile on XCode >= 9.2, however it is better to use XCode >= 9.3 with Swift 4.1

In case of problems within pods run:

```pods install```

**Note:** In XCode >= 9.3 there will be warning related to Charts framework. This is due to method ```.flatMap()``` that is deprecated for XCode >= 9.3, however, XCode <= 9.2 does not have method ```.compactMap()```, thus, it must use ```.flatMap()```.

### Frameworks
* ResearchKit
* Charts
* Firebase (for LoginAuthentication/Database/Storage)
* HealthKit
* AVKit
* SDWebImage
