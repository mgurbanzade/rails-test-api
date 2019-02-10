CREATE temp TABLE users(id bigserial, group_id BIGINT);
INSERT INTO users(group_id)
VALUES (1), (1), (1), (2), (1), (3);

WITH group_ids AS
(
  SELECT
    id,
    group_id,
    CASE
      WHEN lag(group_id) OVER () = group_id
      THEN 0
      ELSE 1
    END
    AS group_id_alias
  FROM users
),
min_ids AS
(
  SELECT
    id,
    group_id,
    CASE
      WHEN group_id_alias = 1
      THEN id
      ELSE 0
    END
    AS min_id
  FROM group_ids
  WHERE group_id_alias <> 0
)
SELECT
  min_id,
  group_id,
  CASE
    WHEN LEAD(min_id) OVER () IS NOT NULL
    THEN LEAD(min_id) OVER () - min_id
    ELSE 1
  END
  AS COUNT
FROM min_ids;
