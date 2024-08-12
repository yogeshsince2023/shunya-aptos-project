module access_control {
    use aptos_framework::account;
    use aptos_framework::signer;

    struct AccessControl {
        admin: address,
    }

    public fun init_module(admin: address) {
        let access_control = AccessControl {
            admin,
        };
        move_to(&access_control, @alcohol_auction);
    }

    public fun change_admin(new_admin: address) {
        let access_control = borrow_global_mut<AccessControl>(@alcohol_auction);
        access_control.admin = new_admin;
    }

    public fun is_admin(account: address): bool {
        let access_control = borrow_global<AccessControl>(@alcohol_auction);
        return access_control.admin == account;
    }
}