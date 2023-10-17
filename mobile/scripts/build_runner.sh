green=`tput setaf 2`

case $1 in
    -cl|--clean)
        printf "Running builder..."
        flutter clean && flutter pub get && flutter packages pub run build_runner build --delete-conflicting-outputs && echo "${green}Done"
        ;;
    -w|--watch)
        printf "\nRunning builder with watching...\n"
        flutter packages pub run build_runner watch
        ;;
    *)
        echo ""
        echo -e "${RED}Error: Invalid option"
        ;;
esac