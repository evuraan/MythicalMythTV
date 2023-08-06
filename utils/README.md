# Utility Scripts 

Example utility script that we use to generate playable videos from MPEG Transport Stream files. 

Feel free to tweak to suit your specific needs:


```bash
/etc/crontab
*/3  *  * * *   mythtv  /usr/local/bin/mp4Cut.sh >> /tmp/mp4cut.log
```


```bash
$ ls -ltr /var/lib/mythtv/recordings/*ts | tail -3
-rw-r--r-- 1 mythtv mythtv  536459438 Aug  5 18:24 /var/lib/mythtv/recordings/13301_20230806004300.ts
-rw-r--r-- 1 mythtv mythtv  777858982 Aug  5 19:24 /var/lib/mythtv/recordings/10402_20230806010000.ts
-rw-r--r-- 1 mythtv mythtv  479393796 Aug  5 19:29 /var/lib/mythtv/recordings/11105_20230806020000.ts
```
