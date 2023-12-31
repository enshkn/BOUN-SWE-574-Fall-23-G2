module.exports = {
  transform: {
    '^.+\\.jsx?$': 'babel-jest', 
  },
  transformIgnorePatterns: [
    'node_modules/(?!(date-fns)/)', 
  ],
 
};
