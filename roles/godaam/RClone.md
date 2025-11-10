# Google Drive sync

### Reauthenticate

When the token expires:
```
ssh -L localhost:53682:localhost:53682 user@godaam
```

then run on godaam
```
rclone config reconnect ap-gdrive:
```

select Y for have token, Y for browser. When browser spawning fails, take the auth URL from console and open in local broswer to update token. Select N for using team drive

### dry run sync

```
rclone sync --dry-run --no-update-modtime --no-update-dir-modtime --exclude-from /mnt/cache/appdata/rclone/excludes.txt /mnt/user/data/Data/NASDocs/ ap-gdrive:/badagodaam/documents
```

remove `--dry-run` to do actual sync
