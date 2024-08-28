/**
 * @title Secura.sol
 * @author Raj Mazumder <rajmazumder27.08.2001@gmail.com>
 * @notice Implementation Secura contract.
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Library imports
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
/// @notice External imports
import {ISecura, Locker, CreateLockParams} from "./interfaces/ISecura.sol";

contract Secura is ISecura, ReentrancyGuard {
    /** @notice Storage variables */
    uint256 private _noOfLockers;
    /// Mappings
    mapping(uint256 lockerId => Locker locker) private _lockerIdToLockerDetails;
    mapping(address owner => mapping(address erc20 => uint256 amount))
        private _totalAmountLockedByOwnerByERC20;

    /** @notice PUBLIC FUNCTIONS */

    /**
     * @notice Returns the total amount locked by an owner and erc20 address.
     * @param owner The owner address who locked the amount.
     * @param erc20 The ERC20 token address.
     * @return lockedAmount The total locked amount.
     */
    function getTotalAmountLockedBy(
        address owner,
        address erc20
    ) public view returns (uint256 lockedAmount) {
        return _totalAmountLockedByOwnerByERC20[owner][erc20];
    }

    /**
     * @notice Returns the details of the given `lockerId`.
     * @param lockerId The lockerId wants to query.
     * @return lockDetails The details of the lock (Locker struct).
     */
    function getLockerDetails(
        uint256 lockerId
    ) public view returns (Locker memory lockDetails) {
        return _lockerIdToLockerDetails[lockerId];
    }

    /** @notice EXTERNAL FUNCTIONS */

    /**
     * @notice Create a locker based on parameters.
     *  - Validates the locker params.
     *  - Transfer lock amount into contract.
     *  - Create a locker.
     *  - Emit lock create event.
     * @param lockParams The lock details.
     * @return lockerId The generated lock id.
     */
    function createSecureLocker(
        CreateLockParams memory lockParams
    ) external nonReentrant returns (uint256 lockerId) {
        /// @dev Validation
        _validateNewLockerParams(lockParams);
        /// @dev Caching
        uint256 currentBlockNumber = block.number;
        address owner = msg.sender;

        /// @dev Token transfer.
        IERC20(lockParams.lockedERC20).transferFrom(
            owner,
            address(this),
            lockParams.lockedAmount
        );

        /// @dev Create lock.
        lockerId = ++_noOfLockers;
        Locker storage locker = _lockerIdToLockerDetails[lockerId];

        locker.lockId = lockerId;
        locker.lockOwner = owner;
        locker.lockedOn = currentBlockNumber;
        locker.lockName = lockParams.lockName;
        locker.lockedERC20 = lockParams.lockedERC20;
        locker.lockedAmount = lockParams.lockedAmount;
        locker.lockUnlockOn = lockParams.lockUnlockOn;

        /// @notice Updates user lock amount;
        _totalAmountLockedByOwnerByERC20[owner][lockParams.lockedERC20];
        /// @notice Emitting event.
        emit SecureLockCreated(lockerId, locker);
    }

    /**
     * @notice Unlocks a locker after unlock time passed.
     *  - Validates the locker , unlock time, caller.
     *  - Update the locker state.
     *  - Transfer lock amount from contract to lock owner.
     *  - Emit lock create event.
     * @param lockerId The locker wants to unlock.
     */
    function unlockSecureLocker(uint256 lockerId) external nonReentrant {
        /// @dev Caching
        Locker storage locker = _lockerIdToLockerDetails[lockerId];
        uint256 currentBlockNumber = block.number;

        /// @dev Validations
        _validateLockerId(lockerId);
        _validateLockerOwnership(lockerId);
        _validateIsLockerIdLocked(lockerId);
        if (currentBlockNumber < locker.lockUnlockOn)
            revert Secura_UnlockTimeNotPassed(
                currentBlockNumber,
                locker.lockUnlockOn
            );

        /// @notice State update
        locker.isUnlocked = true;
        locker.lockUnlockOn = currentBlockNumber;

        /// @dev Token transfer.
        IERC20(locker.lockedERC20).transfer(
            locker.lockOwner,
            locker.lockedAmount
        );
        emit SecureLockUnlocked(lockerId, currentBlockNumber);
    }

    /**
     * @notice Extends the locker unlock time.
     *  - Validates the locker , unlock time, caller.
     *  - Update the locker state (unlock block).
     *  - Emit lock create event.
     * @param lockerId The locker wants to extends.
     * @param unlockBlockNumber The latest unlock blockNumber
     */
    function extendSecureLockerUnlock(
        uint256 lockerId,
        uint256 unlockBlockNumber
    ) external nonReentrant {
        /// @dev Caching
        Locker storage locker = _lockerIdToLockerDetails[lockerId];
        uint256 currentBlockNumber = block.number;

        /// @dev Validations
        _validateLockerId(lockerId);
        _validateLockerOwnership(lockerId);
        _validateIsLockerIdLocked(lockerId);

        /// @dev: block number validation
        if (
            unlockBlockNumber <= currentBlockNumber &&
            unlockBlockNumber <= locker.lockUnlockOn
        ) revert Secura_InvalidUnlockTime(unlockBlockNumber);

        /// @dev State update.
        locker.lockUnlockOn = unlockBlockNumber;
        emit SecureLockExtended(lockerId, unlockBlockNumber);
    }

    /** @notice INTERNAL FUNCTIONS */
    /**
     * @notice Checks if `lockerId` is valid else throw error.
     * @param lockerId The locker id wants to check for.
     */
    function _validateLockerId(uint256 lockerId) internal view {
        /// @dev Caching
        Locker memory locker = getLockerDetails(lockerId);
        /// Zero address Validation
        if (locker.lockOwner == address(0))
            revert Secura_InvalidLockerId(lockerId);
    }

    /**
     * @notice Checks if `lockerId` is locked else throw error.
     * @param lockerId The locker id wants to check for.
     */
    function _validateIsLockerIdLocked(uint256 lockerId) internal view {
        /// @dev Caching
        Locker memory locker = getLockerDetails(lockerId);
        /// Zero address Validation
        if (locker.isUnlocked)
            revert Secura_LockerAlreadyUnlocked(locker.lockUnlockOn);
    }

    /**
     * @notice Checks if caller is `lockerId`'s owner else throw error.
     * @param lockerId The locker id wants to check for.
     */
    function _validateLockerOwnership(uint256 lockerId) internal view {
        /// @dev Caching
        address caller = msg.sender;
        Locker memory locker = getLockerDetails(lockerId);
        /// Zero address Validation
        if (caller != locker.lockOwner)
            revert Secura_UnAuthorizedOwner(caller, locker.lockOwner);
    }

    /**
     * @notice Checks if locker details is valid else throw error.
     * @param lockParams The locker creation params.
     */
    function _validateNewLockerParams(
        CreateLockParams memory lockParams
    ) internal view {
        /// @dev Validations
        uint256 currentBlockNumber = block.number;

        /// Unlock time check
        if (lockParams.lockUnlockOn <= currentBlockNumber)
            revert Secura_InvalidUnlockTime(lockParams.lockUnlockOn);
        if (lockParams.lockedAmount == 0) revert Secura_ZeroAmount();
        if (lockParams.lockedERC20 == address(0)) revert Secura_ZeroAddress();
    }
}
