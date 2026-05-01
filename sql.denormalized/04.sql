/*
 * Count the number of English tweets containing the word "coronavirus"
 */
SELECT COUNT(*)
FROM tweets_jsonb
WHERE data->>'lang' = 'en'
  AND to_tsvector(
      'english',
      COALESCE( data #>> '{extended_tweet,full_text}',
        data->>'text')
    )
    @@ to_tsquery('english', 'coronavirus');
