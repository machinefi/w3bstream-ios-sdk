xcodebuild archive \
-scheme W3bStream \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \
-archivePath './build/W3bStream.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme W3bStream \
-configuration Release \
-destination 'generic/platform=iOS' \
-archivePath './build/W3bStream.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES


xcodebuild -create-xcframework \
-framework './build/W3bStream.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/W3bStream.framework' \
-framework './build/W3bStream.framework-iphoneos.xcarchive/Products/Library/Frameworks/W3bStream.framework' \
-output './build/W3bStream.xcframework'