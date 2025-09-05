FROM openjdk:8-jre

ENV DEBIAN_FRONTEND=noninteractive

# Variables d'environnement
ENV LANG=fr_FR.UTF-8 \
    LANGUAGE=fr_FR:fr \
    LC_ALL=fr_FR.UTF-8 \
    TZ=Europe/Paris \
    PDI_HOME=/opt/pdi

# Installer tzdata, locales et unzip, configurer timezone et locale
RUN apt-get update && \
    apt-get install -y locales tzdata unzip && \
    ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i '/fr_FR.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen fr_FR.UTF-8 && \
    update-locale LANG=fr_FR.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

# Copier PDI 9.4 dans le container
COPY pdi94/ ${PDI_HOME}/
RUN chmod +x ${PDI_HOME}/*.sh

# Définir le répertoire de travail
WORKDIR /app