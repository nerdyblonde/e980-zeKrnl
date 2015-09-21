#!/bin/bash

if [[ $# -eq 1 ]]; then
	PATCHES_FILENAME="$1"
	echo -e "-> Reading commit list from $PATCHES_FILENAME"

	# History filename
	CHERRYPICK_HISTORY="PickedUp.txt"

	# Total number of commits
	COMMITS=`cat "$PATCHES_FILENAME" | wc -l`

		# Completed number of cherry-picks:
	PICKED=1

	# Check if cherry-picking history exists
	if [ -e "$CHERRYPICK_HISTORY" ]; then
		echo -e "-> Some commits are already cherry-picked. I'll avoid them as they come."
	else
		touch "$CHERRYPICK_HISTORY"
	fi

	while read -r line; do
		echo -e " "
		echo -e "+++ cherry-picking commit $PICKED of $COMMITS +++"
		# cherry state. 0 for "not picked", 1 for "picked"
		CHERRY_STATE=0
		
		# cherry SHA1 hash
		CHERRY_HASH=`echo $line | cut -d \  -f 1`

		# Check if cherry is already picked and set needed flag if yes.
		while read -r picked; do
			OLD_CHERRY_HASH=$picked
			if [ "$CHERRY_HASH" == "$OLD_CHERRY_HASH" ]; then
				echo -e ":: $line is already cherry-picked"
				CHERRY_STATE=1
			fi
		done < "$CHERRYPICK_HISTORY"
		
		# If cherry isn't already picked, DO IT NOW
		if [[ $CHERRY_STATE -eq 0 ]]; then
			echo ":: cherry-picking $line..."
			eval git cherry-pick "$CHERRY_HASH"
			retCode=$?
			if [[ $retCode -eq 0 ]]; then
				echo -e ":: + Commit $CHERRY_HASH successfuly merged."
				echo "$CHERRY_HASH" >> "$CHERRYPICK_HISTORY"
			else
				echo -e ":: + Possibile merge needed. Starting meld..."
				eval git mergetool -t meld
				mergeRetCode=$?
				if [[ $mergeRetCode -eq 0 ]]; then
					git cherry-pick --continue
					echo -e ":: + Merge success. Contintinuing with cherry-picking..."
					echo "$CHERRY_HASH" >> "$CHERRYPICK_HISTORY"
				else
					echo -e ":: + Merge failed. Please fix errors and restart script"
					exit
				fi
			fi
		fi
		PICKED=$((PICKED+1))
	done < "$PATCHES_FILENAME"
else
	echo -e "-> Usage: sh patch_me.sh commit_list_filename"
fi
