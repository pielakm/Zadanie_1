
# --------- ETAP 1 ------------------------
    FROM scratch as builder

    ADD alpine-minirootfs-3.19.1-aarch64.tar /
        
    RUN apk update && \
        apk upgrade && \
        apk add --no-cache nodejs=20.12.1-r0 \
        npm=10.2.5-r0 && \
        rm -rf /etc/apk/cache
        
    RUN addgroup -S node && \
        adduser -S node -G node
        
    USER node
        
    WORKDIR /home/node/app
        
    COPY --chown=node:node server.js ./server.js
    COPY --chown=node:node package.json ./package.json
    COPY --chown=node:node docker-entrypoint.sh /usr/src/app/
    RUN chmod +x /usr/src/app/docker-entrypoint.sh  
    ENTRYPOINT ["sh", "/usr/src/app/docker-entrypoint.sh"]
        
    RUN npm install
        
    # --------- ETAP 2 ------------------------
        
    FROM node:alpine
        
    # Ustawienie katalogu roboczego w kontenerze
    WORKDIR /usr/app
        
    # Skopiowanie plików aplikacji do kontenera
    COPY package.json package-lock.json /usr/app/
        
    # Skopiowanie reszty plików aplikacji
    COPY ./ /usr/app
        
    # Zainstalowanie zależności aplikacji
    RUN npm install
        
    # Odsłuch na porcie 3000
    EXPOSE 3000
        
    # Uruchomienie serwera
    CMD ["npm", "start"]
        
    # Metadane o autorze Dockerfile
    LABEL author="Mateusz Pielak"
    
    
    