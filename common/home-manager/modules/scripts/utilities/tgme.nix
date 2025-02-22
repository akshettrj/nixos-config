{pkgs, ...}: {
  config = let
    tgme = pkgs.writeShellScriptBin "tgme" ''
      if [[ "''${#}" -eq 0 ]]
      then
         echo 'NAME:'
         echo '   tgme - send messages to your Telegram account'
         echo ""
         echo 'SYNOPSIS:'
         echo '   tgme [options] "TEXT"'
         echo '   tgme [options] "TITLE" "TEXT"'
         echo '   tgme [options] "TITLE" "SUBTITLE" "TEXT"'
         echo ""
         echo 'OPTIONS:'
         echo '   If the options are not passed, then they will'
         echo '   be read from the configuration files'
         echo ""
         echo '   -b|--bot-token          The Bot API token'
         echo '   -c|--chat-id            The Chat ID to send message to'
         echo ""
         echo 'CONFIGURATION:'
         echo '   The configuration shall consist of two files.'
         echo '   One file named "token" shall contain the Telegram API token of your bot.'
         echo '   A second file named "chatid" that shall contain the Telegram chat ID in which the bot is added.'
         echo '   Use botfather within Telegram to create a bot and get a token for it.'
         echo '   Add the bot and send a dummy message, then put "https://api.telegram.org/bot<YourBOTToken>/getUpdates"'
         echo '   in your browser to find the chat_id.'
         exit 0
      fi

      # if [[ "''${#}" -gt 3 ]]
      # then
      #    echo "tgme error: too many arguments"
      #    exit 3
      # fi

      POSITIONAL_ARGS=()
      while [[ "''${#}" -gt 0 ]]; do
         key="$1"

         case $key in
            -b|--bot-token)
               Token="$2"
               shift # past argument
               shift # past value
               ;;
            -c|--chat-id)
               ChatID="$2"
               shift # past argument
               shift # past value
               ;;
            *)
               # save in array for later
               POSITIONAL_ARGS+=("$1")
               shift # past argument
               ;;
         esac
      done

      set -- "''${POSITIONAL_ARGS[@]}" # Restore positional arguments

      if [ -z "$Token" ] || [ -z "$ChatID" ]; then
         CfgPath="''${HOME}/.config/tgme"
         TokenFile="''${CfgPath}/token"
         ChatIDFile="''${CfgPath}/chatid"
      fi

      if [ -z "$Token" ]; then
         Token="$(${pkgs.coreutils}/bin/cat "''${TokenFile}")"
      fi
      if [ -z "$ChatID" ]; then
         ChatID="$(${pkgs.coreutils}/bin/cat "''${ChatIDFile}")"
      fi

      Api="https://api.telegram.org/bot''${Token}"

      if [[ "''${#}" -eq 1 ]] # text
      then
         Message="''${1}"
      fi

      if [[ "''${#}" -eq 2 ]] # title and text
      then
         Title="<b>''${1}</b>"
         Text="''${2}"
         Message="''${Title}\n\n''${Text}"
      fi

      if [[ "''${#}" -eq 3 ]] # title, subtitle and text
      then
         Title="<b>''${1}</b>"
         Subtitle="<i>''${2}</i>"
         Text="''${3}"
         Message="''${Title}\n''${Subtitle}\n\n''${Text}"
      fi

      Data="{\"chat_id\":\"''${ChatID}\", \"text\":\"''${Message}\", \"parse_mode\":\"HTML\"}"
      Call="${pkgs.curl}/bin/curl -s -X POST -H 'Content-Type: application/json' -d ''\'''${Data}' ''${Api}/sendMessage"
      Response=$(eval "''${Call}")

      if [ "''${?}" -ne 0 ]
      then
         echo "tgme error: something went wrong"
         exit 1
      fi

      # if [ "$(echo "''${Response}" | dasel select -p json 'ok')" != 'true' ]
      # if [ "$(echo "''${Response}" | jq '.ok')" != 'true' ]
      if [ "$(echo "''${Response}" | ${pkgs.gnugrep}/bin/grep -o '"ok":\(true\|false\)')" != '"ok":true' ]
      then
         echo "tgme error: could not send message"
         echo "Call:"
         echo "    ''${Call}"
         echo "Response:"
         echo "    ''${Response}"
         exit 2
      fi

      exit 0
    '';
  in {
    home.packages = [tgme];
  };
}
