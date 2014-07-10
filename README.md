## TSBoilerplateSwift

A project to be used as the starting point for a new iOS project.

This project uses Cocoapods and git submodules (until Apple allow you to build static libraries with Swift code)

## First steps
    cd to cloned directory
    rename your project in XCode and change the .git/config origin URL to your own repo
    git submodule init
    git submodule update
    pod install
    sudo cp App/Model/CoreDataModel/MogenTemplate/mogeneratorswift /usr/bin
    open the .xcworkspace

## Includes:
* [TheNetwork](https://github.com/timsawtell/TheNetwork)
* [Mogenerator](https://github.com/timsawtell/mogenerator) (NSSecureCoding support for model files)

## Data persistance:
The app uses an archived root object as the data persistence mechanism. The data model lives in memory from app launch. The data model is designed using the standard Core Data editor, however the app does not use NSManagedObjects. The Mogenerator tool will build classes for you based on the templated in the MogenTemplate directory.

When you want to add a new entity, make sure you set the data type to that entity's name. I.e.

![data model](http://i.imgur.com/8seiyZQ.png)

### Creating classes using Mogenerator
Change the scheme to "BuildDataModel" and build. 
The source files will be generated in App/Model/ModelObjects/ - you will need to drag these into the project after the entity is first created (they will simply update in place thereafter if you made changes to that model object in the .xcdatamodel).


When you want to change the data model, as in, add new entities, or change properties of existing ones, make the change in the Model.xcdatamodel file (like you would for a core data app), change the scheme to "Generate Data Model" and build the project. That will instigate mogenerator to make the change and your data model objects in App/Model/ModelObjects will be updated (or added).

## Networking: 
[TheNetwork](https://github.com/timsawtell/TheNetwork) library.
This project uses Builder classes to create model objects from the JSON data returned from the API.
A typical scenario

                                            ------- results ----------
                                            |                        |
                                            v                        |
    View Controller -> Command Center -> Command (Networking Task)  -|
                                            |
                                             --> Builder (to create model objects)            
                                          
### Example networking task

    let successBlock: SuccessBlock = { (resultObject, request, response) -> Void in
        NSLog("\(resultObject)") // resultObject is an AnyObject subclass. It is built based on the the response's content-type header value. If it's "application/JSON" for example, `resultObject` will be either an NSArray or an NSDictionary
    }

    let errorBlock: ErrorBlock = { (resultObject, error, request, response) -> Void in 
        // you still get a parsed resultObject if the request failed (perhaps the API gave you a 401 and a custom JSON based error object)
        NSLog("\(error)")
    }

    let additionalParams = NSDictionary(object: "value", forKey: "key")

    let task = Network.performDataTask(relativePath: nil, method: .GET, successBlock: successBlock, errorBlock: errorBlock, parameters: additionalParams)                                          

## Business Logic
The app uses the concept of Commands to be self contained classes that execute one specific use case. The commands can be run synchronously (just subclass the Command class) or asynchronously (subclass the AsynchronousCommand class). The different between them is the thread that they run on. Synchronous commands run on the main thread, so when you call them in your view controllers or in Command Center they will execute before the next line of code starts. Asynchronous commands on the other hand are passed to a background queue and they will eventually execute on another thread, which means that they can't have any UI changes in the execute method. 

To perform UI changes after the command has finished, add the code to that command's completionBlock property. All networking use cases ("get customer details", "submit payment" etc.) are asynchronous, you need the app to do something when the data is fetched from the server.

## MVC and how it's used in this project
Model is the central data model instance, it is the data store, and it is used as the single source of truth. You won't find View Controllers owning business objects in this project.

View Controllers (should) _NEVER_ change model objects. This is a self imposed rule to avoid what I usually find on other projects, your data is updated by some other unknown controller and it's very difficult to find out who did it.

CommandCenter is where you issue your use cases.

View Controller -> Command Center -> Command (which updates the model) 

or 

View Controller -> Command Center (which updates the model).

in this paradigm there are only two places that a model object can be updated, in a command or in CommandCenter.

View Controllers read data directly from the model, or through an Accessor (if business logic needs to be applied to a data structure, i.e. sorting).