# CF_DDNS_UPNP #

My third Python project and first Dockerized app, this is a Python3 script to monitor my home WAN IP for changes and update my Cloudflare DNS records and notify me via email when it happens. 

The previous iteration, [CF_DDNS](https://github.com/phillymjs/cf_ddns), was just a standalone script that ran on bare metal and relied on an outside service to get the WAN IP. I never liked having to rely on a service that could go out of business or start blocking me, so this one gets the WAN IP by querying my Verizon FiOS router via UPNP.


#### Usage ####

- Clone the repository to a local machine
- Edit the docker-compose.yml
    - Add your Cloudflare Zone ID, API token, and the target DNS record(s)
    - Add your email info
    - Set the email test flag
    - Set the time zone for the log timestamps
- *docker compose up -d*


#### Miscellaneous Notes ####

The script is called by cron within the container. I have it set to run immediately upon container start and then every 2 minutes afterward.

If the email test flag is set to true, the script will send a test message every time it runs. To enable/disable test emails do *docker compose down*, change the flag, and then do *docker compose up -d*.

The data folder that holds the log file and the file that holds the current WAN IP is mapped to a persistent volume.

If no change to the WAN IP is detected, the script will just update the modification date by touching the log file.

All the DNS records I update are not proxied, which is hardcoded in the script.


#### Sample Log Entries ####

>2025/04/17 15:55:42 - IP changed  
>2025/04/17 15:55:42 - Old: 192.168.1.236  
>2025/04/17 15:55:42 - New: 192.168.1.242  
>2025/04/17 15:55:44 - Update email sent successfully    
 

#### Sample Alert Email Text ####

>From: DDNS Updater <myalertaddress@mydomain.com\>  
>To: Me <me@mydomain.com\>  
>Subject: DDNS Updated  
  
>IP changed  
>Old: 192.168.1.236  
>New: 192.168.1.242  
>server1.mydomain.com updated successfully  
>server2.mydomain.com updated successfully  

