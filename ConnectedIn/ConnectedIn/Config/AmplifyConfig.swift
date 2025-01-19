import Amplify
import AWSCognitoAuthPlugin

struct AmplifyConfig {
    static func configure() throws {
        let configuration = """
        {
            "auth": {
                "plugins": {
                    "awsCognitoAuthPlugin": {
                        "UserAgent": "aws-amplify/cli",
                        "Version": "0.1.0",
                        "IdentityManager": {
                            "Default": {}
                        },
                        "CredentialsProvider": {
                            "CognitoIdentity": {
                                "Default": {
                                    "PoolId": "\(AWSConfig.userPoolId)",
                                    "Region": "\(AWSConfig.region)"
                                }
                            }
                        },
                        "CognitoUserPool": {
                            "Default": {
                                "PoolId": "\(AWSConfig.userPoolId)",
                                "AppClientId": "\(AWSConfig.userPoolClientId)",
                                "Region": "\(AWSConfig.region)"
                            }
                        },
                        "Auth": {
                            "Default": {
                                "authenticationFlowType": "USER_SRP_AUTH"
                            }
                        }
                    }
                }
            }
        }
        """
        
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            let data = configuration.data(using: .utf8)!
            let jsonDecoder = JSONDecoder()
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let configDict = jsonObject as! [String: Any]
            let config = try AmplifyConfiguration(rawConfiguration: configDict)
            try Amplify.configure(config)
            print("✅ Amplify configured successfully")
        } catch {
            print("❌ Failed to configure Amplify:", error)
            throw error
        }
    }
}
