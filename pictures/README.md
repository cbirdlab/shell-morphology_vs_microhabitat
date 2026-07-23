# Pictures Directory Documentation

This directory contains Canon field photographs associated with individual opihi observations. The image-to-individual links are recorded in `photolog.tsv` and are inferred from Canon filename order, EXIF metadata, and the `Pics` field in `../data/DataOpihiMorphologyMicrohabitat.csv`.

## `photolog.tsv`

`photolog.tsv` is a tab-delimited photo index with one row per image. It contains:

- `photo_file`: image filename in this directory.
- `exif_datetime_original`: timestamp embedded in the image metadata.
- `camera_make`, `camera_model`, `canon_image_number`: camera metadata and Canon sequence number.
- `inferred_photo_number`: field photo number inferred from filename order.
- `GPSwpt`, `Site`, `IndivID`, `Pics`: linked morphology-table fields.
- `association_confidence`, `association_basis`, `notes`: documentation of how reliable the association is and how it was made.

The EXIF timestamps do not include a timezone and appear inconsistent with field waypoint dates. Use the `Pics` sequence and association fields for individual linkage, not timestamp alone.

## Photo Catalog

| Image | Individual | Location | Date and Time | Photo Linkage |
| --- | --- | --- | --- | --- |
| <img src="IMG_5739.JPG" alt="IMG_5739.JPG - individual 29 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5739.JPG` | `29` | `HonoluaAdjacentInnerSide`<br>GPS `69` | `2023-06-12 01:57:04` | Inferred photo `27`; `Pics = 27-28`; confidence `High` |
| <img src="IMG_5740.JPG" alt="IMG_5740.JPG - individual 29 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5740.JPG` | `29` | `HonoluaAdjacentInnerSide`<br>GPS `69` | `2023-06-12 01:57:12` | Inferred photo `28`; `Pics = 27-28`; confidence `High` |
| <img src="IMG_5741.JPG" alt="IMG_5741.JPG - individual 30 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5741.JPG` | `30` | `HonoluaAdjacentInnerSide`<br>GPS `69` | `2023-06-12 01:58:09` | Inferred photo `29`; `Pics = 29-30`; confidence `High` |
| <img src="IMG_5742.JPG" alt="IMG_5742.JPG - individual 30 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5742.JPG` | `30` | `HonoluaAdjacentInnerSide`<br>GPS `69` | `2023-06-12 01:58:15` | Inferred photo `30`; `Pics = 29-30`; confidence `High` |
| <img src="IMG_5743.JPG" alt="IMG_5743.JPG - individual 31 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5743.JPG` | `31` | `HonoluaAdjacentInnerSide`<br>GPS `70` | `2023-06-12 02:00:10` | Inferred photo `31`; `Pics = 31-32`; confidence `High` |
| <img src="IMG_5744.JPG" alt="IMG_5744.JPG - individual 31 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5744.JPG` | `31` | `HonoluaAdjacentInnerSide`<br>GPS `70` | `2023-06-12 02:00:18` | Inferred photo `32`; `Pics = 31-32`; confidence `High` |
| <img src="IMG_5745.JPG" alt="IMG_5745.JPG - individual 32 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5745.JPG` | `32` | `HonoluaAdjacentInnerSide`<br>GPS `70` | `2023-06-12 03:54:36` | Inferred photo `33`; `Pics = 33-34`; confidence `High` |
| <img src="IMG_5746.JPG" alt="IMG_5746.JPG - individual 32 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5746.JPG` | `32` | `HonoluaAdjacentInnerSide`<br>GPS `70` | `2023-06-12 03:54:44` | Inferred photo `34`; `Pics = 33-34`; confidence `High` |
| <img src="IMG_5747.JPG" alt="IMG_5747.JPG - individual 33 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5747.JPG` | `33` | `HonoluaAdjacentInnerSide`<br>GPS `71` | `2023-06-12 04:06:21` | Inferred photo `35`; `Pics = 35-36`; confidence `High` |
| <img src="IMG_5748.JPG" alt="IMG_5748.JPG - individual 33 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5748.JPG` | `33` | `HonoluaAdjacentInnerSide`<br>GPS `71` | `2023-06-12 04:06:27` | Inferred photo `36`; `Pics = 35-36`; confidence `High` |
| <img src="IMG_5749.JPG" alt="IMG_5749.JPG - individual 34 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5749.JPG` | `34` | `HonoluaAdjacentInnerSide`<br>GPS `72` | `2023-06-12 04:18:45` | Inferred photo `37`; `Pics = 37-38`; confidence `High` |
| <img src="IMG_5750.JPG" alt="IMG_5750.JPG - individual 34 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5750.JPG` | `34` | `HonoluaAdjacentInnerSide`<br>GPS `72` | `2023-06-12 04:18:52` | Inferred photo `38`; `Pics = 37-38`; confidence `High` |
| <img src="IMG_5751.JPG" alt="IMG_5751.JPG - individual 35 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5751.JPG` | `35` | `HonoluaAdjacentInnerSide`<br>GPS `73` | `2023-06-12 04:28:28` | Inferred photo `39`; `Pics = 39-40`; confidence `High` |
| <img src="IMG_5752.JPG" alt="IMG_5752.JPG - individual 35 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5752.JPG` | `35` | `HonoluaAdjacentInnerSide`<br>GPS `73` | `2023-06-12 04:28:34` | Inferred photo `40`; `Pics = 39-40`; confidence `High` |
| <img src="IMG_5753.JPG" alt="IMG_5753.JPG - individual 36 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5753.JPG` | `36` | `HonoluaAdjacentInnerSide`<br>GPS `73` | `2023-06-12 04:39:47` | Inferred photo `41`; `Pics = 41-42`; confidence `High` |
| <img src="IMG_5754.JPG" alt="IMG_5754.JPG - individual 36 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5754.JPG` | `36` | `HonoluaAdjacentInnerSide`<br>GPS `73` | `2023-06-12 04:39:54` | Inferred photo `42`; `Pics = 41-42`; confidence `High` |
| <img src="IMG_5755.JPG" alt="IMG_5755.JPG - individual 37 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5755.JPG` | `37` | `HonoluaAdjacentInnerSide`<br>GPS `74` | `2023-06-12 04:47:33` | Inferred photo `43`; `Pics = 43-44`; confidence `High` |
| <img src="IMG_5756.JPG" alt="IMG_5756.JPG - individual 37 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5756.JPG` | `37` | `HonoluaAdjacentInnerSide`<br>GPS `74` | `2023-06-12 04:47:40` | Inferred photo `44`; `Pics = 43-44`; confidence `High` |
| <img src="IMG_5757.JPG" alt="IMG_5757.JPG - individual 38 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5757.JPG` | `38` | `HonoluaAdjacentInnerSide`<br>GPS `74` | `2023-06-12 04:47:51` | Inferred photo `45`; `Pics = 45-46`; confidence `High` |
| <img src="IMG_5758.JPG" alt="IMG_5758.JPG - individual 38 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5758.JPG` | `38` | `HonoluaAdjacentInnerSide`<br>GPS `74` | `2023-06-12 04:56:44` | Inferred photo `46`; `Pics = 45-46`; confidence `High` |
| <img src="IMG_5759.JPG" alt="IMG_5759.JPG - individual 39 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5759.JPG` | `39` | `HonoluaAdjacentInnerSide`<br>GPS `75` | `2023-06-12 04:56:51` | Inferred photo `47`; `Pics = 47-48`; confidence `High` |
| <img src="IMG_5760.JPG" alt="IMG_5760.JPG - individual 39 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5760.JPG` | `39` | `HonoluaAdjacentInnerSide`<br>GPS `75` | `2023-06-12 05:07:17` | Inferred photo `48`; `Pics = 47-48`; confidence `High` |
| <img src="IMG_5761.JPG" alt="IMG_5761.JPG - individual 40 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5761.JPG` | `40` | `HonoluaAdjacentInnerSide`<br>GPS `75` | `2023-06-12 05:07:22` | Inferred photo `49`; `Pics = 49-50`; confidence `High` |
| <img src="IMG_5762.JPG" alt="IMG_5762.JPG - individual 40 at HonoluaAdjacentInnerSide" width="180"><br>`IMG_5762.JPG` | `40` | `HonoluaAdjacentInnerSide`<br>GPS `75` | `2023-06-12 05:19:34` | Inferred photo `50`; `Pics = 49-50`; confidence `High` |
| <img src="IMG_5763.JPG" alt="IMG_5763.JPG - individual 41 at KahuluiBreakwaterConcreteInside" width="180"><br>`IMG_5763.JPG` | `41` | `KahuluiBreakwaterConcreteInside`<br>GPS `75` | `2023-06-12 05:19:39` | Inferred photo `51`; `Pics = 51-52`; confidence `High` |
| <img src="IMG_5764.JPG" alt="IMG_5764.JPG - individual 41 at KahuluiBreakwaterConcreteInside" width="180"><br>`IMG_5764.JPG` | `41` | `KahuluiBreakwaterConcreteInside`<br>GPS `75` | `2023-06-12 05:27:30` | Inferred photo `52`; `Pics = 51-52`; confidence `High` |
| <img src="IMG_5765.JPG" alt="IMG_5765.JPG - individual 42 at KahuluiBreakwaterConcreteInside" width="180"><br>`IMG_5765.JPG` | `42` | `KahuluiBreakwaterConcreteInside`<br>GPS `75` | `2023-06-12 05:27:38` | Inferred photo `53`; `Pics = 53-54`; confidence `High` |
| <img src="IMG_5766.JPG" alt="IMG_5766.JPG - individual 42 at KahuluiBreakwaterConcreteInside" width="180"><br>`IMG_5766.JPG` | `42` | `KahuluiBreakwaterConcreteInside`<br>GPS `75` | `2023-06-12 05:27:44` | Inferred photo `54`; `Pics = 53-54`; confidence `High` |
| <img src="IMG_5767.JPG" alt="IMG_5767.JPG - individual 43 at KahuluiBreakwaterConcreteInside" width="180"><br>`IMG_5767.JPG` | `43` | `KahuluiBreakwaterConcreteInside`<br>GPS `76` | `2023-06-12 05:35:14` | Inferred photo `55`; `Pics = 55-56`; confidence `High` |
| <img src="IMG_5768.JPG" alt="IMG_5768.JPG - individual 43 at KahuluiBreakwaterConcreteInside" width="180"><br>`IMG_5768.JPG` | `43` | `KahuluiBreakwaterConcreteInside`<br>GPS `76` | `2023-06-12 05:35:20` | Inferred photo `56`; `Pics = 55-56`; confidence `High` |
| <img src="IMG_5769.JPG" alt="IMG_5769.JPG - individual 44 at KahuluiBreakwaterConcreteInside" width="180"><br>`IMG_5769.JPG` | `44` | `KahuluiBreakwaterConcreteInside`<br>GPS `76` | `2023-06-12 05:39:36` | Inferred photo `57`; `Pics = 57-58`; confidence `High` |
| <img src="IMG_5770.JPG" alt="IMG_5770.JPG - individual 44 at KahuluiBreakwaterConcreteInside" width="180"><br>`IMG_5770.JPG` | `44` | `KahuluiBreakwaterConcreteInside`<br>GPS `76` | `2023-06-12 05:39:47` | Inferred photo `58`; `Pics = 57-58`; confidence `High` |
| <img src="IMG_5771.JPG" alt="IMG_5771.JPG - individual 45 at KahuluiBreakwaterConcreteInside" width="180"><br>`IMG_5771.JPG` | `45` | `KahuluiBreakwaterConcreteInside`<br>GPS `77` | `2023-06-12 05:39:50` | Inferred photo `59`; `Pics = 59-60`; confidence `Medium` |
