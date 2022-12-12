from scripts.helpful_scripts import get_account
from brownie import Lottery, network, config


def deploy():
    account = get_account()
    subscriptionId = 7537 # For random number

    # Deploy the lottery contract first
    LotteryContract = Lottery.deploy(
        subscriptionId,
        {"from": account, "priority_fee": "25 gwei"},
        publish_source=config["networks"][network.show_active()].get("verify", True),
    )
    print("Successfully deployed Lottery contract:", LotteryContract)


def main():
    deploy()