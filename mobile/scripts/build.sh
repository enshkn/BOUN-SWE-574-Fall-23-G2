RED=$(tput setaf 1)
POWDER_BLUE=$(tput setaf 153)

case $1 in
    -cl|--clean)
        printf "Running clean..."
        flutter clean && flutter pub get && flutter packages pub run build_runner build --delete-conflicting-outputs && printf "Done"
        ;;
    -l|--launcher_icons)
        printf "Running launcher icons..."
        flutter pub pub run flutter_launcher_icons:main && printf "Done"
        ;;
    -ios|--ios_build)
        printf "Running ios build..."
        cd ios
        pod install
        cd ..
        open ios -a "Xcode"
        ;;    
    -apk|--apk_build)
        printf "\nRunning apk build...\n"
        if [ "$2" = "" ]; then
            echo ""
            echo -e "${POWDER_BLUE}Without flavors, the default build is used."
            echo ""
            flutter clean
            flutter build apk --release
        else
            flutter clean
            flutter build apk --release --flavor $2 -t lib/main_$2.dart
        fi
        
        ;;
    -bundle|--appbundle_build)
        printf "\nRunning appbundle build...\n"
        if [ "$2" = "" ]; then
            echo ""
            echo -e "${POWDER_BLUE}Without flavors, the default build is used"
            echo ""
            flutter clean
            flutter build appbundle
        else
            flutter clean
            flutter build appbundle --flavor $2 -t lib/main_$2.dart
        fi
        ;;
    *)
        echo ""
        echo "${RED}Error: Invalid option"
        ;;
esac