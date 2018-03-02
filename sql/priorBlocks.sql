SELECT n FROM block
WHERE block.n < ${block}
ORDER BY n DESC
LIMIT ${limit};
