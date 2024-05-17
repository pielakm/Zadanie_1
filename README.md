Link do DockerHub: https://hub.docker.com/repository/docker/mateuszpielak/zadanka/general

1. Zbudowanie projektu node.js:
   npm init
![image](https://github.com/pielakm/Zadanie_1/assets/102603389/7a96d13e-63fb-48b3-b084-d6ddb923efc7)
2. Zbudowanie obrazu Dockerfile na platformie linux(zbudowane na builderze lab7builder z poprzednich labolatoriów, wykorzystuje sterownik docker-container)
   docker buildx build -f Dockerfile --platform linux/arm64,linux/amd64 -t mateuszpielak/zadanka:zad_1 --cache-to=type=registry,ref=mateuszpielak/zadanka:cache,mode=max --cache-from=type=registry,ref=mateuszpielak/zadanka:cache --push .
![image](https://github.com/pielakm/Zadanie_1/assets/102603389/1ec82e8c-3697-467b-898e-aaea6776ddb3)
![image](https://github.com/pielakm/Zadanie_1/assets/102603389/3656855b-09ae-4efa-8476-83f82f53f58f)
4. Uruchomienie obrazu:
   docker run -p 3000:3000 docker.io/mateuszpielak/zadanka:zad_1  
   ![image](https://github.com/pielakm/Zadanie_1/assets/102603389/f84d9ad3-05fd-4973-a7ea-46485ae5f835)
4.Analiza CVE:
 docker scout recommendations mateuszpielak/zadanka:zad_1   
![image](https://github.com/pielakm/Zadanie_1/assets/102603389/3d8ac58f-cc5c-4da0-8021-241c1b76e642)
![image](https://github.com/pielakm/Zadanie_1/assets/102603389/c6bdd461-138e-4186-92a8-adf55e5ea815)
docker scout cves  mateuszpielak/zadanka:zad_1
![image](https://github.com/pielakm/Zadanie_1/assets/102603389/573479ef-c6aa-4ddf-a4f1-9be493ad1baf)



PS: przepraszam za "niewyraźne" screenshoty, podczas robienia tego sprawozdania poznałem czym skutkuje polecenie git push --force origin main i niezapisanie poprzedniego readMe..
![image](https://github.com/pielakm/Zadanie_1/assets/102603389/ccc004a0-e581-4571-bc8a-d64032de0e5b)

Plik Dockerfile:

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
    
    
    Plik index.js:
const http = require('http');
const os = require('node:os');
const url = require('node:url');

// Funkcja do obsługi żądań HTTP
const server = http.createServer((req, res) => {
    // Pobranie adresu IP klienta
    const clientIP = req.socket.remoteAddress;
    // Pobranie daty i czasu w strefie czasowej klienta
    const date = new Date();
    const clientTime = date.toLocaleString('pl-PL', { timeZone: 'Europe/Warsaw' });

    // Logowanie informacji o uruchomieniu serwera
    const author = "Mateusz Pielak"; 
    const port = server.address().port;
    console.log(`Serwer uruchomiony przez: ${author}`);
    console.log(`Data uruchomienia: ${date}`);
    console.log(`Serwer nasłuchuje na porcie: ${port}`);

    // Tworzenie treści strony
    const pageContent = `
        <html>
            <head>
                <title>Informacje o kliencie</title>
            </head>
            <body>
                <h1>Adres IP klienta: ${clientIP}</h1>
                <p>Data i czas w strefie czasowej klienta: ${clientTime}</p>
                <p>Dane o autorze: ${author}</p>
            </body>
        </html>
    `;

    // Wysłanie odpowiedzi do klienta
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.write(pageContent);
    res.end();
});

// Uruchomienie serwera na porcie 3000
server.listen(3000, () => {
    console.log('Serwer uruchomiony na porcie 3000...');
});








