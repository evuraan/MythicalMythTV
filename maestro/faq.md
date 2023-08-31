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

## On the fly encoding
- ffmpeg must be in path.
- seek (ffwd/rewind) will not work. (See #6)

## Troubleshooting

### I encountered an issue. What should I do?

File an issue with pertinent details at https://github.com/evuraan/MythicalMythTV/issues

### How can I get help or support?

Use  https://github.com/evuraan/MythicalMythTV/issues


