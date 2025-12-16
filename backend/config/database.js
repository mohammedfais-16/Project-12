const mongoose = require('mongoose');

const connectDB = async () => {
  const mongoURI =
    process.env.MONGO_URL || 'mongodb://mongo:27017/movieticket';

  const options = {
    maxPoolSize: 10,
    serverSelectionTimeoutMS: 5000,
    socketTimeoutMS: 45000,
  };

  try {
    await mongoose.connect(mongoURI, options);
    console.log('✅ MongoDB connected');

    mongoose.connection.on('error', (err) => {
      console.error('MongoDB error:', err);
    });

    mongoose.connection.on('disconnected', () => {
      console.log('MongoDB disconnected');
    });

  } catch (error) {
    console.error('❌ MongoDB connection failed:', error.message);
    process.exit(1);
  }
};

module.exports = connectDB;
