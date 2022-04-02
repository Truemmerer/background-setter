#!/bin/bash

if [ $(whoami) == 'root' ]; then
    echo "Please run as regular user!"
    exit 1
fi

INPUT=$(zenity --list --title "Background Setter" --window-icon=/usr/local/share/awp/awp_wallpaper_icon.png --text "What do you want?"\
 --column "Selection" --column "Typ" --radiolist  TRUE "New" FALSE "Remove"\
 --width=600 --height=180)


#New Wallpaper 

if [ "$INPUT" == "New" ]
then

    set_name=""
    picture_light=""
    picture_dark=""

    cd $HOME

    # Ask for light Wallpaper
    echo 'select light wallpaper'
    picture_light=$(zenity --file-selection --title "Choose the light wallpaper" --filename='$' --width=600)

        # Checking if user has cancelled the file prompt
        case $? in 

        0) 
            echo "Light wallpaper selected"
            ;;
        1) 
            echo "Aborted"
            exit 0
            ;;
        -1) 
            zenity --info --width 500\
                --text="Oops. This should not happen."
            exit 0
            ;;
            
        esac

    # Ask for dark wallpaper
    echo 'select dark wallpaper'
    picture_dark=$(zenity --file-selection --title "Select the dark wallpaper" --filename='$Bilddir' --width=600) 

        # Checking if user has cancelled the file prompt
        case $? in 

        0)
            echo "Dark wallpaper selected"
            ;;

        1) 
            echo "Aborted"
            exit 0
            ;;
        -1) 
            zenity --info --width 500\
                --text="Oops. This should not happen."
            exit 0
            ;;    

        esac

    # Set a name for XML File
    echo 'Set a name for it'
    set_name=$(zenity --entry --title "What should the wallpaper be called?" --width=600)

        # Checking if user has cancelled the name prompt
        case $? in 

        0)
            echo "Name set"
            ;;

        1) 
            echo "Aborted"
            exit 0
            ;;
        -1) 
            zenity --info --width 500\
                --text="Oops. This should not happen."
            exit 0
            ;;    

        esac

    # Ask for passwort to move XML to /usr/share/gnome-background-properties/

    correct_passwort=0
    while [ $correct_passwort -lt 1 ];
    do
        echo $correct_passwort' first'
        echo "Asking for sudo password"
        PASS=`zenity --password --title "Background Setter"`
            # Checking if user has cancelled the password prompt
            case $? in 
            0) 
                ;;
            1) 
                zenity --info --width=500\
                    --text="Unfortunately, it is not possible for me to work like this."
                exit 0
                ;;
            -1)
                echo "Exiting"
                exit 1
                ;;
            esac

            # Checking if provided password is correct
            echo "$PASS" | sudo -S -k -v
            case $? in 
            0) 
                echo "Verified sudo privileges."
                correct_passwort=$((correct_passwort + 1))
                ;;
            1)
                zenity --info --width 500\
                    --text="The passwort is wrong."
                ;;
            -1)
                zenity --info --width 500\
                    --text="Oops. This should not have happened...."
                exit 1
                ;;
            esac
    done

    echo $correct_passwort
    if [ $correct_passwort -eq 1 ];
    then
        # END PASSWORT


        echo "Create XML Config file"
        # Start create config file
            echo '###'
            echo '<?xml version="1.0"?>' && echo '<?xml version="1.0"?>' > $HOME/$set_name.xml
            echo '<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">' && echo '<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">' >> $HOME/$set_name.xml
            echo '<wallpapers>' && echo '<wallpapers>' >> $HOME/$set_name.xml
            echo '  <wallpaper deleted="false">' && echo '  <wallpaper deleted="false">' >> $HOME/$set_name.xml
            echo '    <name>'$set_name'</name>' && echo '    <name>'$set_name'</name>' >> $HOME/$set_name.xml
            echo '    <filename>'$picture_light'</filename>' && echo '    <filename>'$picture_light'</filename>' >> $HOME/$set_name.xml
            echo '    <filename-dark>'$picture_dark'</filename-dark>' && echo '    <filename-dark>'$picture_dark'</filename-dark>' >> $HOME/$set_name.xml
            echo '    <options>zoom</options>' && echo '    <options>zoom</options>' >> $HOME/$set_name.xml
            echo '  </wallpaper>' && echo '  </wallpaper>' >> $HOME/$set_name.xml
            echo '</wallpapers>' && echo '</wallpapers>' >> $HOME/$set_name.xml
            echo '###'
        # End create config file

        echo "Move XML File to /usr/share/gnome-background-properties/"
        echo "$PASS" | sudo -S mv $HOME/$set_name.xml /usr/share/gnome-background-properties/
    
    else

        echo "Error"  
   
    fi

fi

if [ "$INPUT" == "Remove" ]
then
  echo hi!
fi
