const { network } = require("hardhat")
const { networkConfig, developmentChains } = require("../helper")

module.exports = async ({ getNamedAccounts, deployments }) => {

    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts() 
    const chainId = network.config.chainId 

    // if chainId is X use address Y 
    const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    const fundme = await deploy("FundMe", {
        from: deployer, 
        args: [], //  price feed addrss 
        log: true, 
    })
}