SELECT * FROM multic.conversation
WHERE company_id = '99' AND messenger_id = '197';

SELECT COUNT(id) FROM multic.conversation
WHERE company_id = '99' AND messenger_id = '197';

SELECT * FROM multic.conversation
WHERE company_id = '99' AND messenger_id = '197' AND last_updated >= NOW() - INTERVAL 50 DAY;

UPDATE multic.conversation
SET status = 'closed'
WHERE company_id = '99' AND messenger_id = '197' AND last_updated >= NOW() - INTERVAL 50 DAY;

UPDATE multic.conversation
SET last_activity = NOW()
WHERE company_id = '99' AND messenger_id = '197' AND last_updated >= NOW() - INTERVAL 50 DAY;
