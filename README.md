# clear-cache
This little tool clears your linux cache folder up. 

# How to use:
## Installation
`git clone https://github.com/Stehlampe2020/clear-cache.git; chmod +x clear-cache/clear_cache_install.sh; clear-cache/clear_cache_install.sh`
## Uninstallation
`chmod +x ~/clear-cache/clear_cache_install.sh`   
`~/clear_cache_install.sh --uninstall [--w-repeat]` (If you specify --w-repeat, "repeat" will also be removed.)
## Usage
|Command|Description|
|-------|-----------|
|||
|`~$ `|Represents the terminal input prompt.|
|||
|`~$ clear-cache`|Run clear-cache and create a log file.|
|`~$ clear-cache --rm-log`|Run clear-cache and create a log file. After that, remove all clear-cache log files.|
|`~$ clear-cache --rm-whole-cache`|Delete all contents of the ~/.cache folder.|
   
(For example runs see [https://s.lampe2020.de/001](https://s.lampe2020.de/001). s.lampe2020.de is my own URL shortener.)   
