"strict mode"
var web3 = new Web3('ws://localhost:7545');

const contract_abi = [
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "_daysActive",
                "type": "uint256"
            }
        ],
        "stateMutability": "nonpayable",
        "type": "constructor"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "name": "Scores",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "name": "Submissions",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "_answer",
                "type": "uint256"
            }
        ],
        "name": "bet",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "name": "competitors",
        "outputs": [
            {
                "internalType": "address",
                "name": "",
                "type": "address"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "expire",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "expired",
        "outputs": [
            {
                "internalType": "bool",
                "name": "",
                "type": "bool"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "getWinner",
        "outputs": [
            {
                "internalType": "address",
                "name": "",
                "type": "address"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "_sender",
                "type": "address"
            }
        ],
        "name": "init_competitor",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "_sender",
                "type": "address"
            }
        ],
        "name": "is_competitor",
        "outputs": [
            {
                "internalType": "int256",
                "name": "",
                "type": "int256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "n_competitors",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "_limit_base",
                "type": "uint256"
            }
        ],
        "name": "random_gas_use",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    }
];
const contract_address ='0x78Ff4b8738FF6AFAe8cBf4c5DCcB7C921041C443';
let accounts = web3.eth.getAccounts();
let contract;

async function getDetails() {
    contract = new web3.eth.Contract(contract_abi, contract_address);
    let n = await contract.methods.n_competitors().call();
    let competitors = [];
    let scores = [];
    let submissions = [];
    for (i = 0; i < n; i++) {
        competitors.push(await contract.methods.competitors(i).call());
        scores.push(await contract.methods.Scores(i).call());
        submissions.push(await contract.methods.Submissions(i).call());
    }
    return competitors.map((competitor, index) => {
        return {
            'address': competitor,
            'score': parseInt(scores[index], 16),
            'submissions': parseInt(submissions[index])
        };
    });
}

async function fillDetails() {
    data = await getDetails();

    var table = document.getElementById("table");
    // console.log('data', data)
    data.forEach((row, index) => {
        var tableRow = table.insertRow(index+1);
        tableRow.insertCell(0).innerHTML = row.address;
        tableRow.insertCell(1).innerHTML = row.score;
        tableRow.insertCell(2).innerHTML = row.submissions;
        tableRow.insertCell(3).innerHTML = `<button onclick='bet(` + JSON.stringify(row).competitor + `)'>bet</button>`;
    });
}

async function expire() {
    contract = new web3.eth.Contract(contract_abi, contract_address);
    await contract.methods.expire().send({from: "0x8b93Feb02a63D41a71C2e231b240b34eE39b076B"});
}

async function hasExpired() {
    let has = false;
    res = await contract.methods.expired().call();
    return res;
}

async function getWinner() {
    let winner = '0x0';
    var data = await getDetails();
    var scores = data.map(competitor => competitor.score);
    var maxScore = Math.max(...scores);
    winner = data.find(competitor => competitor.score == maxScore);
    alert('Winners address: ' + winner.address + "\nWinners score: " + winner.score + "\nWinners submissions: "+ winner.submissions);
}

function bet(competitor) {
    contract = new web3.eth.Contract(contract_abi, contract_address);
    var _bet = prompt('enter number');
    contract.methods.bet(_bet).send({from: competitor, gas: 1000000}).then(() => {
        location.reload();
        return false;
    })
}

function newBet() {
    if (!hasExpired()) {
        var competitor = document.getElementById("competitor").value;
        bet(competitor);
    } else
        alert("Competition is over");
}

// web3.eth.defaultAccount = accounts[7];
// console.log(bet(contract, 500));
