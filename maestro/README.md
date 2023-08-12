# maestro

`maestro` is the orchestrating component the Mythical MythTV Roku channel connects to.

## Setting up `maestro`

Download the suitable binary from the [bin](./bin) folder and launch the service.

`maestro` expects to find environment variables `MYSQL_USERNAME` and `MYSQL_PASSWORD` to connect to your database server.
### Running maestro
`/etc/crontab:`
<pre>
# Set environment variables
MYSQL_USERNAME="username"
MYSQL_PASSWORD="dbPasswd"
# Launch maestro
*/4  *  * * *   nobody  /usr/local/bin/maestro -dbHost 127.0.0.1  1>/dev/null 2>&1 || : 
</pre>

Or, run manually on the terminal as:

```bash
$ export MYSQL_USERNAME="mythtv" MYSQL_PASSWORD="mythtv"
$ ./maestro -debug
Listening on:
  1  http://127.0.0.1:8080/
  2  http://192.168.1.35:8080/
```

#### Usage

```bash
$ ./maestro -h
Usage of ./maestro:
  -dbHost string
    	database host (default "127.0.0.1")
  -dbName string
    	database (default "mythconverg")
  -debug
    	enable debug mode
  -help
    	Show this help message
  -interval duration
    	time interval to update records (default 5m0s)
  -maestroBaseURL string
    	maestro base url (default "http://maestro:8080")
  -minSize int
    	minimum recording size in bytes (default 10000)
  -mythBE string
    	MythTV Backend and Port (default "127.0.0.1:6544")
  -port int
    	server port (default 8080)
  -recordingsPath string
    	path for recordings folder (default "/var/lib/mythtv/recordings")
  -version
    	Show version information
```


#### Connectivity to `maestro`
It is essential that the Roku device is able to connect to `http://<your maestro endpoint>:8080`.

You will get prompted for input if this value is not set before:

![image](https://github.com/evuraan/MythicalMythTV/assets/39205936/2903f7c6-ad09-44c7-9c7f-5afdff9328fd)

Enter your hostname or ip address:

![image](https://github.com/evuraan/MythicalMythTV/assets/39205936/ece69cf9-8246-4b63-97d8-ef9d9e0728d1)


## Video Processing

Roku has specific format requirements for playback. Further, there are generational differences between Roku devices as well.

Factors like your Roku device capability and your MythTV recording formats will determine if your recordings are natively playable by your Roku device.

For the `maestro`'s part, it merely picks up Videos from your `recordingsPath` folder.

If your videos are not playable, you will need to re-encode them to playable formats. When done, place them into your `recordingsPath` folder:

```bash
ffmpeg -err_detect ignore_err  -i  <input file> -video_track_timescale 30000 -c copy -fflags +genpts <output file>
```

Or, for an older Roku device, we had to specify the `mp3` audio codec for the output file:

```bash
ffmpeg -err_detect ignore_err  -i  "$srcFile" -video_track_timescale 30000  -vcodec copy -acodec mp3 -fflags +genpts <output file>
```

`utils` folder contains an [advanced util script example](../utils/mp4Cut.sh) - feel free to tweak and use according to your setup.

## Thumbnails

`recordingsPath` folder is also where `maestro` expects to find `.png` files to use as thumbnails.

If your video `basename` is `13301_20230806004300.ts`, maestro will be looking for `13301_20230806004300.ts.png` file.

If you have to generate thumbnails, here's an example:

```bash
ffmpeg -i 13301_20230806004300.ts -ss 00:00:05 -vframes 1 13301_20230806004300.ts.png
```

## Security and Privacy

- maestro does not read your traffic.
- maestro does not share your traffic.
- maestro does not generate any internet bound network traffic.
- maestro does not have any backdoors.
- maestro does not need write permissions to your database.
- maestro does not need write permissions to your filesystem.
