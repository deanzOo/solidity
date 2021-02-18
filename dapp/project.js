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
const contract_address ='0x25fcdAc610153D72983C3396d0B6A99D13dFb09F';
let accounts = web3.eth.getAccounts();
let contract = new web3.eth.Contract(contract_abi, contract_address);

async function fillDetails(contract) {
    let n = await contract.methods.n_competitors().call();
    let competitors = [];
    let scores = [];
    let submissions = [];
    for (i = 0; i < n; i++) {
        competitors.push(await contract.methods.competitors(i).call());
        scores.push(await contract.methods.Scores(i).call());
        submissions.push(await contract.methods.Submissions(i).call());
    }
    return {
        'competitors': competitors,
        'scores': scores.map(function(score) {return parseInt(score);}),
        'submissions': submissions.map(function(submission) {return parseInt(submission);})
    }
}

async function expire(contract) {
    await contract.methods.expire().call();
}

async function hasExpired(contract) {
    let has = false;
    res = await contract.methods.expired().call();
    return res;
}

async function getWinner(contract) {
    let winner = '0x0';
    winner = await contract.methods.getWinner().call();
    return winner;
}

async function bet(contract, _bet) {
    await contract.methods.bet(_bet).call().then(function (instance) {console.log(instance);});
}

web3.eth.defaultAccount = accounts[7];
console.log(bet(contract, 500));
fillDetails(contract).then(function (value) {console.log(value);});
