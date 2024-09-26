-- Функция для добавления дефолтных значений в tasks
CREATE OR REPLACE FUNCTION add_default_tasks()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO tasks (user_id, task_name, task_status)
    VALUES (NEW.id, 'joinToGame', 1),
           (NEW.id, 'visitToWebSite', 0),
           (NEW.id, 'joinToTelegramChannel', 0);
        --    (NEW.id, 'subscribeToTelegramChannel', 1);
        --    (NEW.id, 'joinToTwitterChannel', 0);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Функция для обновления баланса refferer
CREATE OR REPLACE FUNCTION update_referrer_balance()
RETURNS TRIGGER AS $$
BEGIN
    -- Обновляем баланс реферера на сумму, равную обновленным claimed_tokens у реферала
    UPDATE users
    SET balance = balance + NEW.claimed_tokens - OLD.claimed_tokens
    WHERE telegram_id = NEW.referrer_telegram_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- -- Триггер для каскадного удаления из таблицы users
-- CREATE OR REPLACE FUNCTION delete_user_cascade()
-- RETURNS TRIGGER AS $$
-- DECLARE
--     user_exists BOOLEAN;
-- BEGIN
--     -- Проверяем существование пользователя в таблице users
--     SELECT EXISTS(SELECT 1 FROM users WHERE telegram_id = OLD.id) INTO user_exists;
    
--     IF user_exists THEN
--         -- Удаляем пользователя из таблицы users
--         DELETE FROM users WHERE telegram_id = OLD.id;
--         RETURN OLD;
--     ELSE
--         -- Если пользователя нет в таблице users, генерируем уведомление
--         RAISE NOTICE 'Пользователь с telegram_id % не найден в таблице users. Не удалено из таблицы users.', OLD.id;
--         RETURN NULL;
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql;



-- -- Функция для каскадного удаления из таблицы tasks
-- CREATE OR REPLACE FUNCTION delete_tasks_cascade()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     -- Удаляем задачи пользователя из таблицы tasks
--     DELETE FROM tasks WHERE user_id = OLD.id;
--     RETURN OLD;
-- END;
-- $$ LANGUAGE plpgsql;


-- -- Функция для каскадного удаления из таблицы referrals
-- CREATE OR REPLACE FUNCTION delete_referrals_cascade()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     -- Удаляем реферальные связи для данного пользователя
--     DELETE FROM referrals WHERE referrer_telegram_id = OLD.id OR referral_telegram_id = OLD.id;
--     RETURN OLD;
-- END;
-- $$ LANGUAGE plpgsql;




-- Функция для обновления claimed_tokens в таблице referrals при начислении бонуса рефералам
-- CREATE OR REPLACE FUNCTION calculate_referral_bonus()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     -- Проверяем, является ли пользователь рефералом
--     IF EXISTS (
--         SELECT 1 FROM referrals
--         WHERE referral_telegram_id = NEW.telegram_id
--     ) THEN
--         -- Вычисляем 10% от изменения баланса
--         DECLARE
--             bonus_amount INTEGER;
--             referrer_id INTEGER;
--         BEGIN
--             bonus_amount := ROUND((NEW.balance - OLD.balance) * 0.1);
            
--             -- Получаем id реферера
--             SELECT referrer_telegram_id INTO referrer_id
--             FROM referrals
--             WHERE referral_telegram_id = NEW.telegram_id
--             LIMIT 1;
            
--             -- Обновляем баланс реферала
--             UPDATE users
--             SET balance = balance + bonus_amount
--             WHERE telegram_id = referrer_id;
            
--             -- Обновляем claimed_tokens
--             UPDATE referrals
--             SET claimed_tokens = claimed_tokens + 1
--             WHERE referrer_telegram_id = referrer_id
--               AND referral_telegram_id = NEW.telegram_id;
--         END;
--     END IF;
    
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;
