#!/bin/bash

CYAN='\033[1;36m'
NC='\033[0m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

# Menü başlığı ve separator
clear
echo -e "${BOLD}${CYAN}========================================="
echo -e "            ${BOLD}H O S T G E B${NC}             "
echo -e "        ${BOLD}hostgeb.com${NC}        "
echo -e "${CYAN}=========================================${NC}"
echo

echo -e "${BOLD}${YELLOW}1.${NC} Plesk Kurulumu             ${BOLD}${YELLOW}2.${NC} cPanel Kurulumu           ${BOLD}${YELLOW}3.${NC} DirectAdmin Kurulumu"
echo -e "${BOLD}${YELLOW}4.${NC} CSF Algılama Modu Aç      ${BOLD}${YELLOW}5.${NC} CSF Algılama Modu Kapat   ${BOLD}${YELLOW}6.${NC} CSF Kurulum ve Ayarlar"
echo -e "${BOLD}${YELLOW}7.${NC} Litespeed Ayarlar         ${BOLD}${YELLOW}8.${NC} SSH Ayarlar               ${BOLD}${YELLOW}9.${NC} Swap Performans Kernel"
echo -e "${BOLD}${YELLOW}10.${NC} CSF Katı DDoS Ayarları    ${BOLD}${YELLOW}11.${NC} Gerçek Disk Kullanımı     ${BOLD}${YELLOW}12.${NC} Boş RAM Durumu"
echo -e "${BOLD}${YELLOW}13.${NC} Apache Yeniden Başlat     ${BOLD}${YELLOW}14.${NC} Önbellek Temizleme        ${BOLD}${YELLOW}15.${NC} Let's Encrypt SSL Kurulumu"
echo -e "${BOLD}${YELLOW}16.${NC} MySQL/MariaDB Yedeği Alma ${BOLD}${YELLOW}17.${NC} Nginx Yeniden Başlat      ${BOLD}${YELLOW}18.${NC} Kernel Güncelleme"
echo -e "${BOLD}${YELLOW}19.${NC} Postfix ve Dovecot Ayarları ${BOLD}${YELLOW}20.${NC} Otomatik Yedekleme Planlama ${BOLD}${RED}0.${NC} Çıkış"
echo

echo -n "Seçiminizi girin: "
read secim

case $secim in
  1)
    echo -e "${CYAN}Plesk Kurulumu Başlatılıyor...${NC}"
    curl -fsSL https://installer.plesk.com/one-click-installer | sh
    ;;
  2)
    echo -e "${CYAN}cPanel Kurulumu Başlatılıyor...${NC}"
    cd /home && curl -o latest -L https://securedownloads.cpanel.net/latest && sh latest
    ;;
  3)
    echo -e "${CYAN}DirectAdmin Kurulumu Başlatılıyor...${NC}"
    wget -O setup.sh https://www.directadmin.com/setup.sh && chmod +x setup.sh && ./setup.sh auto
    ;;
  4)
    echo -e "${CYAN}CSF Algılama Modu Açılıyor...${NC}"
    csf -e
    ;;
  5)
    echo -e "${CYAN}CSF Algılama Modu Kapatılıyor...${NC}"
    csf -x
    ;;
  6)
    echo -e "${CYAN}CSF Kurulumu ve Ayarları Yapılıyor...${NC}"
    yum install -y perl-libwww-perl.noarch perl-LWP-Protocol-https.noarch
    cd /usr/src && wget https://download.configserver.com/csf.tgz
    tar -xzf csf.tgz && cd csf && sh install.sh
    ;;
  7)
    echo -e "${CYAN}Litespeed Ayarları Yapılıyor...${NC}"
    echo "(Buraya Litespeed ayarları eklenebilir)"
    ;;
  8)
    echo -e "${CYAN}SSH Ayarları Yapılıyor...${NC}"
    echo "(Buraya SSH ayarları eklenebilir)"
    ;;
  9)
    echo -e "${CYAN}Swap Performans Kernel Ayarları Yapılıyor...${NC}"
    echo "(Buraya Swap ayarları eklenebilir)"
    ;;
  10)
    echo -e "${CYAN}CSF Katı DDoS Ayarları Yapılıyor...${NC}"
    echo "(Buraya CSF DDoS ayarları eklenebilir)"
    ;;
  11)
    echo -e "${CYAN}Gerçek Disk Kullanımı:${NC}"
    df -h
    ;;
  12)
    echo -e "${CYAN}Boş RAM Durumu:${NC}"
    free -h
    ;;
  13)
    echo -e "${CYAN}Apache Yeniden Başlatılıyor...${NC}"
    systemctl restart httpd
    ;;
  14)
    echo -e "${CYAN}Önbellek Temizleniyor...${NC}"
    sync; echo 3 > /proc/sys/vm/drop_caches
    ;;
  15)
    echo -e "${CYAN}Let's Encrypt Kurulumu Başlatılıyor...${NC}"
    yum install -y certbot && certbot certonly --standalone
    ;;
  16)
    echo -e "${CYAN}MySQL Yedeği Alınıyor...${NC}"
    read -p "Veritabanı adını girin: " dbname
    mysqldump -u root -p $dbname > ${dbname}_backup.sql
    ;;
  17)
    echo -e "${CYAN}Nginx Yeniden Başlatılıyor...${NC}"
    systemctl restart nginx
    ;;
  18)
    echo -e "${CYAN}Kernel Güncellemesi Başlatılıyor...${NC}"
    yum update -y kernel
    ;;
  19)
    echo -e "${CYAN}Postfix ve Dovecot Ayarları Yapılıyor...${NC}"
    echo "(Buraya e-posta ayarları eklenebilir)"
    ;;
  20)
    echo -e "${CYAN}Otomatik Yedekleme Planlanıyor...${NC}"
    crontab -l > mycron
    echo "0 2 * * * /usr/bin/mysqldump -u root -p[şifre] [veritabani_adi] > /var/backups/db_$(date +\%F).sql" >> mycron
    crontab mycron && rm mycron
    ;;
  0)
    echo -e "${RED}Çıkış Yapılıyor...${NC}"
    exit
    ;;
  *)
    echo -e "${RED}Geçersiz Seçim!${NC}"
    ;;
esac
