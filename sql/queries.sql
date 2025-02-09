-- Print the three most-used stickers by the user with the ID "mohammad".
SELECT s.sticker_name, COUNT(*) AS usage_count
FROM Users u
JOIN Messages m ON u.user_id = m.user_id
JOIN Attachment a ON m.message_id = a.message_id
JOIN Stickers s ON a.attachment_id = s.attachment_id
WHERE u.username = 'mohammad'
GROUP BY s.sticker_name
ORDER BY usage_count DESC
LIMIT 3;


-- Print all mutual contacts between users with the IDs "mohammad" and "ali".
SELECT u.username AS common_contact_username
FROM Users u
JOIN Contacts c1 ON u.user_id = c1.contact_user_id
JOIN Contacts c2 ON u.user_id = c2.contact_user_id
JOIN Users u1 ON c1.user_id = u1.user_id AND u1.username = 'mohammad'
JOIN Users u2 ON c2.user_id = u2.user_id AND u2.username = 'ali';


--Print the number of messages along with the names of groups that have more than 10,000 members, sorted by message count.
SELECT g.group_name, COUNT(m.message_id) AS total_messages
FROM Groups g
JOIN Messages m ON g.chat_id = m.chat_id
WHERE (SELECT COUNT(*) FROM GroupMembers gm WHERE gm.group_id = g.chat_id) > 10000
GROUP BY g.group_name
ORDER BY total_messages DESC
LIMIT 10;


--Print the name of the group with the highest number of messages sent in the last 10 days.
SELECT g.group_name, COUNT(m.message_id) AS message_count
FROM Groups g
JOIN Messages m ON g.chat_id = m.chat_id
WHERE m.sent_at >= NOW() - INTERVAL '10 days'
GROUP BY g.group_name
ORDER BY message_count DESC
LIMIT 10;


-- Print the total size of files uploaded by the user who has the most group memberships.
WITH TopUser AS (
    SELECT gm.user_id
    FROM GroupMembers gm
    GROUP BY gm.user_id
    ORDER BY COUNT(gm.group_id) DESC
    LIMIT 1
)
SELECT SUM(a.file_size) AS total_upload_size
FROM TopUser tu
JOIN Messages m ON tu.user_id = m.user_id
JOIN Attachment a ON m.message_id = a.message_id;


-- Print the names of users who are members of exactly two groups.
SELECT u.username
FROM Users u
JOIN GroupMembers gm ON u.user_id = gm.user_id
GROUP BY u.username
HAVING COUNT(gm.group_id) <= 2;


-- Print the contact numbers that start with 0912 and end with 8.
SELECT phone_number
FROM Users
WHERE phone_number LIKE '0922%' 
  AND phone_number LIKE '%8';



-- Print all messages that were sent in groups where both "ali" and "hossein" are mutual members.
SELECT DISTINCT u.username
FROM Users u
JOIN GroupMembers gm ON u.user_id = gm.user_id
WHERE gm.group_id IN (
    SELECT group_id
    FROM Users u
    JOIN GroupMembers gm ON u.user_id = gm.user_id
    WHERE u.username = 'ali'
) AND u.username != 'ali';  -- Exclude 'ali' himself


-- Print the average number of characters per message sent by the bot with the ID "first_bot".
SELECT AVG(LENGTH(m.message_content))  
FROM Messages m  
JOIN PrivateChats_user pc 
    ON (m.user_id = pc.user_id1 OR m.user_id = pc.user_id2)  
JOIN Bot b 
    ON (pc.user_id1 = b.user_id OR pc.user_id2 = b.user_id)  
WHERE b.username = 'first_bot'  
AND m.user_id != b.user_id;









