{ pkgs, ... }:
{
  # Enable PipeWire audio system
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;

    # 禁用音频设备自动挂起以防止启动延迟
    wireplumber.extraConfig."99-disable-suspend" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            { "node.name" = "~alsa_input.*"; }
            { "node.name" = "~alsa_output.*"; }
          ];
          actions = {
            update-props = {
              "session.suspend-timeout-seconds" = 0;
            };
          };
        }
      ];
    };
  };

  # Disable traditional PulseAudio (replaced by PipeWire)
  services.pulseaudio.enable = false;

  # Enable RTKit for realtime audio scheduling
  security.rtkit.enable = true;

  # MateBook 音频驱动优化配置
  # 禁用冲突的 SOF 驱动，启用 AMD ACP legacy 驱动
  boot.blacklistedKernelModules = [
    "snd-sof-pci"
    "sof-audio-pci-intel-tgl"
  ];
  boot.kernelModules = [
    "snd_acp_legacy_mach"
  ];

  # 添加内核参数以确保正确使用 ACP 驱动
  boot.kernelParams = [
    "snd_hda_intel.dmic_detect=0"
    "snd_hda_intel.power_save=0"
  ];

  # Audio related packages
  environment.systemPackages = with pkgs; [
    portaudio
    pamixer # 命令行音量控制工具
    crosspipe # PatchBay 图形化音频路由工具
  ];

  # Fix ES8316 DAC routing (only routing, no volume changes)
  systemd.services.fix-es8316-audio = {
    description = "Fix ES8316 audio DAC routing for MateBook";
    wantedBy = [ "multi-user.target" ];
    after = [
      "sound.target"
      "pipewire.service"
      "wireplumber.service"
    ];
    wants = [
      "pipewire.service"
      "wireplumber.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "fix-es8316-audio.sh" ''
        # Wait for sound card to be ready
        for i in $(seq 1 30); do
          if ${pkgs.alsa-utils}/bin/amixer -c acp3xes83xx scontrols >/dev/null 2>&1; then
            break
          fi
          ${pkgs.coreutils}/bin/sleep 1
        done

        # Enable DAC routing for both speakers and headphones
        ${pkgs.alsa-utils}/bin/amixer -c acp3xes83xx sset "Left Headphone Mixer Left DAC" on
        ${pkgs.alsa-utils}/bin/amixer -c acp3xes83xx sset "Right Headphone Mixer Right DAC" on

        # Set Headphone Mixer to 100% (internal mixer routing, not user volume)
        # This is required for headphones to work when inserted
        ${pkgs.alsa-utils}/bin/amixer -c acp3xes83xx sset "Headphone Mixer" 11

        # Save the correct ALSA state to prevent it from being overwritten
        # This ensures that Headphone Mixer and Switch remain correct across reboots
        ${pkgs.alsa-utils}/bin/alsactl store
      '';
      RemainAfterExit = true;
    };
  };
}
