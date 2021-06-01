# ext4 fs tuning

## disable journaling:

stop writing of journal information to reduce unneeded IO

```
mkdir.ext4 /dev/sdXy
tune2fs -O "^has_journal" /dev/sdXy
```

## mount with `noatime`

similar to above, stop writing of time stamp information

```
/dev/md0    /mnt/plotting    ext4    defaults,noatime    0    2
```
