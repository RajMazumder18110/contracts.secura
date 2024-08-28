/**
 * @title ISecura.sol
 * @author Raj Mazumder <rajmazumder27.08.2001@gmail.com>
 * @notice Implementation of interface of Secura.
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @notice Struct holds all the details of a Lock.
 */
struct Locker {
    /// @param lockId The lock id of the lock.
    uint256 lockId;
    /// @param isUnlocked The boolean value if locker unlocked.
    bool isUnlocked;
    /// @param lockOwner The lock owner address.
    address lockOwner;
    /// @param lockedERC20 The locked token address.
    address lockedERC20;
    /// @param lockedAmount The locked token amount.
    uint256 lockedAmount;
    /// @param lockName The name of the lock.
    bytes lockName;
    /// @param lockedOn The timestamp when lock started.
    uint256 lockedOn;
    /// @param lockUnlockOn The timestamp when lock will be unlocked.
    uint256 lockUnlockOn;
}

/**
 * @notice Struct to provide lock details while creating.
 */
struct CreateLockParams {
    /// @param lockName The name of the lock.
    bytes lockName;
    /// @param lockedERC20 The locked token address.
    address lockedERC20;
    /// @param lockedAmount The locked token amount.
    uint256 lockedAmount;
    /// @param lockUnlockOn The timestamp when lock will be unlocked.
    uint256 lockUnlockOn;
}

interface ISecura {
    /** @notice Custom Errors */
    error Secura_ZeroAmount();
    error Secura_ZeroAddress();
    error Secura_InvalidLockAmount();
    error Secura_InvalidLockerId(uint256 lockerIdProvided);
    error Secura_LockerAlreadyUnlocked(uint256 unlockedOnBlock);
    error Secura_UnAuthorizedOwner(address caller, address owner);
    error Secura_InvalidUnlockTime(uint256 unlockBlockNumberPassed);
    error Secura_UnlockTimeNotPassed(uint256 currentBlock, uint256 unlockBlock);

    /** @notice Events */
    event SecureLockExtended(uint256 indexed lockId, uint256 unlockBlock);
    event SecureLockUnlocked(uint256 indexed lockId, uint256 unlockBlock);
    event SecureLockCreated(uint256 indexed lockId, Locker lockerDetails);

    /**
     * @notice Returns the total amount locked by an owner and erc20 address.
     * @param owner The owner address who locked the amount.
     * @param erc20 The ERC20 token address.
     * @return lockedAmount The total locked amount.
     */
    function getTotalAmountLockedBy(
        address owner,
        address erc20
    ) external view returns (uint256 lockedAmount);

    /**
     * @notice Returns the details of the given `lockerId`.
     * @param lockerId The lockerId wants to query.
     * @return lockDetails The details of the lock (Locker struct).
     */
    function getLockerDetails(
        uint256 lockerId
    ) external view returns (Locker memory lockDetails);

    /**
     * @notice Create a locker based on parameters.
     * @param lockParams The lock details.
     * @return lockerId The generated lock id.
     */
    function createSecureLocker(
        CreateLockParams memory lockParams
    ) external returns (uint256 lockerId);

    /**
     * @notice Unlocks a locker after unlock time passed.
     * @param lockerId The locker wants to unlock.
     */
    function unlockSecureLocker(uint256 lockerId) external;

    /**
     * @notice Extends the locker unlock time.
     * @param lockerId The locker wants to extends.
     * @param unlockBlockNumber The latest unlock blockNumber
     */
    function extendSecureLockerUnlock(
        uint256 lockerId,
        uint256 unlockBlockNumber
    ) external;
}
