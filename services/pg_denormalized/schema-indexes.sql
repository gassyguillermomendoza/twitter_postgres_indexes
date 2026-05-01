CREATE INDEX tweets_jsonb_hashtags_idx
ON tweets_jsonb
USING GIN ((data #> '{entities,hashtags}') jsonb_path_ops);

CREATE INDEX tweets_jsonb_hashtags_coalesce_idx
ON tweets_jsonb
USING GIN (
    (COALESCE(
            data #> '{extended_tweet,entities,hashtags}',
            data #> '{entities,hashtags}',
            '[]'::jsonb
        )
    ) jsonb_path_ops
);

CREATE INDEX
ON tweets_jsonb
USING GIN (
    to_tsvector(
        'english',
        COALESCE(data #>> '{extended_tweet,full_text}', data->>'text')
    )
);

CREATE INDEX tweets_jsonb_lang_idx
ON tweets_jsonb ((data->>'lang'));
