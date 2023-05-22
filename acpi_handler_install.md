Installs the acpid to make laptop screen work nicely when opening and closing laptop.

sudo pacman -S acpid

sudo systemctl enable acpid.service
sudo systemctl start acpid.service

sudo touch /etc/acpi/handler.sh
sudo chmod +x /etc/acpi/handler.sh

echo $DISPLAY
echo $XAUTHORITY

code /etc/acpi/handler.sh

```
#!/bin/bash
logger 'ACPI handler script started'
# Default acpi script that takes an entry for all actions

# Set environment variables
export DISPLAY=:0
export XAUTHORITY=/home/lgx/.Xauthority


case "$1" in
    button/power)
        case "$2" in
            PBTN|PWRF)
                logger 'PowerButton pressed'
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    button/sleep)
        case "$2" in
            SLPB|SBTN)
                logger 'SleepButton pressed'
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    ac_adapter)
        case "$2" in
            AC|ACAD|ADP0)
                case "$4" in
                    00000000)
                        logger 'AC unpluged'
                        ;;
                    00000001)
                        logger 'AC pluged'
                        ;;
                esac
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    battery)
        case "$2" in
            BAT0)
                case "$4" in
                    00000000)
                        logger 'Battery online'
                        ;;
                    00000001)
                        logger 'Battery offline'
                        ;;
                esac
                ;;
            CPU0)
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    button/lid)
        case "$3" in
            close)
                logger 'LID closed'
                # Check if external monitors are connected
                ext_monitors=$(xrandr --query | grep ' connected' | grep -v 'eDP')
                if [ -n "$ext_monitors" ]; then
                    xrandr --output eDP1 --off
                fi
                ;;
            open)
                logger 'LID opened'
                ext_monitors=$(xrandr --query | grep ' connected' | grep -v 'eDP')
                if [ -n "$ext_monitors" ]; then
                    xrandr --output eDP1 --auto --left-of DP1
                else
                    xrandr --output eDP1 --auto
                fi
                ;;
            *)
                logger "ACPI action undefined: $3"
                ;;
    esac
    ;;
    *)
        logger "ACPI group/action undefined: $1 / $2"
        ;;
esac

# vim:set ts=4 sw=4 ft=sh et:

```
