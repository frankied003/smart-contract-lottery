
from brownie import Lottery, network, config
from scripts.helpful_scripts import get_account


def deploy():
    account = get_account()
    subscriptionId = 7537 # For random number

    # Deploy the lottery contract first
    LotteryContract = Lottery.deploy(
        subscriptionId,
        {"from": account, "priority_fee": "25 gwei"},
        publish_source=config["networks"][network.show_active()].get("verify", True),
    )
    setVaultTx = LotteryContract.setLotteryVault(
        "0x8C2b8CB9D10FCC2feE2fDe9927556904ECc926c1",
        {"from": account, "priority_fee": "25 gwei"}
    )
    setVaultTx.wait(1)
    print("Successfully deployed Lottery contract:", LotteryContract)


def main():
    deploy()