#!/bin/bash
installer_version=1.2
printf "clear-cache installer $installer_version\n"
sleep 1
if [ "$1" == "--uninstall" ]
then
    printf "Uninstalling clear-cache...\n"
    sudo rm -v /bin/clear-cache
    rm -v $HOME/.local/share/applications/clear-cache.desktop
    if [ "$2" == "--w-repeat" ]
    then
        sudo rm -v /bin/repeat
    fi
    printf "Uninstall complete!\n"
    sleep 3
    exit
fi
printf "Creating program file for \"clear-cache\"...\n"
cat << '**ENDOFFILE**' > /tmp/clear-cache.tmp
#!/bin/bash
version=1.2.3
printf "clear-cache, version $version\n"
datevar=$(date "+%F-%T-%Z")
cachepath="$HOME/.cache"
if [[ ! -f "$cachepath/cache_cleared_$datevar.log" ]]
then
    printf "Log file: $cachepath/cache_cleared_$datevar.log\n"
elif [ -f "$cachepath/cache_cleared_$datevar.log" ]
then
    printf "Log file $cachepath/cache_cleared_$datevar.log already exists, exiting...)\n"
    sleep 1
    exit
fi    
repeat yes | rm -vr $cachepath/.fr-* &>> "$cachepath/cache_cleared_$datevar.log"
repeat yes | rm -vr $cachepath/thumbnails/* &>> "$cachepath/cache_cleared_$datevar.log"
repeat yes | rm -vr $cachepath/at-spi* &>> "$cachepath/cache_cleared_$datevar.log"
if [ "$1" == "--rm-log" ]
then
    repeat yes | rm -vr $cachepath/cache_cleared_*
elif [ "$1" == "--rm-whole-cache" ]
then
    repeat yes | rm -vr $HOME/.cache/*
fi
**ENDOFFILE**
printf "Creating program file for dependency \"repeat\"...\n"
cat << '**ENDOFFILE**' > /tmp/repeat.tmp
#!/bin/bash
while ! [ -z "$1" ]
do
printf "x\b$*\n"
done
if [ -z "$1" ]
then
printf "\"repeat\", version 1.1 (installed/last updated as dependency of clear-cache)\n\nUsage:\n\e[1;33mrepeat <string>     Print <string> repeatedly.\n\e[1;33mrepeat              Print this info and exit.\e[0m\n"
fi
**ENDOFFILE**
printf "Making program files executable...\n"
chmod +x /tmp/clear-cache.tmp
chmod +x /tmp/repeat.tmp
printf "Moving program files to target location...\n"
sudo mv /tmp/clear-cache.tmp /bin/clear-cache
sudo mv /tmp/repeat.tmp /bin/repeat
printf "If you run \"clear-cache\", your cache will be cleared. If you run \"clear-cache --rm-log\", your cache will be cleared and all log files of clear-cache will be removed. If you execute the program several times a second it will overwrite the current log and only the last one per second will persist.\n"
printf "Checking for application link folder... "
if [[ ! -d "$HOME/.local" ]] && [[ ! -d "$HOME/.local/share" ]] && [[ ! -d "$HOME/.local/share/applications" ]]
then
    printf "DONE: does not exist!'\nCreating nescessary folder(s)..."
    mkdir $HOME/.local
    mkdir $HOME/.local/share
    mkdir $HOME/.local/share/applications
elif [ -f "$HOME/.local/share/applications" ] || [ -f "$HOME/.local/share" ] || [ -f "$HOME/.local/share/applications" ]
then
    printf "DONE: is a file!\nExiting...\n"
    sleep 3
    exit
else
    printf "DONE: exists, continuing...\n"
fi
printf "Creating application link...\n"
cat << '**ENDOFFILE**' > $HOME/.local/share/applications/clear-cache.desktop
[Desktop Entry]
Version=1.2.1
Name=clear-cache
Comment=Removes much annoying stuff from the cache and stores what it does in a log: ~/.cache/cache_cleared_<date-now>.log; It is also capable to remove its own cache file with "--rm-log".
Categories=Utility
Type=Application
Exec=clear-cache
Actions=rm-log;rm-whole-cache
Terminal=true

[Desktop Action rm-log]
Name=clear-cache: rm-log
comment=Removes stuff from the cache, including clear-cache log files.
Exec=clear-cache --rm-log
Terminal=true

[Desktop Action rm-whole-cache]
Name=clear-cache: rm-whole-cache
Comment=Removes all contents from cache, including clear-cache log files.
Exec=clear-cache --rm-whole-cache
Terminal=true
**ENDOFFILE**
printf "Install complete!\n"
sleep 3
