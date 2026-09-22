# KiCad Component Library Database — Setup Guide

A postgresql db schema and support files for a KiCAD db library

A python based GUI for the db is in development here: [kicad_db_ui](https://github.com/jboulton/kicad_db_gui).
This covers installing PostgreSQL, creating the component library database, exposing it over TCP on the LAN, and connecting via ODBC — on macOS, Linux, and Windows.

## 1. Install PostgreSQL

**macOS (Homebrew)**

```bash
brew install postgresql@18
brew services start postgresql@18
```

Homebrew does **not** create a `postgres` superuser — instead your OS username is the initial superuser. Confirm with:

```bash
whoami
psql -U $(whoami) -d postgres -c "\du"
```

**Linux (Debian/Ubuntu)**

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl enable --now postgresql
```

On Linux the `postgres` superuser exists by default; run admin commands as:

```bash
sudo -u postgres psql -c "\du"
```

**Linux (Fedora/RHEL)**

```bash
sudo dnf install postgresql-server postgresql-contrib
sudo postgresql-setup --initdb
sudo systemctl enable --now postgresql
```

**Windows**

1. Download the installer from [postgresql.org/download/windows](https://www.postgresql.org/download/windows/) (EDB's installer bundles PostgreSQL + pgAdmin).
2. Run it — you'll be prompted to set a password for the `postgres` superuser during install; keep the default port `5432`.
3. Postgres installs as a Windows service and starts automatically. Confirm with:

   ```powershell
   Get-Service postgresql*
   ```
4. Use **SQL Shell (psql)** from the Start Menu, or `psql` from a terminal if you added the `bin` folder to your `PATH` during install.

## 2. Create the role and database

Choose a role name and password for your database user.

**macOS**

```bash
psql -U $(whoami) -d postgres -c \
  "CREATE ROLE <db_user> WITH LOGIN PASSWORD '<db_password>' SUPERUSER;"
createdb -U $(whoami) -O <db_user> kicad_lib
```

**Linux**

```bash
sudo -u postgres psql -c \
  "CREATE ROLE <db_user> WITH LOGIN PASSWORD '<db_password>' SUPERUSER;"
sudo -u postgres createdb -O <db_user> kicad_lib
```

**Windows** (from SQL Shell, connecting as `postgres`)

```sql
CREATE ROLE <db_user> WITH LOGIN PASSWORD '<db_password>' SUPERUSER;
CREATE DATABASE kicad_lib OWNER <db_user>;
```

## 3. Create the schema

Load the schema from `electronics.sql` to set up an empty database with the required tables:

```bash
psql -U <db_user> -d kicad_lib -f electronics.sql
```

(Windows: run the same command from **SQL Shell** or a terminal with `psql` on `PATH`.)

## 4. Migrating an existing database (optional)

If you're moving an existing library to a new machine rather than starting fresh, dump it on the source machine:

```bash
pg_dump -U <db_user> -Fc -d kicad_lib -f kicad_lib.dump
```

Copy the `.dump` file across, then restore on the target machine (after step 2, skipping step 3):

```bash
pg_restore -U <db_user> -d kicad_lib kicad_lib.dump
```

(macOS: use your OS username in place of `<db_user>` for `-U` if it's not yet a superuser; Windows: run via SQL Shell/terminal the same way.)

## 5. Enable TCP access on the LAN

Config file locations:

- **macOS (Homebrew)**: `<brew --prefix>/var/postgresql@18/`
- **Linux (Debian/Ubuntu)**: `/etc/postgresql/<version>/main/`
- **Linux (Fedora/RHEL)**: `/var/lib/pgsql/data/`
- **Windows**: `C:\Program Files\PostgreSQL\<version>\data\`

**`postgresql.conf`** — set:

```
listen_addresses = '*'
```

**`pg_hba.conf`** — add (adjust subnet to match your LAN):

```
host    kicad_lib    <db_user>    192.168.1.0/24    scram-sha-256
```

Restart to apply:

```bash
# macOS
brew services restart postgresql@18

# Linux
sudo systemctl restart postgresql

# Windows (PowerShell, as Administrator)
Restart-Service postgresql-x64-<version>
```

## 6. Networking

- Give the server machine a **static/reserved LAN IP** (DHCP reservation by MAC address on your router) so client configs don't break later.
- Check your firewall isn't blocking TCP 5432:
  - macOS: **System Settings → Network → Firewall**
  - Linux: `sudo ufw allow 5432/tcp` (if using ufw)
  - Windows: allow port 5432 in **Windows Defender Firewall → Advanced Settings → Inbound Rules**
- Find the current IP if needed:
  - macOS/Linux: `ip addr` or `ipconfig getifaddr en0`
  - Windows: `ipconfig`

## 7. Configure ODBC on each client machine

Install an ODBC driver manager + the PostgreSQL ODBC (psqlODBC) driver:

- **macOS**: `brew install unixodbc psqlodbc`
- **Linux**: `sudo apt install unixodbc odbc-postgresql` (or your distro's equivalent)
- **Windows**: download the psqlODBC installer from [odbc.postgresql.org](https://odbc.postgresql.org/) — it registers itself with the built-in Windows ODBC Data Source Administrator, no `odbc.ini` editing needed (configure the DSN via **ODBC Data Sources** in the Start Menu instead).

**macOS/Linux `odbc.ini`:**

```ini
[DSN_PostgreSQL_KiCAD]
Description = PostgreSQL KiCad
Driver = Driver_PostgreSQL
Servername = <server-static-ip>
ReadOnly = No
Database = kicad_lib
Port = 5432
User = <db_user>
Password = <db_password>
```

Confirm `odbcinst.ini` defines `Driver_PostgreSQL` pointing at the installed driver (`.so`/`.dylib`) path, and check which config files are active with:

```bash
odbcinst -j
```

## 8. Test the connection

```bash
# Direct Postgres connection
psql -h <server-static-ip> -U <db_user> -d kicad_lib

# ODBC layer (macOS/Linux)
isql -v DSN_PostgreSQL_KiCAD <db_user> <db_password>
```

On Windows, test the DSN via **ODBC Data Sources → Configure → Test**, or connect through the KiCad database library dialog directly.

Both should connect without error. From the `isql` prompt (or a `SELECT` query), confirm the schema from `electronics.sql` loaded correctly.
