-- 1.
SELECT
  name
FROM
  personal
WHERE
  persnr IN (
    SELECT
      a.persnr
    FROM
      auftrag a
      INNER JOIN kunde k ON a.kundnr = k.nr
    WHERE
      k.name = 'Fahrrad Shop'
  );

-- 2.
SELECT
  p1.name Name,
  p2.name Chef
FROM
  personal p1
  INNER JOIN personal p2 ON p1.vorgesetzt = p2.persnr;

-- 3.
SELECT
  p.name,
  ap.teilenr,
  k.name
FROM
  personal p,
  kunde k,
  auftrag a,
  auftragsposten ap
WHERE
  p.persnr = a.persnr
  AND k.nr = a.kundnr
  AND a.auftrnr = ap.auftrnr
  AND p.name IN (
    SELECT
      p1.name Name
    FROM
      personal p1
      INNER JOIN personal p2 ON p1.vorgesetzt = p2.persnr
    WHERE
      p2.aufgabe = 'Manager'
  );

-- 4.
SELECT
  name
FROM
  kunde
WHERE
  ort = 'Regensburg'
  AND nr IN (
    SELECT
      kundnr
    FROM
      auftrag
  );

-- 5.
SELECT
  *
FROM
  auftragsposten
WHERE
  teilenr = 100001
  OR auftrnr IN (
    SELECT
      auftrnr
    FROM
      auftragsposten
    GROUP BY
      auftrnr
    HAVING
      SUM(gesamtpreis) = (
        SELECT
          MIN(sum)
        FROM
          (
            SELECT
              auftrnr,
              SUM(gesamtpreis) sum
            FROM
              auftragsposten
            GROUP BY
              auftrnr
          ) as t_vol
      )
  );