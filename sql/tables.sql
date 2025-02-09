CREATE TABLE Users (
    user_id UUID PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    is_authenticated BOOLEAN NOT NULL DEFAULT false,
    status VARCHAR(20) NOT NULL DEFAULT 'offline',
    last_login TIMESTAMP NOT NULL,
    two_factor_enabled BOOLEAN NOT NULL DEFAULT false,
    is_bot BOOLEAN NOT NULL DEFAULT false  
);

CREATE TABLE AuthCode (
    user_id UUID,
    verification_code VARCHAR(100) NOT NULL,
    expiry_time TIMESTAMP NOT NULL,
    is_verified BOOLEAN NOT NULL DEFAULT false,
    PRIMARY KEY (user_id, verification_code),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Session (
    session_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    created_at TIMESTAMP NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    device_type VARCHAR(100) NOT NULL,
    ip_address VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Calls (
    caller_user_id UUID NOT NULL,
    receiver_user_id UUID NOT NULL,
    started_at TIMESTAMP NOT NULL,
    ended_at TIMESTAMP,
    call_type VARCHAR(20) NOT NULL CHECK (call_type IN ('voice', 'video')),
    PRIMARY KEY (caller_user_id, receiver_user_id, started_at),
    FOREIGN KEY (caller_user_id) REFERENCES Users(user_id),
    FOREIGN KEY (receiver_user_id) REFERENCES Users(user_id)
);

CREATE TABLE Story (
    story_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    created_at TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Story_view (
    story_id UUID NOT NULL,
    user_id UUID NOT NULL,
    viewed_at TIMESTAMP NOT NULL,
    is_liked BOOLEAN NOT NULL DEFAULT false,
    PRIMARY KEY (story_id, user_id),
    FOREIGN KEY (story_id) REFERENCES Story(story_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Chat (
    chat_id UUID PRIMARY KEY,
    type VARCHAR(20) NOT NULL CHECK (type IN ('private', 'group', 'channel')),
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE Channels (
    chat_id UUID PRIMARY KEY,
    channel_name VARCHAR(100) NOT NULL,
    channel_description VARCHAR(255),
    creator_user_id UUID NOT NULL,
    FOREIGN KEY (chat_id) REFERENCES Chat(chat_id),
    FOREIGN KEY (creator_user_id) REFERENCES Users(user_id)
);

CREATE TABLE ChannelMembers (
    user_id UUID NOT NULL,
    channel_id UUID NOT NULL,
    joined_at TIMESTAMP NOT NULL,
    is_admin BOOLEAN NOT NULL DEFAULT false,
    PRIMARY KEY (user_id, channel_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (channel_id) REFERENCES Channels(chat_id)
);

CREATE TABLE ChannelBans (
    user_id UUID NOT NULL,
    channel_id UUID NOT NULL,
    banned_by UUID NOT NULL,
    banned_at TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id, channel_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (channel_id) REFERENCES Channels(chat_id),
    FOREIGN KEY (banned_by) REFERENCES Users(user_id)
);

CREATE TABLE Groups (
    chat_id UUID PRIMARY KEY,
    group_name VARCHAR(100) NOT NULL,
    group_description VARCHAR(255),
    creator_user_id UUID NOT NULL,
    FOREIGN KEY (chat_id) REFERENCES Chat(chat_id),
    FOREIGN KEY (creator_user_id) REFERENCES Users(user_id)
);

CREATE TABLE GroupMembers (
    user_id UUID NOT NULL,
    group_id UUID NOT NULL,
    joined_at TIMESTAMP NOT NULL,
    is_admin BOOLEAN NOT NULL DEFAULT false,
    PRIMARY KEY (user_id, group_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Groups(chat_id)
);

CREATE TABLE GroupBans (
    user_id UUID NOT NULL,
    group_id UUID NOT NULL,
    banned_by UUID NOT NULL,
    banned_at TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id, group_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (group_id) REFERENCES Groups(chat_id),
    FOREIGN KEY (banned_by) REFERENCES Users(user_id)
);

CREATE TABLE Polls (
    poll_id UUID PRIMARY KEY,
    created_by UUID NOT NULL,
    description TEXT NOT NULL,
    is_anonymous BOOLEAN NOT NULL DEFAULT true,
    chat_id UUID NOT NULL,
    FOREIGN KEY (created_by) REFERENCES Users(user_id),
    FOREIGN KEY (chat_id) REFERENCES Chat(chat_id)
);

CREATE TABLE PollOptions (
    poll_id UUID NOT NULL,
    option_id UUID NOT NULL,
    option_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (poll_id, option_id),
    FOREIGN KEY (poll_id) REFERENCES Polls(poll_id)
);

CREATE TABLE PollVoters (
    poll_id UUID NOT NULL,
    option_id UUID NOT NULL,
    user_id UUID NOT NULL,
    voted_at TIMESTAMP NOT NULL,
    PRIMARY KEY (poll_id, option_id, user_id),
    FOREIGN KEY (poll_id, option_id) REFERENCES PollOptions(poll_id, option_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Block_Users (
    blocker_user_id UUID NOT NULL,
    blocked_user_id UUID NOT NULL,
    block_date TIMESTAMP NOT NULL,
    PRIMARY KEY (blocker_user_id, blocked_user_id),
    FOREIGN KEY (blocker_user_id) REFERENCES Users(user_id),
    FOREIGN KEY (blocked_user_id) REFERENCES Users(user_id)
);

CREATE TABLE Bot (
    bot_id UUID PRIMARY KEY,
    user_id UUID NOT NULL UNIQUE,
    bot_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    username VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Bot_commands (
    command_id UUID PRIMARY KEY,
    bot_id UUID NOT NULL,
    command VARCHAR(100) NOT NULL,
    arguments VARCHAR(255),
    FOREIGN KEY (bot_id) REFERENCES Bot(bot_id)
);

CREATE TABLE BotUsers (
    bot_id UUID NOT NULL,
    user_id UUID NOT NULL,
    PRIMARY KEY (bot_id, user_id),
    FOREIGN KEY (bot_id) REFERENCES Bot(bot_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Messages (
    message_id UUID PRIMARY KEY,
    chat_id UUID NOT NULL,
    user_id UUID NOT NULL,
    message_content TEXT NOT NULL,
    sent_at TIMESTAMP NOT NULL,
    edited_at TIMESTAMP,
    FOREIGN KEY (chat_id) REFERENCES Chat(chat_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Attachment (
    attachment_id UUID PRIMARY KEY,
    message_id UUID NOT NULL,
    attachment_type VARCHAR(50) NOT NULL CHECK (attachment_type IN ('photo', 'video', 'gif', 'document', 'audio', 'sticker')),
    file_size BIGINT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    upload_date TIMESTAMP NOT NULL,
    FOREIGN KEY (message_id) REFERENCES Messages(message_id)
);

CREATE TABLE Photos (
    attachment_id UUID PRIMARY KEY,
    width INT NOT NULL,
    height INT NOT NULL,
    FOREIGN KEY (attachment_id) REFERENCES Attachment(attachment_id)
);

CREATE TABLE Videos (
    attachment_id UUID PRIMARY KEY,
    width INT NOT NULL,
    height INT NOT NULL,
    thumbnail VARCHAR(255) NOT NULL,
    duration INT NOT NULL,  
    FOREIGN KEY (attachment_id) REFERENCES Attachment(attachment_id)
);

CREATE TABLE GIF (
    attachment_id UUID PRIMARY KEY,
    width INT NOT NULL,
    height INT NOT NULL,
    thumbnail VARCHAR(255) NOT NULL,
    duration INT NOT NULL,
    FOREIGN KEY (attachment_id) REFERENCES Attachment(attachment_id)
);

CREATE TABLE Document (
    attachment_id UUID PRIMARY KEY,
    mime_type VARCHAR(100) NOT NULL,
    FOREIGN KEY (attachment_id) REFERENCES Attachment(attachment_id)
);

CREATE TABLE Audio (
    attachment_id UUID PRIMARY KEY,
    quality VARCHAR(50) NOT NULL,
    duration INT NOT NULL,
    FOREIGN KEY (attachment_id) REFERENCES Attachment(attachment_id)
);

CREATE TABLE Stickers (
    attachment_id UUID PRIMARY KEY,
    sticker_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    created_by UUID NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    FOREIGN KEY (attachment_id) REFERENCES Attachment(attachment_id),
    FOREIGN KEY (created_by) REFERENCES Users(user_id)
);

CREATE TABLE Reaction (
    reaction_id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL,
    message_id UUID NOT NULL,
    reacted_at TIMESTAMP NOT NULL,
    reaction_type VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (message_id) REFERENCES Messages(message_id)
);

CREATE TABLE PrivateChats_user (
    user_id1 UUID NOT NULL,
    user_id2 UUID NOT NULL,
    started_at TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id1, user_id2),
    FOREIGN KEY (user_id1) REFERENCES Users(user_id),
    FOREIGN KEY (user_id2) REFERENCES Users(user_id)
);

CREATE TABLE UserSettings (
    user_id UUID PRIMARY KEY,
    settings_json JSONB NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Contacts (
    user_id UUID NOT NULL,
    contact_user_id UUID NOT NULL,
    added_at TIMESTAMP NOT NULL,
    phone_number VARCHAR(15),
    PRIMARY KEY (user_id, contact_user_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (contact_user_id) REFERENCES Users(user_id)
);

CREATE TABLE ChatFolders (
    user_id UUID NOT NULL,
    chat_id UUID NOT NULL,
    folder_name VARCHAR(100) NOT NULL,
    theme VARCHAR(100),
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id, chat_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (chat_id) REFERENCES Chat(chat_id)
);

CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL CHECK (payment_method IN ('credit_card', 'paypal', 'crypto')),
    payment_date TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Wallet (
    wallet_id UUID PRIMARY KEY,
    user_id UUID NOT NULL UNIQUE,
    balance DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Subscription (
    subscription_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    features JSONB NOT NULL,  
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);









