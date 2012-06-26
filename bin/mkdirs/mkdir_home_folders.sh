#!/bin/bash
# Restore folderstructure in ~./
HOMEP=.
HOME_DIRS=(bak bin dev dl doc media pub src tmp work www)
for HOME_DIR in ${HOME_DIRS[*]}
do
	mkdir -p $HOMEP/$HOME_DIR
done

# Restore folderstructure in ~/dl/.
D_CATEGORIES=(.leeching seeding .watch)
D_ITEMS=(apps ebooks games misc movies music)
for D_CATEGORY in ${D_CATEGORIES[*]}
do
	for D_ITEM in ${D_ITEMS[*]}
	do
		mkdir -p $HOMEP/dl/$D_CATEGORY/$D_ITEM
	done
done
# Specic folders.
mkdir -p $HOMEP/dl/.sessions
mkdir -p $HOMEP/dl/.socket

# Restore folderstructure in ~/multimedia/.
M_ITEMS=(gui images music video)
for M_ITEM in ${M_ITEMS[*]}
do
	mkdir -p $HOMEP/media/$M_ITEM
done
