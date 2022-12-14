
from brownie import Lottery, network, config
from scripts.helpful_scripts import get_account


def start():
    account = get_account()
    LotteryDeployment = Lottery[-1]
    
    setLottoStartTx = LotteryDeployment.startLottery(
        {"from": account, "priority_fee": "25 gwei"}
    )
    setLottoStartTx.wait(1)


def main():
    start()