const AWS = require('aws-sdk');

AWS.config.update({ region: 'ap-southeast-1' });
const cognito = new AWS.CognitoIdentityServiceProvider();

async function createTestUser() {
    const email = 'test@example.com';  // Change this to your email
    const password = 'Test123!';       // Change this to your desired password
    
    try {
        // Create user
        await cognito.signUp({
            ClientId: '1booih12gfkd27qdnm10cduemh',  // Your Client ID
            Username: email,
            Password: password,
            UserAttributes: [
                {
                    Name: 'email',
                    Value: email
                }
            ]
        }).promise();
        
        console.log('✅ User created successfully');
        
        // Auto-confirm the user (in production, users would need to verify their email)
        await cognito.adminConfirmSignUp({
            UserPoolId: process.env.USER_POOL_ID,  // Your User Pool ID
            Username: email
        }).promise();
        
        console.log('✅ User confirmed successfully');
        console.log('\nYou can now log in with:');
        console.log(`Email: ${email}`);
        console.log(`Password: ${password}`);
        
    } catch (error) {
        console.error('❌ Error creating user:', error);
    }
}

createTestUser();
