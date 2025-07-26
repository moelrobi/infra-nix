{pkgs, ...}: {
  users.users.rob = {
    isNormalUser = true;
    description = "Robin Möller";
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBvs6MW/nMv4rz7k9EGFmU9UABylCrQkZrai8DDV2MCqPKI0dl5seCgdGok8eJqm2tETJ4yt3EDRCBYioxnCg4PmApzXbZbQuVqEhshuxZuamdPw9HHdSDTL4MYlNWEdbGxbj5UyO+z9T8T+OowaC8RK78tBJWUI227HRRmDi6GxU5yckHyy/Jojlp6xDTe5bXPWXK43MmTUbqyUXYFdqRW/6DhSapGIL0eJaGI+jLoNICA0ooIZmnTanDL8xebcq6/jPmKfk0wGCVGOiHEhtnRYdxJBmT1jAIBGkB1uE99JGJyy2fvgUFKmtMzp5MPHf3MlIF+mHrgteVab59nK9h1X6dxn9BGLH8w2qiZZBCBDhlaj+lQjeEuHkvml6N2jAADhafFovpo+K8pWIVAZRA9jOvxz91VpMYnXW/lYwNiRjEuE4kvfCRG7JkrfMdEJbeuyCVokj1NDB443c+qLOVkTf5TbR4l3/O4j9GZ2Y5VnW/cdtUV9Zo88IPjdRApSE= Macbook"
    ];
  };
}
