# RustBetterBackup

RustBetterBackup is a Windows batch script for keeping rotating backups of a Rust server instance and its Oxide install folder.

The script is intended for self-hosted Windows Rust servers where the default backup folders are hard to identify or restore from. Each backup slot receives a timestamp file, an `Oxide` copy, and a `Server1` copy so you can restore the server state from a known point in time.

## What It Backs Up

- The Rust server instance directory configured as `ServerDir`
- The Oxide directory under the configured Rust install root
- A `TimeStamp.txt` file in each backup slot

Backups are stored under:

```text
<RustDir>\BetterBU
```

## Requirements

- Windows
- A Rust dedicated server install
- Enough disk space for the configured number of backup slots
- Permission to read the Rust/Oxide folders and write to the backup folder

## Configuration

Edit these values near the top of `RustBetterBU.bat`:

```bat
@set "RustDir=r:\rustserver"
@set "ServerDir=r:\rustserver\server\server1"
@set /A D=12
@set /A W=4
@set /A C=7
```

- `RustDir`: Root folder of the Rust server install.
- `ServerDir`: Specific server instance folder to back up.
- `D`: Number of backups per day. The default `12` means every two hours.
- `W`: Number of days of backup slots to keep.
- `C`: Backup slot to start with. Use this if restarting the script and you do not want it to begin overwriting slot `1`.

Total backup slots are calculated as:

```text
D * W
```

## Running

Open a Command Prompt and run:

```bat
RustBetterBU.bat
```

The script displays the configured paths and timing before starting. Review those values carefully before continuing.

## Restore Process

1. Stop the Rust server.
2. Choose the backup folder you want to restore from and check its `TimeStamp.txt`.
3. Rename the existing live server instance folder, for example `server1` to `server1-bak`.
4. Copy the backup `Server1` folder into your Rust `server` folder.
5. Rename the existing live `Oxide` folder, for example `Oxide` to `Oxide-bak`.
6. Copy the backup `Oxide` folder into your Rust install root.
7. Start the server and verify it loads correctly.

## Notes And Cautions

- Backup slots are reused. If you need to keep a backup forever, copy it somewhere else before its slot comes around again.
- The script uses `robocopy /MIR`, which mirrors source folders into each backup slot. This keeps stale deleted files out of restore points, but it also means each backup slot is overwritten to match the current live folder.
- Test your restore process before relying on the backups during an incident.
