from brownie import Lottery, network, config
from scripts.helpful_scripts import get_account


def end():
    account = get_account()
    LotteryDeployment = Lottery[-1]
    
    setLottoEndTx = LotteryDeployment.endLottery(
        {"from": account, "priority_fee": "25 gwei"}
    )
    setLottoEndTx.wait(1)


def main():
    end()