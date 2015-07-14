# Windmill

<p align="center">
  <img src="http://i.imgur.com/msyKwo8.png" alt="Animated gif">
</p>

A news reader for wordpress site, or any service that can spit out some proper json

This project was started a while a go, it was for a Kenyan news services, then it changed to a generic news reader. It no longer serves my purpose and is not freely available to any budding developers.

The project has been renamed **Windmil**, therefore any references to the original project name - **Habari** should be ignored.

<p align="center">
  <img src="https://github.com/edwinbosire/Habari/blob/master/Marketting/windmillgif.gif" alt="Windmill app gif">
</p>

#Structure

The project structure is quite simple, we query a service that returns json, we parse and store the json in coredata, and display the results in a collectionview, a detail view is also available with other bells and whistles.

The following libraries are in use.

* [SDWebImage](https://github.com/rs/SDWebImage)
* [Parse](www.parse.com)
* [MoPub](https://github.com/mopub/mopub-ios-sdk)
* [YALContextMenu](https://github.com/Yalantis/Context-Menu.iOS)
* [MRProgress](https://github.com/mrackwitz/MRProgress)
* [RESideMenu](https://github.com/romaonthego/RESideMenu)

###Configuration

Only the menu, section links and section colours can be configured at this time. Open the **NewsSection.plist** and everything that can be changed is laid bare.

The most import files/classes in the project are listed below, for brevity, I've excluded UI code.

**HNClient** - All the network calls are handled here.

**EBDataManager** - Coredata boiler plate code

**HNArticle** & **HNArticle** the two main models in the app. Your json data has to maintain these properties, especially the HNArticle properties.
  

###Gotchas

The collectionview in **HNNewsCollectionViewCell** is using MoPubs methods, this is necesary when you enable Ads (disabled by default).

The transition to and from the collection view is handled by two delegates at **HNListViewAnimationController** and **HNDetailViewAnimationController**

We are using cocoapods, albeit just for one library that is also copied in the git repo. You will need to open the workspace and not the project files.

###Warning

This is not a reusable open source component, it's a fully working app. And as such it doesn't come with proper instructions.

Disclaimer: If you use this code and land in shit, I might not be able to help.

Disclaimer#2: I was selling this very code on ChupaMobile, if you bought it, thank you, you bought the privilage of seeing it first. I only sold 1 copy, at £30. So this project has in total made me £30, just £ 999,970 to go hurrah!!
