const AWS = require('aws-sdk');
const fs = require('fs');
const path = require('path');

AWS.config.update({ region: 'ap-southeast-1' });
const dynamodb = new AWS.DynamoDB.DocumentClient();

async function importData() {
    try {
        // Read mock data
        const mockDataPath = path.join(__dirname, '../../ConnectedIn/ConnectedIn/Networking/Services/Mocks/MockChurchResponse.json');
        const mockData = JSON.parse(fs.readFileSync(mockDataPath, 'utf8'));
        
        console.log('Starting data import...');
        
        // Import churches
        for (const church of mockData.churches) {
            const params = {
                TableName: 'connectedin-api-dev-churches',
                Item: {
                    ...church,
                    createdAt: Date.now(),
                    updatedAt: Date.now()
                }
            };
            
            await dynamodb.put(params).promise();
            console.log(`✅ Imported church: ${church.name}`);
        }
        
        console.log('✅ Data import completed successfully!');
    } catch (error) {
        console.error('❌ Error importing data:', error);
    }
}

importData();
