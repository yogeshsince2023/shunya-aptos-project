module tests {
    use aptos_framework::account;
    use aptos_framework::signer;
    use auction::Auction;

    public fun auction_redeem_success() {
        let source_account = @0x123;
        let bidder = @0x456;
        let token_id = token::create_token_id_raw(@alcohol, 0);

        // Create a new account for the auction
        account::create_account(source_account);

        // Create a new auction
        Auction::create_auction(source_account, token_id, 100, 1000);

        // Bid on the auction
        Auction::bid(bidder, source_account, token_id, 500);

        // Redeem the auction
        Auction::redeem(bidder, source_account, token_id);

        // Check that the auction has been redeemed successfully
        assert(Auction::get_auction_status(source_account, token_id) == Auction::AuctionStatus::REDEEMED, 1);
    }
}