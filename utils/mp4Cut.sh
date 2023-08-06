#!/bin/bash 

# Author: Evuraan@gmail.com

# Example script to re-encode our mpeg ts to be playable 
# on Roku using Mythical MythTV player

lock="/tmp/p.lock"

if [ -s $lock ] ; then
	echo "$0 already running"
	exit 1
fi

date > $lock

# Function to remove the lock file
cleanup() {
 echo "$(date) Cleaning up and removing the lock file."
 rm "$lock"
}

# Set the trap to call the cleanup function on script exit (error or success)
trap cleanup EXIT


## Change these to suit your setup
mysq="mysql -uUSERNAME -pPASSWORD mythconverg"
cd /var/lib/mythtv/recordings
## Change these to suit your setup


#ts_files=$(find . -type f -name "*.ts" -mmin +5)

# We need to allow mythcommflag to finish
ts_files=$(find . -type f -name "*.ts" -mmin +5 -exec sh -c 'lsof -t "{}" >/dev/null || echo "{}"' \;)

#for i in *ts; do
for a in $ts_files; do
	if [ ! -s "$a" ] ; then
		continue
	fi
	i=${a/\.\//}
	srcFile="$i"
	started=$(date)
	echo "$started Looking at $i"
	tag="compressed-$(md5sum <<< $i)"
	tagFile=${tag/ */}
	if [ -s $tagFile ] ; then
		echo "$(date) found $tagFile, skpipping $i"
		continue
	fi

	x="Cut-$RANDOM-$RANDOM.mpg"
	y="Cut-$RANDOM-$RANDOM.mp4"
	cutList="Cut-$RANDOM-$RANDOM.cutList"

	chanid=$(echo "select chanid from recorded where basename=\"$i\" " | $mysq 2>/dev/null |tail -1)
	starttime=$(echo "select starttime from recorded where basename=\"$i\" " | $mysq 2>/dev/null |tail -1)
	title=$(echo "select title from recorded where basename=\"$i\" " | $mysq 2>/dev/null |tail -1)
	if [[ -n $chanid && -n $starttime && -n $title ]]; then
		echo "Prereq checks met"
	else
		# some stuff is empty. skip
		echo "Error: Prereq not met"
		continue
	fi

	mythutil --gencutlist --chanid $chanid --starttime "$starttime" -q
	mythutil --getcutlist --chanid  $chanid --starttime "$starttime" -q | awk  {'print $2'} |grep "-" > "$cutList"
	if [ ! -s $cutList ]; then
		echo "no cutlist, ffmpeg src: $i"
	else
		echo "Transcoding $i to $x"
		mythtranscode -m --honorcutlist $(< $cutList ) -i $i -o $x -q
		#if [ $? -eq 0 ]; then
		if [ -s "$x" ]; then
			echo "Using $x (mythtranscoded) as ffmpeg srcFile"
			srcFile="$x"
		fi
	fi
	echo "ffmpeg src: $i"
	ffmpeg -err_detect ignore_err  -i  "$srcFile" -video_track_timescale 30000 -c copy -fflags +genpts $y
	# acodec mp3 for older roku
	#ffmpeg -err_detect ignore_err  -i  "$srcFile" -video_track_timescale 30000  -vcodec copy -acodec mp3 -fflags +genpts $y
	if [ -s "$y" ]; then
		#cp "$y" "$i.mp4"
		#mv "$i" "$i.transcoded_to_mp4"
		cp "$y" "$i"
		echo "Success. $i start: $started end: $(date)"
		echo "Success. $i start: $started end: $(date)" > $tagFile
	else
		echo "Failed to transcode $i" 
	fi
	rm $x $y $cutList || : 
done


