module auction {
    use aptos_framework::account;
    use aptos_framework::signer;
    use aptos_token::token;
    use access_control::AccessControl;

    struct Auction {
        id: u64,
        token_id: token::TokenId,
        start_price: u64,
        end_time: u64,
        top_bid: u64,
        top_bidder: address,
    }

    public fun start_new_auction(token_id: token::TokenId, start_price: u64, duration: u64): u64 {
        let auction_id = token::create_token_id_raw(@alcohol_auction, token_id, start_price, duration);
        let auction = Auction {
            id: auction_id,
            token_id,
            start_price,
            end_time: timestamp::now_microseconds() + duration,
            top_bid: 0,
            top_bidder: @alcohol_auction,
        };
        move_to(&auction, @alcohol_auction);
        return auction_id;
    }

    public fun bid(auction_id: u64, bidder: address, amount: u64) {
        let auction = borrow_global_mut<Auction>(@alcohol_auction, auction_id);
        if auction.top_bid < amount {
            auction.top_bid = amount;
            auction.top_bidder = bidder;
        }
    }

    public fun accept_bid_price(auction_id: u64) {
        let auction = borrow_global_mut<Auction>(@alcohol_auction, auction_id);
        let winner = auction.top_bidder;
        let amount = auction.top_bid;
        // transfer token to winner
        token::transfer(&winner, auction.token_id, 1);
    }
}