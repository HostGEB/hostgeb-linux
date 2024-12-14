#!/bin/bash

CYAN='\033[1;36m'
NC='\033[0m'

# Menü başlığı ve seçenekler
echo -e "${CYAN}========== HostGeb - Linux Yönetim Scripti ==========${NC}"
echo "1. Plesk Kurulumu"
echo "2. cPanel Kurulumu"
echo "3. DirectAdmin Kurulumu"
echo "4. CSF Algılama Modu Aç"
echo "5. CSF Algılama Modu Kapat"
echo "6. CSF Kurulum ve Ayarlar"
echo "7. Litespeed Ayarlar"
echo "8. SSH Ayarlar"
echo "9. Swap Performans Kernel"
echo "10. CSF Katı DDoS Ayarları"
echo "11. Gerçek Disk Kullanımını Gör"
echo "12. Boş RAM Durumunu Gör"
echo "13. Apache Yeniden Başlat"
echo "14. Önbellek Temizleme"
echo "15. Let's Encrypt SSL Kurulumu"
echo "16. MySQL/MariaDB Yedeği Alma"
echo "17. Nginx Yeniden Başlat"
echo "18. Kernel Güncelleme"
echo "19. Postfix ve Dovecot Ayarları"
echo "20. Otomatik Yedekleme Planlama"
echo "0. Çıkış"
echo -n "Seçiminizi girin: "

read secim

case $secim in
  1)
    echo -e "${CYAN}Plesk Kurulumu Başlatılıyor...${NC}"
    # Plesk otomatik kurulum scripti
    curl -fsSL https://installer.plesk.com/one-click-installer | sh
    ;;
  2)
    echo -e "${CYAN}cPanel Kurulumu Başlatılıyor...${NC}"
    # cPanel otomatik kurulum scripti
    cd /home && curl -o latest -L https://securedownloads.cpanel.net/latest && sh latest
    ;;
  3)
    echo -e "${CYAN}DirectAdmin Kurulumu Başlatılıyor...${NC}"
    # DirectAdmin otomatik kurulum scripti
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
    echo "0 2 * * * /usr/bin/mysqldump -u root -p[şifre] [veritabani_adi] > /var/backups/db_$(date +\\%F).sql" >> mycron
    crontab mycron && rm mycron
    ;;
  0)
    echo -e "${CYAN}Çıkış Yapılıyor...${NC}"
    exit
    ;;
  *)
    echo -e "${CYAN}Geçersiz Seçim!${NC}"
    ;;
esac
