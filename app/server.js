﻿const express = require('express');
const app = express();
const port = 8080;

// Use middleware to parse JSON data
app.use(express.json());

// Simple Health Check route
app.get('/health', (req, res) => {
  res.status(200).send({ message: 'API is running fine' });
});

// A simple dynamic API that could be expanded as a service
app.post('/process', (req, res) => {
  const { data } = req.body;
  if (!data) {
    return res.status(400).send({ error: 'Data is required' });
  }
  // Example: Process data and return some response
  const processedData = data.toUpperCase(); // simple example of "processing"
  res.status(200).send({ processedData });
});

// Catch-all route for any other requests
app.all('*', (req, res) => {
  res.status(404).send({ error: 'Not Found' });
});

app.listen(port, () => {
  console.log(`Backend API listening at http://localhost:${port}`);
});
