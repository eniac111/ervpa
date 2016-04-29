#! /bin/sh

# Base on Gitlab. khairul@bukalapak.com

# GITLAB
# Maintainer: @randx
# Authors: rovanion.luckey@gmail.com, @randx
# App Version: 6.0

### BEGIN INIT INFO
# Provides:          gitlab
# Required-Start:    $local_fs $remote_fs $network $syslog redis-server
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: GitLab git repository management
# Description:       GitLab git repository management
### END INIT INFO

### Environment variables
RAILS_ENV="production"

# Script variable names should be lower-case not to conflict with internal
# /bin/sh variables such as PATH, EDITOR or SHELL.
app_root="/home/errbit/errbit"
app_user="errbit"
unicorn_conf="$app_root/config/unicorn.rb"
pid_path="$app_root/tmp/pids"
socket_path="$app_root/tmp/sockets"
web_server_pid_path="$pid_path/unicorn.pid"


### Here ends user configuration ###


# Switch to the app_user if it is not he/she who is running the script.
if [ "$USER" != "$app_user" ]; then
  sudo -u "$app_user" -H -i $0 "$@"; exit;
fi

# Switch to the errbit path, if it fails exit with an error.
if ! cd "$app_root" ; then
 echo "Failed to cd into $app_root, exiting!";  exit 1
fi

### Init Script functions

check_pids(){
  if ! mkdir -p "$pid_path"; then
    echo "Could not create the path $pid_path needed to store the pids."
    exit 1
  fi
  # If there exists a file which should hold the value of the Unicorn pid: read it.
  if [ -f "$web_server_pid_path" ]; then
    wpid=$(cat "$web_server_pid_path")
  else
    wpid=0
  fi
}

# We use the pids in so many parts of the script it makes sense to always check them.
# Only after start() is run should the pids change. Sidekiq sets it's own pid.
check_pids


# Checks whether the different parts of the service are already running or not.
check_status(){
  check_pids
  # If the web server is running kill -0 $wpid returns true, or rather 0.
  # Checks of *_status should only check for == 0 or != 0, never anything else.
  if [ $wpid -ne 0 ]; then
    kill -0 "$wpid" 2>/dev/null
    web_status="$?"
  else
    web_status="-1"
  fi
}

# Check for stale pids and remove them if necessary
check_stale_pids(){
  check_status
  # If there is a pid it is something else than 0, the service is running if
  # *_status is == 0.
  if [ "$wpid" != "0" -a "$web_status" != "0" ]; then
    echo "Removing stale Unicorn web server pid. This is most likely caused by the web server crashing the last time it ran."
    if ! rm "$web_server_pid_path"; then
      echo "Unable to remove stale pid, exiting"
      exit 1
    fi
  fi
}

# If no parts of the service is running, bail out.
exit_if_not_running(){
  check_stale_pids
  if [ "$web_status" != "0" ]; then
    echo "Errbit is not running."
    exit
  fi
}

# Starts Unicorn
start() {
  check_stale_pids

  # Then check if the service is running. If it is: don't start again.
  if [ "$web_status" = "0" ]; then
    echo "The Unicorn web server already running with pid $wpid, not restarting."
  else
    echo "Starting the Errbit Unicorn web server..."
    # Remove old socket if it exists
    rm -f "$socket_path"/errbit.socket 2>/dev/null
    # Start the webserver
    bundle exec unicorn_rails -D -c "$unicorn_conf" -E "$RAILS_ENV"
  fi

  # Finally check the status to tell wether or not Errbit is running
  status
}

# Asks the Unicorn if it would be so kind as to stop, if not kills them.
stop() {
  exit_if_not_running
  # If the Unicorn web server is running, tell it to stop;
  if [ "$web_status" = "0" ]; then
    kill -QUIT "$wpid" &
    echo "Stopping the Errbit Unicorn web server..."
    stopping=true
  else
    echo "The Unicorn web was not running, doing nothing."
  fi

  # If something needs to be stopped, lets wait for it to stop. Never use SIGKILL in a script.
  while [ "$stopping" = "true" ]; do
    sleep 1
    check_status
    if [ "$web_status" = "0" ]; then
      printf "."
    else
      printf "\n"
      break
    fi
  done
  sleep 1
  # Cleaning up unused pids
  rm "$web_server_pid_path" 2>/dev/null

  status
}

# Returns the status of GitLab and it's components
status() {
  check_status
  if [ "$web_status" != "0" ]; then
    echo "Errbit is not running."
    return
  fi
  if [ "$web_status" = "0" ]; then
      echo "The Errbit Unicorn webserver with pid $wpid is running."
  fi
}

reload(){
  exit_if_not_running
  if [ "$wpid" = "0" ];then
    echo "The Errbit Unicorn Web server is not running thus its configuration can't be reloaded."
    exit 1
  fi
  printf "Reloading Errbit Unicorn configuration... "
  kill -USR2 "$wpid"
  echo "Done."
  sleep 2
  status
}

restart(){
  check_status
  if [ "$web_status" = "0" ]; then
    stop
  fi
  start
}


## Finally the input handling.

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        restart
        ;;
  reload|force-reload)
  reload
        ;;
  status)
        status
        ;;
  *)
        echo "Usage: service errbit {start|stop|restart|reload|status}"
        exit 1
        ;;
esac

exit
