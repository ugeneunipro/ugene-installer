#!/bin/bash

IS_ROOT="1"
LOG_FILE=associating.log

UGENE_BIN_PATH="$1"

#echo 'Extracting the icons to "~/.local/share/icons":'  | tee -a $LOG_FILE
if [ -e ~/.local/share/icons ]; then
    tar -xvzf icons.tar.gz -C ~/.local/share/icons 2>&1 | tee -a $LOG_FILE
else
    mkdir -p ~/.local/share/icons
    tar -xvzf icons.tar.gz -C ~/.local/share/icons 2>&1 | tee -a $LOG_FILE
fi
if [ -e ~/.local/share/pixmaps ]; then
    cp -f ugene.png ~/.local/share/pixmaps 2>&1 | tee -a $LOG_FILE
else
    mkdir -p ~/.local/share/pixmaps
    cp -f ugene.png ~/.local/share/pixmaps 2>&1 | tee -a $LOG_FILE
fi

#echo 'Creating the MIME types (copy application-x-ugene.xml to ~/.local/share/mime/packages):' | tee -a $LOG_FILE
if [ -e ~/.local/share/mime/packages/ ]; then
    cp -f application-x-ugene.xml ~/.local/share/mime/packages/ 2>&1 | tee -a $LOG_FILE
else
    mkdir -p ~/.local/share/mime/packages/
    cp -f application-x-ugene.xml ~/.local/share/mime/packages/ 2>&1 | tee -a $LOG_FILE
fi

#echo 'Updating new MIME types.' | tee -a $LOG_FILE
update-mime-database ~/.local/share/mime/ 2>&1 | tee -a $LOG_FILE

#echo 'Adding the MIME types to the ugene.desktop file.' | tee -a $LOG_FILE
if [ -e ~/.local/share/applications/ugene.desktop ]; then
    cp ~/.local/share/applications/ugene.desktop ~/.local/share/applications/ugene.desktop.bak
    grep -v "MimeType=" ~/.local/share/applications/ugene.desktop.bak|grep -v "Icon="|grep -v "Exec=" > ~/.local/share/applications/ugene.desktop
    echo "Icon=$HOME/.local/share/pixmaps/ugene.png" >>~/.local/share/applications/ugene.desktop
    echo "Exec=$UGENE_BIN_PATH/ugene -ui" >>~/.local/share/applications/ugene.desktop
    echo "MimeType=application/x-ugene-fa;application/x-ugene-uprj;application/x-ugene-uwl;application/x-ugene-uql;application/x-ugene-abi;application/x-ugene-aln;application/x-ugene-embl;application/x-ugene-sw;application/x-ugene-fastq;application/x-ugene-gb;application/x-ugene-gff;application/x-ugene-msf;application/x-ugene-newick;application/x-ugene-pdb;application/x-ugene-sam-bam;application/x-ugene-srfa;application/x-ugene-sto;application/x-ugene-db;application/x-ugene-scf;application/x-ugene-mmdb;application/x-ugene-hmm;" >>~/.local/share/applications/ugene.desktop
    rm ~/.local/share/applications/ugene.desktop.bak
else
    if [ -e ~/.local/share/applications/ ]; then
        grep -v "Icon=" ugene.desktop|grep -v "Exec=" > ~/.local/share/applications/ugene.desktop
        echo "Icon=$HOME/.local/share/pixmaps/ugene.png" >>~/.local/share/applications/ugene.desktop
        echo "Exec=$UGENE_BIN_PATH/ugene -ui" >>~/.local/share/applications/ugene.desktop
    else
        mkdir -p ~/.local/share/applications/
        grep -v "Icon=" ugene.desktop|grep -v "Exec=" > ~/.local/share/applications/ugene.desktop
        echo "Icon=$HOME/.local/share/pixmaps/ugene.png" >>~/.local/share/applications/ugene.desktop
        echo "Exec=$UGENE_BIN_PATH/ugene -ui" >>~/.local/share/applications/ugene.desktop
    fi
fi

exit 0
