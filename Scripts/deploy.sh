xcodebuild -target QuickLookFramework
rm -r ~/Library/QuickLook/QuickLookFramework.qlgenerator
cp -r "${SRCROOT}/build/Release/QuickLookFramework.qlgenerator" ~/Library/QuickLook
rm -r "${SRCROOT}/build/"
killall quicklookd || true
