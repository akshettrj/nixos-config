{
  config,
  lib,
  pkgs,
  ...
}:

{
  config =
    let

      pro_services = config.propheci.services;
      pro_user = config.propheci.user;

      tgbotapi_script = pkgs.writeShellScriptBin "tgbotapi" ''
        [[ -d "${pro_services.telegram_bot_api.data_dir}" ]] || mkdir "${pro_services.telegram_bot_api.data_dir}"
        [[ -d "${pro_services.telegram_bot_api.data_dir}/temp" ]] || mkdir "${pro_services.telegram_bot_api.data_dir}/temp"
        [[ -f "${pro_services.telegram_bot_api.data_dir}/logs.txt" ]] || touch "${pro_services.telegram_bot_api.data_dir}/logs.txt"

        ${pkgs.telegram-bot-api}/bin/telegram-bot-api \
            --local \
            --api-id 611335 \
            --api-hash d524b414d21f4d37f08684c1df41ac9c \
            --http-port ${toString (pro_services.telegram_bot_api.port)} \
            --dir ${pro_services.telegram_bot_api.data_dir} \
            --temp-dir ${pro_services.telegram_bot_api.data_dir}/temp \
            --log ${pro_services.telegram_bot_api.data_dir}/logs.txt \
      '';

    in
    lib.mkIf pro_services.telegram_bot_api.enable {

      systemd.services.tgbotapi = {
        description = "Running local instance of Telegram Bot API server";

        after = [ "network.target" ];
        requires = [ "network.target" ];

        serviceConfig = {
          User = pro_user.username;
          Type = "exec";
          Restart = "on-failure";
          ExecStart = "${tgbotapi_script}/bin/tgbotapi";
        };
      };

    };
}
