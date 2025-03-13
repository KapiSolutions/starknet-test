#[starknet::interface]
pub trait ICounter<T>{
    fn get_counter(self: @T) -> u32;
    fn increase_counter(ref self: T); 
    fn decrease_counter(ref self: T);
    fn set_counter(ref self: T, value: u32);
    fn reset_counter(ref self: T);
}

#[starknet::contract] 
pub mod Counter {
    use super::ICounter;
    use OwnableComponent::InternalTrait;
    use starknet::event::EventEmitter;
    use starknet::storage::{StoragePointerWriteAccess, StoragePointerReadAccess};
    use starknet::ContractAddress;
    use openzeppelin_access::ownable::OwnableComponent;

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        counter: u32,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage
    }

    pub mod Errors {
        pub const NEGATIVE_COUNTER: felt252 = 'Counter cannot be negative';
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_value: u32, initial_owner: ContractAddress) {
        self.counter.write(initial_value);
        self.ownable.initializer(initial_owner);
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event { 
        CounterResetted: CounterResetted,
        OwnableEvent: OwnableComponent::Event
    }

    #[derive(Drop, starknet::Event)]
    pub struct CounterResetted {
        pub value: u32,
    }

    #[abi(embed_v0)] 
    impl CounterImpl of ICounter<ContractState>{
        fn get_counter(self: @ContractState) -> u32 { 
            self.counter.read()
        }
        
        fn increase_counter(ref self: ContractState) {
            self.counter.write(self.get_counter() + 1 );
        }

        fn decrease_counter(ref self: ContractState) {
            let current_value = self.get_counter();
            
            assert(current_value > 0, Errors::NEGATIVE_COUNTER);
            
            let new_value = current_value - 1;
            self.counter.write(new_value);
        }

        fn set_counter(ref self: ContractState, value: u32) {
            assert(value >= 0, Errors::NEGATIVE_COUNTER);
            self.counter.write(value);
        }

        // Only owner can reset the counter
        fn reset_counter(ref self: ContractState) {
            self.ownable.assert_only_owner();
            self.counter.write(0);
            self.emit( CounterResetted {value: self.get_counter()});
        }
    }
}