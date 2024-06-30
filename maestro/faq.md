# maestro: Frequently Asked Questions (FAQ)

Welcome to the Frequently Asked Questions (FAQ) section. Below, you'll find answers to common questions about our project.

## General Questions

### What is maestro?

`maestro` is the orchestrating component the Mythical MythTV Roku channel connects to.

## Usage

### How to exclude recordings below a certain size threshold?

Use the `-minSize` argument to `maestro` to define the threshold: 
```bash
  -minSize int
        minimum recording size in bytes (default 10000)
```

### What is `-mtime` flag for?

Use `-mtime` flag to avoid recordings that are "too" new. Depending on your setup, you may find this useful.

```bash
  -mtime duration
        recording file must be at least this old before it is accepted for playback (default 1h0m0s)
```

### What is the purpose of `-ignoreDelete` ?

Suppose, you are running maestro as `http://maestro:8080/` for a set of devices. You would also like another endpoint `http://othermaestro:8081/` for, say, your parent's. 

You may want to have `maestro` ignore delete requests from the latter. If so, launch the second instance with this flag:

```bash
$ ./maestro -ignoreDelete -port 8081 -maestroBaseURL http://othermaestro:8081/
```
### Running maestro: Can I run maestro without a MythTV backend?
Sure you can. Use the `-remoteFeeds` option:

```bash
$ maestro  -port 9000  -disableOnTheFly -noMythBE -debug -ignoreDelete  -remoteFeeds https://evuraan.info/evuraan/stuff/Mythical/json.feed
```
### I have two backends. How to export the feeds so it can be syndicated by another `maestro` instance?
On your backend1, start maestro on an alt port, with `-ignoreDelete` option:
```bash
$ ./maestro  -port 9000 -ignoreDelete 
syndicating 
Listening on:
  1  http://127.0.0.1:9000/
  2  http://192.168.2.35:9000/
```
Then launch the client instance using the `-remoteFeeds` option that reads from your above feed.
```bash
$ ./maestro -ignoreDelete -port 8081 -remoteFeeds http://192.168.2.35:9000/feed 
```
Connect your roku this instance's port 8081. 


## Troubleshooting

### I encountered an issue. What should I do?

File an issue with pertinent details at https://github.com/evuraan/MythicalMythTV/issues

### How can I get help or support?

Use  https://github.com/evuraan/MythicalMythTV/issues


