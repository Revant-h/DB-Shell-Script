# MySQL User Management Script

This Bash script provides a comprehensive solution for managing MySQL user access and privileges across multiple databases and hosts. It offers various functionalities to streamline user administration tasks.

# Scripts
mysql-access.sh: Main script for creating, updating, and managing MySQL user access.
temp-delete.sh: Script for automatically deleting temporary users based on expiration dates.

# Features
- Create new MySQL users with specified privileges
- Update existing user privileges
- Grant access to specific databases or all databases
- Migrate users between different hosts
- Provide temporary access with automatic expiration
- Delete users from all hosts
- Support for different environments (Staging, Demo, Sandbox, Production)

## Features

- Create new MySQL users and grant privileges
- Update existing user privileges
- Migrate users from one host to another
- Delete users from all hosts
- Provide temporary access to users

## Usage

To use the script, run it with Bash:

```bash
./mysql-access.sh
```

The script will present a menu with the following options:

1. Create users and grant privileges
2. Migrate users from different hosts
3. Update user privileges
4. Delete users from all hosts
5. Provide temporary access on a host

Follow the prompts to perform the desired action.

temp-delete.sh

This script automatically deletes temporary users whose access has expired. It should be run periodically (e.g., daily via a cron job) to maintain security.
To run the script:

```bash
./temp-delete.sh
```

## Configuration

Before running the script, ensure you have a `DB.txt` file in the same directory with the following content:

```
dbuser=your_database_username
password=your_database_password
```

Replace `your_database_username` and `your_database_password` with the appropriate credentials for your MySQL server.

## Host Configuration

The script uses two files to manage hosts:

- `hostname.txt`: List of non-production hosts
- `hostname-prod.txt`: List of production hosts

Ensure these files are present and contain the appropriate host names.

## User Management

User information is stored in a `user.txt` file with the following format:

```
username password staging_privilege demo_privilege sandbox_privilege prod_privilege
```

The script will read from and update this file as needed.

## Temporary Access

Temporary user access is managed through a `user_temp.txt` file. The script will create and update this file when providing temporary access.

## Security Considerations

- Ensure the script and configuration files have appropriate permissions
- Regularly review and update user access
- Use strong, unique passwords for each user
- Consider implementing additional security measures such as SSL connections and IP restrictions

## Limitations

- The script assumes a specific database naming convention (e.g., databases starting with "issue", "elastic", "cmdb", "ivr", "brcm_", or "signup_")
- It does not handle advanced MySQL features like role-based access control

## Maintenance

Regularly review and update the script to ensure it meets your organization's security policies and MySQL version compatibility.
