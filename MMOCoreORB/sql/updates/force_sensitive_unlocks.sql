-- Pre-P9 Force Sensitive character slot unlocks (account-level)
-- Run this once against your SWGEmu database.

CREATE TABLE IF NOT EXISTS `force_sensitive_unlocks` (
	`account_id` INT UNSIGNED NOT NULL,
	`unlocked_at` INT UNSIGNED NOT NULL DEFAULT 0,
	`unlocked_by_character` BIGINT UNSIGNED NULL DEFAULT NULL,
	PRIMARY KEY (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Optional: manually unlock an account for testing
-- INSERT INTO force_sensitive_unlocks (account_id, unlocked_at) VALUES (<account_id>, UNIX_TIMESTAMP());
