const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.use(express.json());

// In-memory product storage
let products = [
  { id: 1, name: 'Laptop', price: 1200 },
  { id: 2, name: 'Smartphone', price: 800 },
];

// Health Check
app.get('/health', (req, res) => {
  res.status(200).send({ message: 'API is running fine' });
});

// Get all products
app.get('/products', (req, res) => {
  res.status(200).send({ products });
});

// Add a new product
app.post('/products', (req, res) => {
  const { name, price } = req.body;
  if (!name || !price) {
    return res.status(400).send({ error: 'Name and price are required' });
  }
  const newProduct = { id: products.length + 1, name, price };
  products.push(newProduct);
  res.status(201).send({ message: 'Product added', product: newProduct });
});

app.listen(port, () => {
  console.log(`E-commerce service listening at http://localhost:${port}`);
});
