INSERT INTO ecf.numeroduplicata (id, numero) VALUES (1, 100059);

SELECT setval('ecf.numeroduplicata_id_seq', (SELECT count(id)+1 FROM ecf.numeroduplicata));
