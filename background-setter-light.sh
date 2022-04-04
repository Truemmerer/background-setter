#!/bin/bash

if [ $(whoami) == 'root' ]; then
    echo "Please run as regular user!"
    exit 1
fi

cache_folder="$HOME/.cache/background-setter"
wallpaper_list="$cache_folder/wallpaper_list.txt"

Reset=0 #reset the remove table

reload_script=0
while [ $reload_script -lt 1 ];
do


    INPUT=$(zenity --list --title "Background Setter" --window-icon=/usr/local/share/awp/awp_wallpaper_icon.png --text "What do you want?"\
    --column "Selection" --column "Typ" --radiolist  TRUE "New Wallpaper Set" FALSE "Remove Wallpaper Set" FALSE "Set light wallpaper" FALSE "Set dark wallpaper" FALSE "Uninstall" FALSE "About"\
    --width=600 --height=250)

            case $? in 

            1) 
                echo "Aborted"
                reload_script=1
                exit 0
                ;;
            -1) 
                zenity --info --width 500\
                    --text="Oops. This should not happen."
                exit 0
                ;;    

            esac

    if [ "$INPUT" == "Set light wallpaper" ]
    then        
        cd $HOME

        # Ask for light Wallpaper
        echo 'select light wallpaper'
        picture_light=$(zenity --file-selection --title "Choose the light wallpaper" --filename='$' --width=600)

            # Checking if user has cancelled the file prompt
            case $? in 

            0) 
                echo "Light wallpaper selected"
                gsettings set org.gnome.desktop.background picture-uri "file://$picture_light"\
                ;;
            1) 
                echo "Aborted"
                ;;
            -1) 
                zenity --info --width 500\
                    --text="Oops. This should not happen."
                exit 0
                ;;
                
            esac

    fi

    if [ "$INPUT" == "Set dark wallpaper" ]
    then        
        cd $HOME

        # Ask for dark Wallpaper
        echo 'select dark wallpaper'
        picture_dark=$(zenity --file-selection --title "Choose the dark wallpaper" --filename='$' --width=600)

            # Checking if user has cancelled the file prompt
            case $? in 

            0) 
                echo "Dark wallpaper selected"
                gsettings set org.gnome.desktop.background picture-uri-dark "file://$picture_dark"\
                ;;
            1) 
                echo "Aborted"
                ;;
            -1) 
                zenity --info --width 500\
                    --text="Oops. This should not happen."
                exit 0
                ;;
                
            esac

    fi

    #New Wallpaper 


    if [ "$INPUT" == "New Wallpaper Set" ]
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
            echo "Asking for sudo password"
            PASS=`zenity --password --title "Background Setter"`
                # Checking if user has cancelled the password prompt
                case $? in 
                0) 
                    ;;
                1) 
                    zenity --info --width=500\
                        --text="Unfortunately, it is not possible for me to work like this."
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

        if [ $correct_passwort -eq 1 ];
        then

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
        
            echo "Create a cache folder. in $cache_folder"
            mkdir -p "$cache_folder"

            if [ -f "$wallpaper_list" ]; then
                echo "$wallpaper_list exists."
                read actual_list < "$wallpaper_list"
                echo $actual_list' '$set_name > "$wallpaper_list"

            else

                echo "create $wallpaper_list"
                echo $set_name > "$wallpaper_list"

            fi

            zenity --info --width 500\
            --text="You can now select the images in the GNOME preferences."
        
        else

            echo "Error"  
    
        fi

    fi

    if [ "$INPUT" == "Remove Wallpaper Set" ]
    then

        if [ "$Reset" == 1 ]; then
           unset wallpaper_list_read
           unset newtext
           unset data
        fi

        read -a wallpaper_list_read < "$wallpaper_list"

        for (( i=0; i<${#wallpaper_list_read[*]}; ++i)); do
            data+=( "${wallpaper_list_read[$i]}")
        done

        wallpaper_to_remove=$(zenity --list \
            --title="Select the name of the background set" \
            --column="choose:"\
                "${data[@]}")

            case $? in 
                0) 
        
                    echo "remove /usr/share/gnome-background-properties/$wallpaper_to_remove.xml"
                    echo "$PASS" | sudo -S rm /usr/share/gnome-background-properties/$wallpaper_to_remove.xml

                    echo "remove entry $wallpaper_to_remove in $wallpaper_list"
                    
                    for (( i=0; i<${#wallpaper_list_read[*]}; ++i)); do
                        
                        if [ "${wallpaper_list_read[$i]}" == "$wallpaper_to_remove" ]; then

                            echo "data hit $wallpaper_to_remove"

                        else 

                            $newtxt="$newtxt' '${wallpaper_list_read[$i]}"

                        fi

                    done
                    
                    echo $newtxt > "$wallpaper_list"
                    Reset=$((Reset = 1))
                    ;;
                1)
                    Reset=$((Reset = 1))
                    echo "Aborted"
                    ;;
                -1)
                    zenity --info --width 500\
                        --text="Oops. This should not have happened...."
                    exit 1
                    ;;
            esac

    fi
done