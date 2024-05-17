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
