use starknet::ContractAddress;
use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_address,
    stop_cheat_caller_address,
};
use starknet_test::Counter::{
    ICounterDispatcher, ICounterDispatcherTrait, ICounterSafeDispatcher,
    ICounterSafeDispatcherTrait,
};

fn OWNER() -> ContractAddress {
    'OWNER'.try_into().unwrap()
}

fn deploy_counter(initial_count: u32) -> (ICounterDispatcher, ICounterSafeDispatcher) {
    let contract = declare("Counter").unwrap().contract_class();

    let mut calldata = array![];
    initial_count.serialize(ref calldata);
    OWNER().serialize(ref calldata);

    let (contract_address, _) = contract.deploy(@calldata).unwrap();

    let dispatcher = ICounterDispatcher { contract_address };
    let safe_dispatcher = ICounterSafeDispatcher { contract_address };
    (dispatcher, safe_dispatcher)
}

#[test]
fn test_deploy_contract() {
    let initial_count = 0;
    let (counter, _) = deploy_counter(initial_count);

    let current_counter = counter.get_counter();
    assert!(current_counter == initial_count, "Counter should be equal to initial count");
}

#[test]
fn test_increase_counter() {
    let initial_count = 0;
    let (counter, _) = deploy_counter(initial_count);

    counter.increase_counter();

    let expected_count = initial_count + 1;
    let current_count = counter.get_counter();

    assert!(current_count == expected_count, "Counter should be increased by 1");
}

#[test]
fn test_decrease_counter() {
    let initial_count = 1;
    let (counter, _) = deploy_counter(initial_count);

    counter.decrease_counter();

    let expected_count = initial_count - 1;
    let current_count = counter.get_counter();
    assert!(current_count == expected_count, "Counter should be decreased by 1");
}

#[test]
#[feature("safe_dispatcher")]
fn test_decrease_counter_underflow() {
    let initial_count = 0;
    let (_, safe_counter) = deploy_counter(initial_count);

    match safe_counter.decrease_counter() {
        Result::Ok(_) => panic!("Decrese below 0 did not panic"),
        Result::Err(panic_data) => {
            assert!(
                *panic_data[0] == 'Counter cannot be negative',
                "Panic message should be 'Counter cannot be negative'",
            );
        },
    }
}

// #[test]
// #[should_panic] //<-this causes error: Plugin diagnostic: Attribute should only appear on tests.
// fn test_increase_overflow() {
//     let initial_count = 0xFFFFFFFF;
//     let (counter, _)= deploy_counter(initial_count);
//     counter.increase_counter();
// }

#[test]
#[feature("safe_dispatcher")]
fn test_increase_overflow() {
    let initial_count = 0xFFFFFFFF;
    let (_, safe_counter) = deploy_counter(initial_count);

    match safe_counter.increase_counter() {
        Result::Ok(_) => panic!("Overflow error did not occur as expected"),
        Result::Err(_) => () // Expected panic, test passes
    }
}

#[test]
fn test_set_counter() {
    let initial_count = 1;
    let set_count = 10;
    let (counter, _) = deploy_counter(initial_count);

    counter.set_counter(set_count);

    let current_count = counter.get_counter();
    assert!(current_count == set_count, "Counter should be equal to set count");
}

#[test]
#[feature("safe_dispatcher")]
fn test_reset_counter_not_owner() {
    let initial_count = 10;
    let (counter, safe_counter) = deploy_counter(initial_count);

    match safe_counter.reset_counter() {
        Result::Ok(_) => panic!("Non owner cannot reset the counter!"),
        Result::Err(panic_data) => {
            assert!(
                *panic_data[0] == 'Caller is not the owner',
                "Should error if caller is not the owner",
            );
            // assert(*panic_data[0] == '', *panic_data[0]); //check the error message
        },
    }

    let current_count = counter.get_counter();
    assert!(current_count == initial_count, "Counter should not be reset");
}

#[test]
fn test_reset_counter_by_owner() {
    let initial_count = 10;
    let (counter, _) = deploy_counter(initial_count);

    start_cheat_caller_address(counter.contract_address, OWNER());
    counter.reset_counter();
    stop_cheat_caller_address(counter.contract_address);

    let current_count = counter.get_counter();
    assert!(current_count == 0, "Counter should be reset to 0");
}

