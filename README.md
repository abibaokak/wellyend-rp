# WellyEndEvent RP

Ресурспак для плагина **WellyEndEvent**: кастомные модели предметов Энда.

## Файлы

- `WellyEndEventRP.zip` — готовый архив, который скачивает плагин.
- `build-rp.ps1` — генератор архива (текстуры 32×32, иконка 128×128, `pack.mcmeta`).

## RAW URL для плагина

```
https://raw.githubusercontent.com/abibaokak/wellyend-rp/main/WellyEndEventRP.zip?v=9a9c0e4f
```

## Контрольные суммы

- SHA-1:  `9a9c0e4f381b8ff967ae6de1c9ee7e3471e2be56`
- SHA-256: `0841718296196233cb0fefd3f03b3073af90e5f6adb5951280c8d2479f976adc`
- Размер: 5931 байт

## Что меняет пак

| Предмет | material | `custom_model_data` | Модель |
|---|---|---:|---|
| Осколок Энда | `PAPER` | 2001 | `welly:item/end_shard` |
| Древний обломок | `NETHERITE_SCRAP` | 2002 | `welly:item/ancient_scrap` |
| Жемчуг Края | `ENDER_PEARL` | 2003 | `welly:item/end_pearl` |
| Дымовая бомба | `SNOWBALL` | 2004 | `welly:item/smoke_bomb` |

`pack_format: 75`, `supported_formats` задан объектом `34..99`, все JSON
валидны. Описание пака на латинице: кириллица в старом генераторе била
`pack.mcmeta` и приводила к `FAILED_RELOAD` у клиентов.

Плагин предлагает этот пак при входе (не принудительно) и не кикает за отказ.
