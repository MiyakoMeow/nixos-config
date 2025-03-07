{
  config,
  lib,
  pkgs,
  ...
}:
let
  deviceType = config.deviceType;
in
{
  options.deviceType = lib.mkOption {
    type = lib.types.enum [
      "desktop"
      "laptop"
      "server"
    ];
    default = "desktop";
    description = "设备类型：desktop(台式机)、laptop(笔记本)、server(服务器)";
  };

  config = {
    # Auto-cpufreq - 自动CPU频率管理
    services.auto-cpufreq = {
      # 与niri shell冲突，关闭
      enable = false;
      settings = {
        battery = {
          governor = if deviceType == "laptop" then "powersave" else "ondemand";
          turbo = if deviceType == "laptop" then "never" else "auto";
        };
        charger = {
          governor = if deviceType == "desktop" then "performance" else "ondemand";
          turbo = "auto";
        };
      };
    };

    # ACPI 事件处理脚本
    services.acpid.handlers = {
      # 电源按钮事件
      powerButton = {
        event = "button/power.*";
        action = ''
          # 记录电源按钮事件
          logger "ACPI power button pressed"
          # 可以在这里添加自定义动作，如发送通知等
        '';
      };

      # 睡眠按钮事件
      sleepButton = {
        event = "button/sleep.*";
        action = ''
          logger "ACPI sleep button pressed"
          systemctl suspend
        '';
      };
    }
    // lib.optionalAttrs (deviceType == "laptop") {
      # 盖子开关事件 (仅笔记本)
      lidSwitch = {
        event = "button/lid.*";
        action = ''
          logger "ACPI lid switch triggered"
          # 根据盖子状态执行相应动作
          if grep -q closed /proc/acpi/button/lid/LID/state; then
            systemctl suspend
          fi
        '';
      };
    };

    # 系统包
    environment.systemPackages = with pkgs; [
      # 电源管理工具
      powertop
      auto-cpufreq
      acpi
      acpitool
      cpupower-gui

      # 系统监控工具
      htop
      iotop
      ncdu

      # 硬件信息工具
      lshw
      hwinfo
      dmidecode

      # USB调试工具
      usbutils
      evtest
    ];
  };
}
