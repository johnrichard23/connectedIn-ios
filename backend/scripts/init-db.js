const AWS = require('aws-sdk');
const fs = require('fs');
const path = require('path');

// Configure AWS SDK
AWS.config.update({
  region: 'ap-southeast-1' // Singapore region
});

const dynamodb = new AWS.DynamoDB.DocumentClient();

async function importMockData() {
  try {
    // Read mock data
    const mockData = JSON.parse(fs.readFileSync(
      path.join(__dirname, '../../ConnectedIn/ConnectedIn/Networking/Services/Mocks/MockChurchResponse.json')
    ));

    console.log('Importing churches...');
    const timestamp = new Date().getTime();

    // Import each church
    for (const church of mockData.churches) {
      const params = {
        TableName: process.env.CHURCHES_TABLE,
        Item: {
          ...church,
          createdAt: timestamp,
          updatedAt: timestamp
        }
      };

      await dynamodb.put(params).promise();
      console.log(`Imported church: ${church.name}`);
    }

    console.log('Data import completed successfully!');
  } catch (error) {
    console.error('Error importing data:', error);
  }
}

// Run the import
importMockData();
