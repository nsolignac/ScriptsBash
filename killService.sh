SERVICE = ""

ps -ef | grep "$SERVICE" | grep -v grep | awk '{print $2}' | xargs kill
