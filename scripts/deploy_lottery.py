from scripts.helpful_scripts import get_account, get_contract, fund_with_link
from brownie import Lottery, network, config
import time



def deploy_lottery():
    account = get_account()
    lottery = Lottery.deploy(
        get_contract("eth_usd_price_feed").address,
        get_contract("vrf_coordinator").address,
        get_contract("link_token").address,
        config["networks"][network.show_active()]["fee"],
        config["networks"][network.show_active()]["keyhash"],
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify", False)
    )
    print("Lottery deployed!")
    return lottery

def start_lottery():
    account = get_account()
    lottery = Lottery[-1]
    lottery.startLottery({"from": account})
    print("Lottery has started!")

def enter_lottery():
    account = get_account()
    lottery = Lottery[-1]
    value = lottery.getEntranceFee() + 100000000
    lottery.enter({"from":account, "value": value})
    print("You entered the lottery")

def end_lottery():
    account = get_account()
    lottery = Lottery[-1]
    # fund the contract
    # then end the lottery
    fund_with_link(lottery.address)
    lottery.endLottery({"from": account})
    time.sleep(60)
    print(f"{lottery.recentWinner()} is the new winner!")


def main():
    deploy_lottery()
    start_lottery()
    enter_lottery()
    end_lottery()
    time.sleep(1)
    
