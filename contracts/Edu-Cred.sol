// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EduCred {

    // Structure to represent a credential
    struct Credential {
        string institution;
        string degree;
        uint256 completionYear;
    }

    // Struct for providers
    struct AuthorizedProvider {
        address addr;
        string institution;
        bool isAuthorized;
    }

    // List of Authorized Providers
    AuthorizedProvider[] internal authorizedProviders;

    // Mapping from address (user) to their credentials
    mapping(address => Credential[]) internal userCredentials;

    // Event to log credential verification
    event CredentialVerified(address indexed user, address student, string institution, string degree, uint256 completionYear);

    // Function to add and verify a credential
    function assignCredential(string memory _institution, string memory _degree, uint256 _completionYear, address student) public {
        // only need to either have a valid institution
        require(isProviderAuthorized(msg.sender), "Only authorized entity can verify credentials");
        require(_completionYear > 0 || _completionYear < 2030, "Need valid year.");
        require(msg.sender != student, "Can't assign yourself a credential.");

        Credential memory newCredential = Credential({
            institution: _institution,
            degree: _degree,
            completionYear: _completionYear
        });

        userCredentials[student].push(newCredential);

        // Emit an event for credential verification
        emit CredentialVerified(msg.sender, student, _institution, _degree, _completionYear);
    }

    // Function to check if the provider is authorized
    function isProviderAuthorized(address _provider) internal view returns (bool) {
        for (uint256 i = 0; i < authorizedProviders.length; i++) {
            if (authorizedProviders[i].addr == _provider && authorizedProviders[i].isAuthorized) {
                return true;
            }
        }
        return false;
    }

    // Function to get the credentials of a user
    function viewEduCredentials(address _user) public view returns (Credential[] memory) {
        return userCredentials[_user];
    }

    // Function to add a new Authorized Provider
    function addAuthorizedProvider(address _provider, string memory _institution) public {
        require(!isProviderAuthorized(_provider), "Provider is already authorized");
        
        // If this is the first provider, authorize them automatically
        if (authorizedProviders.length == 0) {
            authorizedProviders.push(AuthorizedProvider({
                addr: _provider,
                institution: _institution,
                isAuthorized: true
            }));
        } else {
            uint256 votedYes = 0;

            // Vote yes to authorize another provider
            // This voting would happen elsewhere and be less deterministic
            for (uint256 i = 0; i < authorizedProviders.length; i++) {
                // Count "yes" votes
                if (authorizedProviders[i].isAuthorized) {
                    votedYes++;
                }
            }

            // Need majority vote
            require(votedYes >= authorizedProviders.length / 2, "Not enough votes to authorize the provider");
            
            // Add the new provider
            authorizedProviders.push(AuthorizedProvider({
                addr: _provider,
                institution: _institution,
                isAuthorized: true
            }));
        }
    }
}
