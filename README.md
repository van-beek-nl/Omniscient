# Omniscient

[![GitHub release](https://img.shields.io/github/v/release/van-beek-nl/omniscient)](https://github.com/van-beek-nl/omniscient/releases/)

An Omnis Studio error logger. Built to resilliently log errors with minimal performance impact.

## Description

Omniscient is an error logger built by us for the automatic logging of issues in our ERP system. Its goal is to resilliently log errors in bulks, which are then sent to Sentry

### Idea

Omniscient revolves around so-called Error Processors. These classes can read and write errors from and to their source. As an example, a disk error processor can write errors to a log file on disk, and fetch all logged errors from a log file.

However, uploading these errors can be unreliable at times due to a dependance on things such as:
- Internet connectivity
- Database availability
- Remote logging tools

Because of this, Omniscient is set up in such a way that errors are reliably stored every step of the way:
1) Errors are first stored in the source error processor. Generally, this is a log file on disk or some other local storage medium.
2) These logged errors are then sent to the target error processor. A database for example.
3) If errors are sent individually rather than in bulk, any unprocessed errors (for example, a failed request to your remote error logging tool) are automatically logged in the source error processor again.
4) Only once all of this has finished will the original error bulk be deleted from the source.

With Omniscient you can be pretty sure that most if not all of the errors encountered by your users are stored where you'd like them to be.

## Getting started

### Prerequisites

- Omniscient makes use of the jsoncpp wrapper for Omnis Studio, which can be found at https://github.com/dmckeone/Omnis-jsoncpp. Please make sure this component is installed on both your server as well as all clients that make use of Omniscient.
- The BufferedDatabaseErrorProcessor and SerialDatabaseErrorProcessor expect either a valid database session or valid connection parameters. A table called "Omniscient" with the required columns is also required to be present. An SQL script to automatically create this table has been included in the files. The required columns are as follows:
    - id, integer/sequence/auto increment, NOT NULL, PK
    - json, text, NOT NULL
    - logidentifier, text, NOT NULL, UNIQUE
    - processid, integer


### Installing

1) Download the latest release for your Omnis Studio version from the [releases](https://github.com/van-beek-nl/omniscient/releases/) page.
2) The download will include an exported Omnis Studio library. Import the library.
3) Instantiate any desired error processors with the desired parameters:
```
Do $libs.Omniscient.$objects.oDiskErrorProcessor.$newref(...) Returns ivSourceErrorProcessor
Do $libs.Omniscient.$objects.oSentryErrorProcessor.$newref(...) Returns ivTargetErrorProcessor
```
4) Instantiate Omniscient with your source and target processors:
```
Do $libs.Omniscient.$objects.oOmniscient.$newref(ivSourceErrorProcessor, ivTargetErrorProcessor, ...) Returns ivOmniscient
```
5) Either call Omniscient's $catchError method in your own custom error handler, or attach oOmniscient's $catchGlobalError as error handler. Don't forget to unload the error handler upon exit:
```
Load error handler oOmniscient/$catchGlobalError
...
Unload error handler oOmniscient/$catchGlobalError
```
6) You're done!

### Tips for setup

Take a look at the following tasks for examples on how we set up Omniscient internally:
```
Helpers/ClientSetupExample
Helpers/ServerSetupExample
```

For added resillience we recommend the following error processor setup:
- Client: source Disk, target BufferedDatabase
- Server: source SerialDatabase, target Sentry

This setup ensures that errors are first logged to disk and then sent to the database, where the Omniscient server can read them and send each error to Sentry individually.

## Contributing

Since Omnis developers are more of a rarity than many other languages we'd greatly appreciate  
the additional insight, comments and contributions from people in the community.  
Please refer to the CONTRIBUTING.md file for specific instructions.

## License

Copyright (c) Van Beek Schroeftransport B.V. All rights reserved.

Licensed under the [MIT](./LICENSE.txt) license.

## Authors

- **Django** - *Initial work and maintenance* - [Van Beek Schroeftransport](https://www.van-beek.nl/en/)
- **Marten** - *Feedback, idea, product owner* - [Van Beek Schroeftransport](https://www.van-beek.nl/en/)

Please also refer to the repository's [list of contributors](https://github.com/van-beek-nl/omniscient/contributors).