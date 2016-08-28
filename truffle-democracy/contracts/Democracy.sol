contract Democracy {
    // The voting time Limit
    uint public votingTimeInMinutes;
    // The Owner of the smart contract and the leader of the voting operation
    // He can add members and give the right to vote
    address public owner;

    // The member ho have the right to vote : Array of Adress/Bool(Yes/No Can vote)
    mapping (address => bool) public members;

    // The proposals
    Proposal[] public proposals;

    // A complex type to define the proposal structure
    struct Proposal {
        string description;
        mapping (address => bool) voted;
        bool[] votes;
        uint end;
        bool adopted;
    }

    // Proposal Rule : if the proposal to that index is not open to voting then the function is not executed
    modifier isOpen(uint index) {
        if(now > proposals[index].end) throw;
        _
    }

    // Proposal Rule : The inverse
    modifier isClosed(uint index) {
        if(now < proposals[index].end) throw;
        _
    }

    // Voting rule : If the Account msg.sender already vote for this proposal , the function is not executed
    modifier didNotVoteYet(uint index) {
        if(proposals[index].voted[msg.sender]) throw;
        _
    }

    // Security Rule : On the owner can execute the function
    modifier ownerOnly() {
        if(msg.sender != owner) throw;
        _
    }

    // Security Rule : On a member can execute the function
    modifier memberOnly() {
        if(!members[msg.sender]) throw;
        _
    }

    // Return the number of proposal
    function nbProposals() constant returns(uint nbProposals) {
        nbProposals = proposals.length;
    }
    // Constructor of the contract
    function Democracy(uint votingTime) {
        owner = msg.sender;
        setVotingTime(votingTime);
    }

    // "Setter" VotingTime
    function setVotingTime(uint newVotingTime) ownerOnly() {
        votingTimeInMinutes = newVotingTime;
    }

    // Add members
    function addMember(address newMember) ownerOnly() {
        members[newMember] = true;
    }

    // Add proposal
    function addProposal(string description) memberOnly() {
        uint proposalID = proposals.length++;
        Proposal p = proposals[proposalID];
        p.description = description;
        p.end = now + votingTimeInMinutes * 1 minutes;
        // p.adopted = false, p.votes = [], etc...
    }

    // Vote for a proposal
    function vote(uint index, bool vote) memberOnly() isOpen(index) didNotVoteYet(index) {
        // push the vote to the list of vote
        proposals[index].votes.push(vote);
        // Add the voters to the mapping of the voters
        proposals[index].voted[msg.sender] = true;
    }

    function executeProposal(uint index) isClosed(index) {
        uint aye;
        uint no;
        bool[] votes = proposals[index].votes;
        // Count Yes and No
        for(uint counter = 0; counter < votes.length; counter++) {
            if(votes[counter]) {
                aye++;
            } else {
                no++;
            }
        }
        if(aye > no) {
           proposals[index].adopted = true;
        }
    }
}
