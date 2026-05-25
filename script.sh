#!/bin/bash

START=88M
END=108M
STEP=100K
GAIN=20

TMPFILE="/tmp/rtlscan.csv"

cleanup() {
    rm -f "$TMPFILE"
    tput cnorm
    exit
}

trap cleanup INT

tput civis

while true
do
    clear

    echo "======================================="
    echo " RTL-SDR FM BAND SCANNER"
    echo " 88 MHz - 108 MHz"
    echo "======================================="
    echo ""

    rtl_power -f ${START}:${END}:${STEP} \
              -g ${GAIN} \
              -i 1 \
              -1 \
              "$TMPFILE" >/dev/null 2>&1

    echo "GEVONDEN KANALEN:"
    echo ""

    awk -F',' '
    {
        start=$3
        stop=$4
        step=$5

        for(i=7;i<=NF;i++) {
            power=$i+0

            if(power > -35) {
                freq = start + ((i-7) * step)

                printf " %.1f MHz   Signal: %.1f dB\n",
                       freq/1000000,
                       power
            }
        }
    }
    ' "$TMPFILE" | sort -u

    echo ""
    echo "Refresh over 3 seconden..."
    sleep 3
done
