#!/bin/sh
case "$1" in
    start)
        echo "Loading LDD modules..."
        
        # Load hello (Works via modprobe)
        modprobe hello

        # Load faulty and create device node
        modprobe faulty
        # Get major number and create node
        major_faulty=$(awk '$2=="faulty" {print $1}' /proc/devices)
        if [ ! -z "$major_faulty" ]; then
            mknod /dev/faulty c $major_faulty 0
        fi

        # Load scull and create device nodes (scull0 to scull3)
        modprobe scull
        major_scull=$(awk '$2=="scull" {print $1}' /proc/devices)
        if [ ! -z "$major_scull" ]; then
            mknod /dev/scull0 c $major_scull 0
            mknod /dev/scull1 c $major_scull 1
            mknod /dev/scull2 c $major_scull 2
            mknod /dev/scull3 c $major_scull 3
        fi
        
        # Set permissions so the test script can access them
        chmod 666 /dev/faulty /dev/scull*
        ;;
    stop)
        echo "Unloading LDD modules..."
        rmmod hello
        rmmod faulty
        rmmod scull
        rm -f /dev/faulty /dev/scull[0-3]
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac

exit 0