var accounts;
var accountID = 0

function displayAccounts() {
    var dem = Democracy.deployed()

    Promise.map(accounts,
        function(index) {
            return dem.members(index)
        }).then(function(results) {
        document.getElementById("addresses").innerHTML =
            accounts
                .map((x, i) => ('<button onclick="setChangeAccount(' + i + ')">' + i + '</button>' + ' : ' + x + ' is member : ' + results[i]) + (i == accountID ? '     <------ you are this guy' : ''))
        .join('<br>')
    })
};

function setChangeAccount(newAccount) {
    accountID = newAccount;
    account = accounts[accountID];
    displayAccounts();
}

window.onload = function() {
    web3.eth.getAccounts(function(err, accs) {
        if (err != null) {
            alert("There was an error fetching your accounts.");
            return;
        }

        if (accs.length == 0) {
            alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
            return;
        }

        accounts = accs;
        account = accounts[accountID];

        displayAccounts();

        //refreshProposals();
    });
}

function newVotingTime(){
    // on récupère le temps inscrit dans l'input
    var newVotingTime = document.getElementById("newVotingTimeField").value;
    // on récupère notre contrat déployé
    var dem = Democracy.deployed();

    dem.setVotingTime(newVotingTime, {from: account}).then( function(res){
        console.log('Done!');
        console.log('res :', res);
    })
    console.log("Transaction sent");
}

function newMember(){
    var dem = Democracy.deployed();
    var newMember = document.getElementById("newMemberField").value;

    dem.addMember(newMember, {from: account}).then(function(res){
        console.log('Done!');
        console.log('res :', res);
    })
    console.log("Transaction sent");
}

function refreshProposals() {
    var dem = Democracy.deployed();

    dem.nbProposals().then(function(nbProposals) {
        var array = _.range(nbProposals)
        Promise.map(array,
            function(index) {
                return dem.proposals(index)
            }).then(function(results) {
            document.getElementById("proposals").innerHTML =
                results
                    .map((x,i) => (i + ":" + x))
            .join('<br>');
            console.log('refreshProposals Done!');
        })
    })
};