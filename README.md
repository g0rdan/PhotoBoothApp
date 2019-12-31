## Prolog

It was quite an interesting project. First of all, because I don't have real experience with Flutter/Dart and I learned a lot. It wasn't easy, but interesting. Second of all, I've made a few mistakes at the planning level, so, in the future, hopefully, I won't make them again.

![The App](video.gif)

## Installation

### Flutter

I assume you already have Android SDK and XCode for building Flutter apps.

Flutter installation process is quite easy. There are a few different steps depend on your OS but, in general, you have to clone the flutter repo on your machine:

```git clone https://github.com/flutter/flutter.git```

and after cloning, you need to update your 'PATH' of your terminal environment:

```export PATH="$PATH:`pwd`/flutter/bin"``` (for macOS)

After all these steps you need to check if flutter command works. For that, type:

```flutter doctor```

in your terminal and you'll see something like that:

```

[✓] Flutter (Channel master, v1.13.6-pre.16, on Mac OS X 10.15.2 19C57, locale en-RU)
 
[✓] Android toolchain - develop for Android devices (Android SDK version 29.0.2)
[✓] Xcode - develop for iOS and macOS (Xcode 11.3)
[!] Android Studio (version 3.5)
    ✗ Flutter plugin not installed; this adds Flutter specific functionality.
    ✗ Dart plugin not installed; this adds Dart specific functionality.
[!] IntelliJ IDEA Community Edition (version 2019.3.1)
    ✗ Flutter plugin not installed; this adds Flutter specific functionality.
    ✗ Dart plugin not installed; this adds Dart specific functionality.
[✓] VS Code (version 1.41.1)
[✓] Connected device (2 available)

```

If Flutter, Android toolchain, and Xcode are green it means you have the minimum requirements for running Flutter apps.

For more information you can go on the official [website](https://flutter.dev/docs/get-started/install);

### Photobooth App

In order to run the app, you have to connect at least one device. It could be a real device or emulator/simulator. I recommend connecting a real device because only with real one you can test a real camera.

For seeing emulators on your machine use the command:

```flutter emulators```

For launching one of these:

```flutter emulators --launch <emulator id>```

For seeing what devices or emulators are running at the moment, use:

```flutter devices```

Once the command shows you at leats one device, you could run the app by typing (before typing make sure that you're in the directory of the app):

```flutter run```

PS: I had the problem with building one of the packages on iOS. For some reasons the `(__dir__)` variable in `copied_flutter_dir` line of Podfile didn't work. So, I had to put an absolute path to Flutter folder of iOS project instead of `(__dir__)`. If you get the same error, please try to replace it with an absolute path.



## Testing

I have to say, I didn't cover everything on 100%. I did'n have enough time. Most of the time I've spent figuring out how things work in Flutter. I covered with unit tests basic functions in my 'Models' and 'Services' and I created a couple of UI test, just to show you that it's pretty easy in Flutter.

For running test you have to go in the parent directory of the app and type:

```flutter test test/unit/main_model_tests.dart``` 

```flutter test test/unit/photobooth_service_tests.dart```

```flutter test test/ui/tests.dart```

I left behind a couple of services and didn't cover them with unit test at all because they represent platform-specific functionality and it's kind of hard to figure out how to test them on unit level (it is easier with UI tests).

PS: Probably everything what I've done, in terms of implementing IoC in Dart, is wrong. I've seen some packages for ServiceLocators but they seemed too complex and non intuitive. So, I've just implemented DI with constructor injection.

## Technologies

### Flutter - framework

As you can see, I chose Flutter for developing the app. I felt in love even more with the framework. I don't think I could have done the project on time if I choose native development for iOS and Android simultaneously. I've spent a lot of time on understandimg flutter. Plus I didn't do almost anytnig on Christmas. However, I completed the project and it works perfect on both platforms. It's amazing.

### Scoped Model - architectural pattern

It appers that this model is perfect for the app. For bigger projects I'd choose BLoC, for huge - Redux, probably (I'm not the fan), but it's a small project with one screen only and Scoped Model is just enougth. Plus with `notifyListeners()` it remainds me MVVM, which I always use in Xamarin apps.

## Description of the “PhotoBooth Document”

Long story short, I chose my own format, which is basically - json with following structure:

```
{
    "width": number
    "heigth": number
    "lines": [
        "color": color
        "points": [
            {
                "x": number,
                "y": number
            }
        ]
    ]
}
```

In the beginning, I thought I don't need SVG because I'm going to store only points, and SVG is a vectorized picture, there are no points. In the middle, I realized that even my main data are points I'm going to draw 'lines' between those points, so it becomes vectors that perfect for SVG but it was kind of late. Anyway, I chose what I chose. There are pros and cons:

#### Pros

- It's much simpler as a data format. There are a few types of data and that's it. I need to save only points and colors for them. SVG has much more.
- Even for drawing lines, my format has a small advantage. In order to draw 2 connected lines, I need to store 3 points. In SVG it's 4. To be clear, In SVG it has to be 2 'lines' like that:

``` <line x1="0" y1="0" x2="200" y2="200"" />```

that would use one coordinate twice.

#### Cons

- SVG is the standard. Everybody uses it and understand it. My format uses only in the app, which is fine, but it's not scalable (it's scalable, I guess, but not 'transferable').

## My mistakes

- I'm sure there're better ways to deal with widgets in Flutter that I did. I think I could have decomposed widgets more. Now it seems a bit over nested than it has to be.

- I should have write unit tests first. It would help me with a better project structure. The reason why I didn't is I kind of didn't know what to expect from flutter and I've started from UI.

- Just in general, I tried to find the right features of Flutter for filling out requirements of the exercise rather than make a solid structure and general solutions. I was afraid of not having ability to do something in Flutter.