#!/bin/bash

if [ $(whoami) == 'root' ]; then
    echo "Please run as regular user!"
    exit 1
fi

install_folder="/usr/local/share/background-setter"
if_installed=0
if [ -d "$install_folder" ]; then
    if_installed=$((if_installed + 1))

else
    zenity --question \
    --width=500\
    --text="For the script to function properly, it must be integrated into the system. You can then call it up like any other programme. The files are simply copied to $install_folder and one file to /usr/share/applications. Are you okay with that?"

            case $? in 
        0) 

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

            cd $HOME
            FOLDER=`zenity --file-selection --directory --title="Please select the current folder of Background Setter."`

            case $? in
                0)
                    echo "$FOLDER"
                    cd "$FOLDER"

                    echo "Move the files to $install_folder."
                    echo "create $install_folder"
                    echo "$PASS" | sudo -S mkdir -p $install_folder

                    echo "move background-setter.desktop to /usr/share/applications"
                    echo "$PASS" | sudo -S cp ./background-setter.desktop /usr/share/applications

                    echo "move files to $install_folder"
                    echo "$PASS" | sudo -S cp ./* $install_folder/
                   
                    zenity --info \
                    --width=500\
                    --text="Please start the script now via the application launcher of GNOME"
                    exit 0
                    ;;

                1)
                    echo "No folder selected.";;
                -1)
                    echo "Oops. This should not have happened...";;
            esac

           
            ;;
        1)
            zenity --info --width 500\
                --text="Cancel."
                exit 0
            ;;
        -1)
            zenity --info --width 500\
                --text="Oops. This should not have happened...."
            exit 1
            ;;
        esac



fi

cache_folder="$HOME/.cache/background-setter"
wallpaper_list="$cache_folder/wallpaper_list.txt"

Reset=0 #reset the remove table

reload_script=0
while [ $reload_script -lt 1 ];
do

    INPUT=$(zenity --list --title "Background Setter" --window-icon=/usr/local/share/awp/awp_wallpaper_icon.png --text "What do you want?"\
    --column "Selection" --column "Typ" --radiolist  TRUE "New Wallpaper Set" FALSE "Remove Wallpaper Set" FALSE "Set light wallpaper" FALSE "Set dark wallpaper" FALSE "Uninstall" FALSE "About"\
    --width=600 --height=300)

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


    # Uninstall

    if [ "$INPUT" == "Uninstall" ]
    then

        zenity --question\
            --width 500\
            --text="Note that this does not delete the background images! To do this, please use the Remove function first. Do you want to proceed with the uninstallation?"

        case $? in 
            0) 
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

                echo "remove Background Setter"
                rm -rf $cache_folder
                echo "$PASS" | sudo -S rm -rf $install_folder
                echo "$PASS" | sudo -S rm -f /usr/share/application/background-setter.desktop
                exit 0
            ;;
            1)
                
            ;;
            -1)
            zenity --info\
                --width 500\
                --text="Oops. This should not have happened...."
            exit 1
            ;;
        esac


    fi

    # About Background-Setter
    if [ "$INPUT" == "About" ]
    then
    
        if [ "$if_installed" -eq 1 ]
        then
            FILEABOUT="$install_folder/about.txt"
            zenity --text-info \
                --title="About" \
                --filename=$FILEABOUT \
                --width=600 --height=500 \
        
        else

            zenity --info \
            --text="This function is only available if the script has been installed as an app. You are welcome to read about.txt in the folder itself."

        fi
    
    fi
done