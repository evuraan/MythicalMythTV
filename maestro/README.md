# maestro

`maestro` is the orchestrating component the Mythical MythTV Roku channel connects to.

## Setting up `maestro`

Download the suitable binary from the [bin](./bin) folder and launch the service.

### Running maestro

`/etc/crontab:`

<pre>
# Launch maestro
*/4  *  * * *   mythtv  /usr/local/bin/maestro -port 8118 -maestroBaseURL http://192.168.1.135:8118/
</pre>

Or, run manually on the terminal as:

```bash
$ ./maestro -debug
Listening on:
  1  http://127.0.0.1:8080/
  2  http://192.168.1.35:8080/
```

### Usage

```bash
$ ./maestro -help
Usage :
  -debug
    	enable debug mode
  -disableOnTheFly
    	Disables on-the-fly encoding. If set, you must pre-process your video files. 
    	See https://github.com/evuraan/MythicalMythTV/tree/main/maestro#video-processing
  -help
    	Show this help message
  -ignoreDelete
    	ignore delete requests
  -maestroBaseURL string
    	maestro base url (default "http://maestro:8080/")
  -mimeType string
    	(Optional) Set custom MIME type for video files, example: "video/mp2t"
  -minSize int
    	minimum recording size in bytes (default 10000)
  -mtime duration
    	recording file must be at least this old before it is accepted for playback (default 1h0m0s)
  -mythBE string
    	MythTV Backend and Port (default "127.0.0.1:6544")
  -pickupFolder string
    	(Optional) Folder containing playable video files and thumbnails (or symlinks to..) (default "/var/lib/mythtv/recordings/")
  -port int
    	server port (default 8080)
  -version
    	Show version information
```

## Connectivity to `maestro`

It is essential that the Roku device is able to connect to your `maestroBaseURL`. 

Ensure that you supply the same value to `maestro` using the `-maestroBaseURL` argument.

You will get prompted for input if this value is not set before:

![image](https://github.com/evuraan/MythicalMythTV/assets/39205936/21e6f706-2a23-4b1b-bf32-c2a9599830c9)

Enter your hostname or ip address:

![image](https://github.com/evuraan/MythicalMythTV/assets/39205936/88ecaec5-d662-451a-bd98-8285e37aafde)

## Video Processing

Roku has specific format requirements for playback. Further, there are generational differences between Roku devices as well.

Factors like your Roku device capability and your MythTV recording formats will determine if your recordings are natively playable by your Roku device.

#### On the fly encoding
This is now the default mode, it will try `ffmpeg` to transcode your videos to a playable format. `ffmpeg` must be available in your `PATH`.

Use the `-disableOnTheFly` option to disable on the fly encoding, you will need to pre-process/pre-cook your videos ready for pickup: 

#### Pre-processing your videos

##### Default pickup folder

The [utils](../utils) folder contains a script [example](../utils/mp4Cut.sh) - transcodes and overwrites the original recording file (eg: `/var/lib/mythtv/recordings/13301_20230806004300.ts`) - feel free to tweak and use according to your setup.

##### Custom pickup folder

You can write your processed (roku-playable) files into `/anotherFolder`, and use this folder as the `-pickupFolder` argument:

```bash
$ mkdir /anotherFolder
```

```bash
ffmpeg -err_detect ignore_err  -i  /var/lib/mythtv/recordings/13301_20230806004300.ts -video_track_timescale 30000 -c copy -fflags +genpts /anotherFolder/13301_20230806004300.ts
ffmpeg -i  /var/lib/mythtv/recordings/13301_20230806004300.ts  -vframes 1  /anotherFolder/13301_20230806004300.ts.png
```

Or, for an older Roku device, we had to specify the `mp3` audio codec for the output file:

```bash
ffmpeg -err_detect ignore_err  -i  /var/lib/mythtv/recordings/13301_20230806004300.ts  -video_track_timescale 30000  -vcodec copy -acodec mp3 -fflags +genpts /anotherFolder/13301_20230806004300.ts
ffmpeg -i  /var/lib/mythtv/recordings/13301_20230806004300.ts  -vframes 1  /anotherFolder/13301_20230806004300.ts.png
```

You will need to ask `maestro` to pickup from this folder using the `-pickupFolder` option:

```bash
$ ./maestro -pickupFolder  /anotherFolder -debug
...
```

## Thumbnails

`maestro` expects to find `.png` files to use as thumbnails in the same folder as the video file.

If your video `basename` is `13301_20230806004300.ts`, maestro will be looking for `13301_20230806004300.ts.png` file.

If you have to generate thumbnails, here's an example:

```bash
ffmpeg -i 13301_20230806004300.ts -ss 00:00:05 -vframes 1 13301_20230806004300.ts.png
```

## Frequently Asked Questions

See [FAQ](./faq.md).

## Security and Privacy

- maestro does not read your traffic.
- maestro does not share your traffic.
- maestro does not generate any internet bound network traffic.
- maestro does not have any backdoors.
- maestro does not need write permissions to your filesystem.
- maestro does not need any access to your database.
