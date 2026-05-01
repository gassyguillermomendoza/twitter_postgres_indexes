/*
 * Calculates the hashtags that are commonly used for English tweets containing the word "coronavirus"
 */
WITH coronavirus_text_tweets AS (
    SELECT
        data->>'id' AS id_tweets,
        COALESCE(
            data #> '{extended_tweet,entities,hashtags}',
            data #> '{entities,hashtags}',
            '[]'::jsonb
        ) AS hashtags
    FROM tweets_jsonb
    WHERE data->>'lang' = 'en'
      AND to_tsvector(
            'english',
            COALESCE(data #>> '{extended_tweet,full_text}', data->>'text')
          ) @@ to_tsquery('english', 'coronavirus')
)
SELECT
    '#' || hashtag_text AS tag,
    count(*) AS count
FROM (
    SELECT DISTINCT
        id_tweets,
        hashtag->>'text' AS hashtag_text
    FROM coronavirus_text_tweets,
         jsonb_array_elements(hashtags) AS hashtag
    WHERE hashtag->>'text' IS NOT NULL
) t
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;
