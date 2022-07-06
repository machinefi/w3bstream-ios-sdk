xcodebuild archive \
-scheme MFWebStream \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \
-archivePath './build/MFWebStream.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive \
-scheme MFWebStream \
-configuration Release \
-destination 'generic/platform=iOS' \
-archivePath './build/MFWebStream.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES


xcodebuild -create-xcframework \
-framework './build/MFWebStream.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/MFWebStream.framework' \
-framework './build/MFWebStream.framework-iphoneos.xcarchive/Products/Library/Frameworks/MFWebStream.framework' \
-output './build/MFWebStream.xcframework'