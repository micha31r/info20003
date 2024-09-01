-- __/\\\\\\\\\\\__/\\\\\_____/\\\__/\\\\\\\\\\\\\\\____/\\\\\_________/\\\\\\\\\_________/\\\\\\\________/\\\\\\\________/\\\\\\\________/\\\\\\\\\\________________/\\\\\\\\\_______/\\\\\\\\\_____        
--  _\/////\\\///__\/\\\\\\___\/\\\_\/\\\///////////___/\\\///\\\_____/\\\///////\\\_____/\\\/////\\\____/\\\/////\\\____/\\\/////\\\____/\\\///////\\\_____________/\\\\\\\\\\\\\___/\\\///////\\\___       
--   _____\/\\\_____\/\\\/\\\__\/\\\_\/\\\____________/\\\/__\///\\\__\///______\//\\\___/\\\____\//\\\__/\\\____\//\\\__/\\\____\//\\\__\///______/\\\_____________/\\\/////////\\\_\///______\//\\\__      
--    _____\/\\\_____\/\\\//\\\_\/\\\_\/\\\\\\\\\\\___/\\\______\//\\\___________/\\\/___\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\_________/\\\//_____________\/\\\_______\/\\\___________/\\\/___     
--     _____\/\\\_____\/\\\\//\\\\/\\\_\/\\\///////___\/\\\_______\/\\\________/\\\//_____\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\________\////\\\____________\/\\\\\\\\\\\\\\\________/\\\//_____    
--      _____\/\\\_____\/\\\_\//\\\/\\\_\/\\\__________\//\\\______/\\\______/\\\//________\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\___________\//\\\___________\/\\\/////////\\\_____/\\\//________   
--       _____\/\\\_____\/\\\__\//\\\\\\_\/\\\___________\///\\\__/\\\______/\\\/___________\//\\\____/\\\__\//\\\____/\\\__\//\\\____/\\\___/\\\______/\\\____________\/\\\_______\/\\\___/\\\/___________  
--        __/\\\\\\\\\\\_\/\\\___\//\\\\\_\/\\\_____________\///\\\\\/______/\\\\\\\\\\\\\\\__\///\\\\\\\/____\///\\\\\\\/____\///\\\\\\\/___\///\\\\\\\\\/_____________\/\\\_______\/\\\__/\\\\\\\\\\\\\\\_ 
--         _\///////////__\///_____\/////__\///________________\/////_______\///////////////_____\///////________\///////________\///////_______\/////////_______________\///________\///__\///////////////__

-- Your Name: Liyu Ren
-- Your Student Number: 1397728
-- By submitting, you declare that this work was completed entirely by yourself.

-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q1

SELECT postPermanentID, text
FROM post
WHERE NOT EXISTS (
	SELECT *
    FROM react
    WHERE postID = postPermanentID
);

-- END Q1
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2

SELECT modID, username, dateModStatus
FROM moderator
INNER JOIN user ON linkedUserID = userID
ORDER BY dateModStatus DESC
LIMIT 1;

-- END Q2
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3

SELECT postPermanentID, viewCount
FROM post
INNER JOIN user ON authorID = userID
WHERE username = 'axe' AND viewCount >= 9000;

-- END Q3
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q4

SELECT originalPostID AS postPermanentID, COUNT(originalPostID) AS totalCommentCount
FROM postreply
GROUP BY originalPostID
HAVING COUNT(originalPostID) = (
	-- Get the maximum comment count across all posts
	SELECT MAX(commentCount)
	FROM (
		-- Get the number of comments for each post
		SELECT COUNT(originalPostID) AS commentCount
		FROM postreply
		GROUP BY originalPostID
	) a -- Pseudo table name
);

-- END Q4
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q5

SELECT dataURL, channel.channelID
FROM attachmentobject
INNER JOIN post ON post.postPermanentID = attachmentobject.postPermanentID
INNER JOIN postchannel ON postchannel.postID = post.postPermanentID
INNER JOIN channel ON channel.channelID = postchannel.channelID
WHERE channelName LIKE '%dota2%';

-- END Q5
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q6

SELECT channel.channelID, COUNT(react.postID) AS heartCount
FROM react
INNER JOIN post ON post.postPermanentID = react.postID
INNER JOIN postchannel ON postchannel.postID = post.postPermanentID
INNER JOIN channel ON channel.channelID = postchannel.channelID 
GROUP BY channelID
HAVING COUNT(react.postID) = (
  -- Get the maximum react count across all channels
	SELECT MAX(reactCount)
	FROM (
    -- Get react count for each channel
		SELECT COUNT(react.postID) AS reactCount
		FROM react
		INNER JOIN post ON post.postPermanentID = react.postID
		INNER JOIN postchannel ON postchannel.postID = post.postPermanentID
		INNER JOIN channel ON channel.channelID = postchannel.channelID 
		GROUP BY channel.channelID
	) a
);

-- END Q6
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q7

SELECT user.userID, reputation, COUNT(caseID) AS totalModeratorReports, COUNT(postID) AS totalLoveReacts
FROM user
INNER JOIN post ON post.authorID = user.userID
INNER JOIN moderatorreport ON moderatorreport.postPermanentID = post.postPermanentID
INNER JOIN react ON react.postID = post.postPermanentID
WHERE reputation < 60
GROUP BY user.userID
HAVING COUNT(caseID) >= 1 AND COUNT(postID) >= 3;

-- END Q7
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q8

SELECT channel.channelID, channelName, COUNT(virusScanned) AS totalVirusInfectedAttachements
FROM channel
INNER JOIN postchannel ON postchannel.channelID = channel.channelID
INNER JOIN post ON post.postPermanentID = postchannel.postID
INNER JOIN attachmentobject ON attachmentobject.postPermanentID = post.postPermanentID
WHERE virusScanned = 1
GROUP BY channel.channelID
HAVING COUNT(virusScanned) IN (
	-- Create a derived table to get the top 3 virus counts because LIMIT is not supported in subqueries
	SELECT *
  FROM (
		-- Get the top three biggest channel virus counts, across all channels
		SELECT DISTINCT COUNT(virusScanned) AS virusCount
		FROM attachmentobject
		INNER JOIN post ON post.postPermanentID = attachmentobject.postPermanentID
		INNER JOIN postchannel ON postchannel.postID = post.postPermanentID
		INNER JOIN channel ON channel.channelID = postchannel.channelID
		WHERE virusScanned = 1
		GROUP BY channel.channelID
		ORDER BY virusCount DESC
		LIMIT 3
	) a
);

-- END Q8
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q9





-- END Q9
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q10





-- END Q10
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- END OF ASSIGNMENT Do not write below this line