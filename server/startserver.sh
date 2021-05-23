#!/bin/bash

while true
do
   #java -Xmx8G -Xms8G -jar forge-1.7.10-10.13.4.1614-1.7.10-universal.jar nogui
   /home/gtnh/graalvm-ce-java8-21.1.0/bin/java -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9988 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=192.168.1.241 -XX:+UseG1GC -Xmx6G -Xms6G -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M -noverify -jar Crucible-1.7.10-4.1-dev-5b33980-server.jar nogui
   #/home/gtnh/graalvm-ce-java8-20.2.0/bin/java -Xms8G -Xmx8G -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9988 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=192.168.1.241 -jar forge-1.7.10-10.13.4.1614-1.7.10-universal.jar nogui
   #/home/gtnh/graalvm-ce-java8-20.2.0/bin/java -Xms8G -Xmx8G -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9988 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=192.168.1.241 -jar forge-1.7.10-10.13.4.1614-1.7.10-universal.jar nogui
   #java -XX:+UseG1GC -Xms8G -Xmx8G -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9988 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=192.168.1.241 -jar forge-1.7.10-10.13.4.1614-1.7.10-universal.jar nogui
   #java -XX:+UseG1GC -Xms8G -Xmx8G -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M -jar forge-1.7.10-10.13.4.1614-1.7.10-universal.jar nogui
   #java -Xms8G -Xmx8G -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9000 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -jar forge-1.7.10-10.13.4.1614-1.7.10-universal.jar nogui
    echo "If you want to completely stop the server process now, press Ctrl+C before the time is up!"
    echo "Rebooting in:"
    for i in 12 11 10 9 8 7 6 5 4 3 2 1
    do
        echo "$i..."
        sleep 1
    done
    echo "Rebooting now!"
done
