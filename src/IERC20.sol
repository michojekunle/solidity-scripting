// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

interface IERC20 {
    // Emitted when `value` tokens are moved from one account (`from`) to another (`to`).
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Emitted when the allowance of a `spender` for an `owner` is set by
    // a call to {approve}. `value` is the new allowance.
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    // Returns the amount of tokens in existence.
    function totalSupply() external view returns (uint256);

    // Returns the amount of tokens owned by `account`.
    function balanceOf(address account) external view returns (uint256);

    // Moves `amount` tokens from the caller's account to `recipient`.
    // Returns a boolean value indicating whether the operation succeeded.
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    // Returns the remaining number of tokens that `spender` will be
    // allowed to spend on behalf of `owner` through {transferFrom}. This is
    // zero by default.
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    // Sets `amount` as the allowance of `spender` over the caller's tokens.
    // Returns a boolean value indicating whether the operation succeeded.
    function approve(address spender, uint256 amount) external returns (bool);

    // Moves `amount` tokens from `sender` to `recipient` using the
    // allowance mechanism. `amount` is then deducted from the caller's
    // allowance.
    // Returns a boolean value indicating whether the operation succeeded.
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}
