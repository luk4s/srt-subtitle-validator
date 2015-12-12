# SRT subtitle validator & converter

Check SRT file and try to fix it.

* Convert to UTF-8
* Convert line-endings to UNIX/Linux
* Recreate number counter sequence

## Why?
Because in my case Plex server & TV doesn't show subtitle correctly.

## Installation
```ruby
gem install 'srt_subtitle_validator'
```

## Usage

* Process files are overwritten with results. 
* For all processed files are created backup.


### For analyze
```
srt_checker check <path to SRT file(s)>
```

### For direct convert
```
srt_checker convert <path to SRT file(s)>
```

### General options
`--output, -o` : Specify output directory of file. By default its same as input

`--without_backup` : Skip creating backup files.

`--encoding, -e` : Encoding of input file. By default it's windows-1250
