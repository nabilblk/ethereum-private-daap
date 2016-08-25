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
    function Democracy(uint votingTime) {
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