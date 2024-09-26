CREATE TABLE telegram_users (
    id SERIAL PRIMARY KEY,
    chat_id BIGINT UNIQUE,
    username VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    language_code VARCHAR(5),
    registration_timestamp TIMESTAMP WITH TIME ZONE DEFAULT timezone('Europe/Moscow'::TEXT, CURRENT_TIMESTAMP)
);

-- Индекс для таблицы telegram_users (только индекс на chat_id, так как индекс на id создаётся автоматически)
CREATE INDEX idx_telegram_users_chat_id ON telegram_users(chat_id);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    telegram_id INTEGER UNIQUE REFERENCES telegram_users(id) ON DELETE CASCADE,
    balance INTEGER NOT NULL DEFAULT 0,
    last_claim_timestamp TIMESTAMP
);

-- Индекс для таблицы users
CREATE INDEX idx_users_telegram_id ON users(telegram_id);

CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    task_name VARCHAR(50) NOT NULL,
    task_status INTEGER NOT NULL
);

-- Индекс для таблицы tasks
CREATE INDEX idx_tasks_user_id ON tasks(user_id);

CREATE TABLE referrals (
    id SERIAL PRIMARY KEY,
    referrer_telegram_id INTEGER REFERENCES telegram_users(id) ON DELETE CASCADE,
    referral_telegram_id INTEGER REFERENCES telegram_users(id) ON DELETE CASCADE,
    claimed_tokens INTEGER DEFAULT 0,
    UNIQUE (referrer_telegram_id, referral_telegram_id)
);

-- Индексы для таблицы referrals
CREATE INDEX idx_referrals_referrer_telegram_id ON referrals(referrer_telegram_id);
CREATE INDEX idx_referrals_referral_telegram_id ON referrals(referral_telegram_id);
