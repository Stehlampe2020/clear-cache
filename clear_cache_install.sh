#!/bin/bash
installer_version=1.1
printf "clear-cache installer $installer_version\n"
sleep 1
if [ "$1" == "--uninstall" ]
then
    printf "Uninstalling clear-cache...\n"
    sudo rm -v /bin/clear-cache
    printf "Uninstall complete!\n"
    sleep 3
    exit
fi
printf "Creating program file...\n"
cat << '**ENDOFFILE**' > /tmp/clear-cache.tmp
#!/bin/bash
version=1.2.2
printf "clear-cache, version $version\n"
datevar=$(date "+%F-%T-%Z")
cachepath="$HOME/.cache"
if [[ ! -f "$cachepath/cache_cleared_$datevar.log" ]]
then
    printf "Log file: $cachepath/cache_cleared_$datevar.log\n"
elif [ -f "$cachepath/cache_cleared_$datevar.log" ]
then
    printf "Log file: $cachepath/cache_cleared_$datevar.log (overwriting older log!)\n"
fi    
rm -vr $cachepath/.fr-* &> "$cachepath/cache_cleared_$datevar.log"
rm -vr $cachepath/thumbnails/* &>> "$cachepath/cache_cleared_$datevar.log"
rm -vr $cachepath/at-spi* &>> "$cachepath/cache_cleared_$datevar.log"
if [ "$1" == "--rm-own-cache" ]
then
    rm -vr $cachepath/cache_cleared_*
elif [ "$1" == "--rm-whole-cache" ]
then
    rm -vr $HOME/.cache/*
fi
**ENDOFFILE**
printf "Making program file executable...\n"
chmod +x /tmp/clear-cache.tmp
printf "Moving program file to target location...\n"
sudo mv /tmp/clear-cache.tmp /bin/clear-cache
printf "If you run \"clear-cache\", your cache will be cleared. If you run \"clear-cache --rm-own-cache\", your cache will be cleared and all log files of clear-cache will be removed. If you execute the program several times a second it will overwrite the current log and only the last one per second will persist.\n"
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
Comment=Removes much annoying stuff from the cache and stores what it does in a log: ~/.cache/cache_cleared_<date-now>.log; It is also capable to remove its own cache file with "--rm-own-cache".
Categories=Utility
Type=Application
Exec=clear-cache
Actions=rm-own-cache;rm-whole-cache
Terminal=true

[Desktop Action rm-own-cache]
Name=clear-cache: rm-own-cache
comment=Removes stuff from the cache, including clear-cache log files.
Exec=clear-cache --rm-own-cache
Terminal=true

[Desktop Action rm-whole-cache]
Name=clear-cache: rm-whole-cache
Comment=Removes all contents from cache, including clear-cache log files.
Exec=clear-cache --rm-whole-cache
Terminal=true
**ENDOFFILE**
printf "Install complete!\n"
sleep 3
