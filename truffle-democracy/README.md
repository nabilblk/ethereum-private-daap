### IDE in teh cloud for solidity
https://ethereum.github.io/browser-solidity/#version=0.3.6

### Let start with s simple Democracy Contract
```
contract Democracy {

    // Owner of the contrat
    address public owner;

    // Constructor
    function Democracy() {
        owner = msg.sender;
    }

}
```

### Now We will add the Voting time Limit

```
contract Democracy {
    // uint is a positive integer
    uint public votingTimeInMinutes ;

    // Propriétaire du contrat
    address public owner;

    // Constructeur
    function Democracy() {
        owner = msg.sender;
        setVotingTime(votingTime);
    }

     // Fonction de modification du temps
    function setVotingTime(uint newVotingTime) {
        // This is a tips to ensure that only the Owner of the contract can execute this method .
        if(msg.sender != owner) throw;
        votingTimeInMinutes = newVotingTime;
    }
}
```

### Let's now do some refactoring

The condition of owning a contract will be reused so we will Refactor it

```
contract Democracy {
    uint public votingTimeInMinutes ;

    // Propriétaire du contrat
    address public owner;

    modifier ownerOnly(){
        if (msg.sender != owner) throw;
        _
    }

    // Constructeur
    function Democracy() {
        owner = msg.sender;
        setVotingTime(votingTime);
    }

     // Function Of updating Voting Limit time
    function setVotingTime(uint newVotingTime) ownerOnly() {
        votingTimeInMinutes = newVotingTime;
    }

}
```

### let's now Add members

The owner of the contract will add new voters :

```
contract Democracy {
    uint public votingTimeInMinutes ;

    // The owner of the contract
    address public owner;

    // The voters (Array of adress / Yes/NO can vote)
    mapping (address => bool) public members;

    // Security Stuff : Auth Owner Only
    modifier ownerOnly(){
        if (msg.sender != owner) throw;
        _
    }

   // Security Stuff : Auth voters Only
   modifier memberOnly(){
        if (!members[msg.sender]) throw;
        _
    }

    // Constructor
    function Democracy() {
        owner = msg.sender;
        setVotingTime(votingTime);
    }

      // Function Of updating Voting Limit time
    function setVotingTime(uint newVotingTime) ownerOnly() {
        votingTimeInMinutes = newVotingTime;
    }

    // Add voters
    function addMember(address newMember) ownerOnly() {
        members[newMember] = true;
    }

}
```

### Now we need to define proposals :

```
contract Democracy {
    uint public votingTimeInMinutes ;

    // The owner of the contract
    address public owner;

    // The voters (Array of adress / Yes/NO can vote)
    mapping (address => bool) public members;

    // A Liste of proposal
    Proposal[] proposals;

    // Structure of a proposal
    struct Proposal {
        string description;
        mapping (address => bool) voted;
        bool[] votes;
        uint end;
        bool adopted;
    }

    // Security Stuff : Auth Owner Only
    modifier ownerOnly(){
        if (msg.sender != owner) throw;
        _
    }

   // Security Stuff : Auth voters Only
   modifier memberOnly(){
        if (!members[msg.sender]) throw;
        _
    }

    // Constructor
    function Democracy() {
        owner = msg.sender;
        setVotingTime(votingTime);
    }

      // Function Of updating Voting Limit time
    function setVotingTime(uint newVotingTime) ownerOnly() {
        votingTimeInMinutes = newVotingTime;
    }

    // Add voters
    function addMember(address newMember) ownerOnly() {
        members[newMember] = true;
    }

    // Add a proposal
    function addProposal(string description) {
        uint proposalID = proposals.length++;

        Proposal p = proposals[proposalID];

        // Populate the description
        p.description = description;

        // fix the end vote time
        // now is the timestamp of the last mined block
        p.end = now + votingTimeInMinutes * 1 minutes;
    }
}
```

### all is ready , let's vote now

```
contract Democracy {
    uint public votingTimeInMinutes ;

    // The owner of the contract
    address public owner;

    // The voters (Array of adress / Yes/NO can vote)
    mapping (address => bool) public members;

    // A Liste of proposal
    Proposal[] proposals;

    // Structure of a proposal
    struct Proposal {
        string description;
        mapping (address => bool) voted;
        bool[] votes;
        uint end;
        bool adopted;
    }

    // Security Stuff : Auth Owner Only
    modifier ownerOnly(){
        if (msg.sender != owner) throw;
        _
    }

   // Security Stuff : Auth voters Only
   modifier memberOnly(){
        if (!members[msg.sender]) throw;
        _
    }

    // Constructor
    function Democracy() {
        owner = msg.sender;
        setVotingTime(votingTime);
    }

      // Function Of updating Voting Limit time
    function setVotingTime(uint newVotingTime) ownerOnly() {
        votingTimeInMinutes = newVotingTime;
    }

    // Add voters
    function addMember(address newMember) ownerOnly() {
        members[newMember] = true;
    }

    // Add a proposal
    function addProposal(string description) {
        uint proposalID = proposals.length++;

        Proposal p = proposals[proposalID];

        // Populate the description
        p.description = description;

        // fix the end vote time
        // now is the timestamp of the last mined block
        p.end = now + votingTimeInMinutes * 1 minutes;
    }

    // Vote on a proposal
    function vote(uint index, bool vote) memberOnly() isOpen(index) didNotVoteYet(index) {
        proposals[index].votes.push(vote);
        proposals[index].voted[msg.sender] = true;
    }

    // Get the result for a vote
    function executeProposal(uint index) isClosed(index) {
        uint yes;
        uint no;
        bool[] votes = proposals[index].votes;

        // On compte les pour et les contre
        for(uint counter = 0; counter < votes.length; counter++) {
            if(votes[counter]) {
                yes++;
            } else {
                no++;
            }
        }
        if(yes > no) {
           proposals[index].adopted = true;
        }
    }

    // Rules : if a proposal of the index is not open , the function will not be executed
    modifier isOpen(uint index) {
       if(now > proposals[index].end) throw;
       _
    }

    // Rule : if a proposal of the index is closed for voting  , the function will not be executed
    modifier isClosed(uint index) {
       if(now < proposals[index].end) throw;
       _
    }

    // if the account msg.sender already vote for this proposal the function will not be executed
    modifier didNotVoteYet(uint index) {
       if(proposals[index].voted[msg.sender]) throw;
       _
    }

}
```


### Now we have our smart contract let's code with Truffle :

truffle init
