-- Триггер для автоматического добавления дефолтных задач при создании пользователя
CREATE OR REPLACE TRIGGER trg_add_default_tasks
AFTER INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION add_default_tasks();

CREATE TRIGGER after_update_claimed_tokens
AFTER UPDATE OF claimed_tokens ON referrals
FOR EACH ROW
WHEN (OLD.claimed_tokens IS DISTINCT FROM NEW.claimed_tokens)
EXECUTE FUNCTION update_referrer_balance();

-- -- Триггер для каскадного удаления из таблицы users
-- CREATE OR REPLACE TRIGGER trg_delete_user_cascade
-- AFTER DELETE ON telegram_users
-- FOR EACH ROW
-- EXECUTE FUNCTION delete_user_cascade();

-- -- Триггер для каскадного удаления из таблицы tasks
-- CREATE OR REPLACE TRIGGER trg_delete_tasks_cascade
-- AFTER DELETE ON telegram_users
-- FOR EACH ROW
-- EXECUTE FUNCTION delete_tasks_cascade();

-- -- Триггер для каскадного удаления из таблицы referrals
-- CREATE OR REPLACE TRIGGER trg_delete_referrals_cascade
-- AFTER DELETE ON telegram_users
-- FOR EACH ROW
-- EXECUTE FUNCTION delete_referrals_cascade();

-- Триггер для обновления claimed_tokens в таблице referrals при начислении бонуса рефералам
-- CREATE TRIGGER trg_referral_bonus
-- AFTER UPDATE OF balance ON users
-- FOR EACH ROW
-- EXECUTE FUNCTION calculate_referral_bonus();
