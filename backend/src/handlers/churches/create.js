const AWS = require('aws-sdk');
const { v4: uuidv4 } = require('uuid');
const dynamodb = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event) => {
  try {
    const data = JSON.parse(event.body);
    const timestamp = new Date().getTime();

    const church = {
      id: uuidv4(),
      name: data.name,
      description: data.description,
      avatarUrl: data.avatarUrl,
      shortDescription: data.shortDescription,
      phone: data.phone,
      email: data.email,
      address: data.address,
      countryGroup: data.countryGroup,
      serviceTimes: data.serviceTimes,
      latitude: data.latitude,
      longitude: data.longitude,
      region: data.region,
      socialLinks: data.socialLinks,
      photos: data.photos,
      donations: data.donations,
      createdAt: timestamp,
      updatedAt: timestamp,
    };

    const params = {
      TableName: process.env.CHURCHES_TABLE,
      Item: church,
    };

    await dynamodb.put(params).promise();

    return {
      statusCode: 201,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': true,
      },
      body: JSON.stringify(church),
    };
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: error.statusCode || 500,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': true,
      },
      body: JSON.stringify({
        error: error.message || 'Could not create church.'
      }),
    };
  }
};
