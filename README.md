# WellyEndEvent RP

Ресурспак для плагина **WellyEndEvent**: кастомные модели предметов Энда.

## Файлы

- `WellyEndEventRP.zip` — готовый архив, который скачивает плагин.
- `build-rp.ps1` — генератор архива (текстуры 32×32, иконка 128×128, `pack.mcmeta`).

## RAW URL для плагина

```
https://raw.githubusercontent.com/abibaokak/wellyend-rp/main/WellyEndEventRP.zip?v=d8a119c2
```

## Контрольные суммы

- SHA-1:  `d8a119c2086068f1e5e07b5566be857733849924`
- SHA-256: `b301a9b5e2a352159411b4120bd70e4a21d548fb09dac8e2a0e51d616c6f5333`
- Размер: 7219 байт

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

## Важно для Paper 1.21.4+

Начиная с 1.21.4 старые `assets/minecraft/models/item/*.json` с `overrides`
больше не выбирают модель по `custom_model_data`. Пак содержит **оба формата**:

- `assets/minecraft/models/item/*.json` — для клиентов 1.21.3 и ниже;
- `assets/minecraft/items/*.json` — `minecraft:range_dispatch` по
  `minecraft:custom_model_data` (поле `floats`), который работает на 1.21.11.

Без второго формата предмет остаётся обычной бумагой/компасом, даже если пак
успешно загружен. `setCustomModelData(int)` попадает в `floats[0]`.

Плагин выдаёт этот пак принудительно (`force: true`) и кикает при отказе или
ошибке загрузки (`kick-on-decline: true`).
