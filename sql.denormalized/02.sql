/*
 * Calculates the hashtags that are commonly used with the hashtag #coronavirus
 */
WITH coronavirus_tweets AS (
    SELECT
        data->>'id' AS id_tweets,
        COALESCE(
            data #> '{extended_tweet,entities,hashtags}',
            data #> '{entities,hashtags}',
            '[]'::jsonb
        ) AS hashtags
    FROM tweets_jsonb
    WHERE COALESCE(
            data #> '{extended_tweet,entities,hashtags}',
            data #> '{entities,hashtags}',
            '[]'::jsonb
          ) @> '[{"text":"coronavirus"}]'::jsonb
)
SELECT
    '#' || hashtag_text AS tag,
    count(*) AS count
FROM (
    SELECT DISTINCT
        id_tweets,
        hashtag->>'text' AS hashtag_text
    FROM coronavirus_tweets,
         jsonb_array_elements(hashtags) AS hashtag
    WHERE hashtag->>'text' IS NOT NULL
) t
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;
