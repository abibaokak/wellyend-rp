# WellyEndEvent RP

Ресурспак для плагина **WellyEndEvent**: кастомные модели предметов Энда.

## Файлы

- `WellyEndEventRP.zip` — готовый архив, который скачивает плагин.
- `build-rp.ps1` — генератор архива (текстуры 32×32, иконка 128×128, `pack.mcmeta`).

## RAW URL для плагина

```
https://raw.githubusercontent.com/abibaokak/wellyend-rp/main/WellyEndEventRP.zip
```

## Контрольные суммы

- SHA-1:  `445685fd883513531f61f65a74a6a286224fc56a`
- SHA-256: `ce68ee6c47809bd894c07cd702bc4fe90e48cfa1308dd75d845ddb8869d0c1b2`
- Размер: 5899 байт

## Что меняет пак

| Предмет | material | `custom_model_data` | Модель |
|---|---|---:|---|
| Осколок Энда | `PAPER` | 2001 | `welly:item/end_shard` |
| Древний обломок | `NETHERITE_SCRAP` | 2002 | `welly:item/ancient_scrap` |
| Жемчуг Края | `ENDER_PEARL` | 2003 | `welly:item/end_pearl` |
| Дымовая бомба | `SNOWBALL` | 2004 | `welly:item/smoke_bomb` |

`pack_format: 75`, `supported_formats: [48,75]` — совместимо с Paper 1.21.11.

Плагин выдаёт этот пак принудительно (`force = true`) и кикает игрока, если он
отказался или не смог его загрузить.
