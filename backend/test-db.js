const { Client } = require('pg');

const client = new Client({
    user: 'admin',
    password: 'password123!',
    host: 'localhost',
    port: 5433,
    database: 'beast_heart',
});

client.connect()
    .then(() => {
        console.log('Connected successfully');
        return client.end();
    })
    .catch(err => {
        console.error('Connection error', err.stack);
        client.end();
    });
